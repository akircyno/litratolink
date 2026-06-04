# Potoos Supabase SQL and RLS Planning Document v1.0

## 1. Document Purpose

This document explains the planned Supabase database setup for Potoos.

This document is based on:

* Potoos Master Product Plan v1.0
* Potoos System Architecture Document v1.0
* Potoos Database Design Document v1.0
* Potoos UI/UX Flow Document v1.0
* Potoos Development Roadmap v1.0
* Potoos Codex Development Instructions v1.0
* Potoos API and Edge Functions Specification v1.0

The goal of this document is to prepare the actual Supabase implementation.

This document defines:

* Table creation plan
* Column planning
* Enum values
* Relationships
* Indexes
* Row Level Security rules
* Helper functions
* Database triggers
* Cleanup jobs
* Seed data
* Implementation order

This is still a planning document. Actual SQL can be created after this.

---

## 2. Database Platform

Potoos will use:

**Supabase Postgres**

Supabase will be used for:

* User profiles
* Albums
* Album members
* Album invites
* Media file metadata
* Storage references
* Notifications
* Device tokens
* Activity logs
* Future monetization preparation

The actual photos and videos will not be stored directly in Postgres.

Original files will be stored in:

**Potoos-managed Google Drive / Google One-backed storage**

Postgres will only store file metadata and storage references.

---

## 3. Main Database Principle

The main database principle is:

**Album membership controls access.**

If a user is not an active member of an album, they must not be able to:

* See the album
* See the files
* Download files
* Upload files
* Invite members
* Delete files
* Restore files
* Manage roles

This must be enforced by Supabase Row Level Security.

The frontend UI is not enough for security.

---

## 4. Supabase Schema Plan

Recommended schema:

Use the default `public` schema for main app tables.

Main tables:

1. `user_profiles`
2. `albums`
3. `album_members`
4. `album_invites`
5. `storage_providers`
6. `storage_objects`
7. `media_files`
8. `media_thumbnails`
9. `device_tokens`
10. `notifications`
11. `activity_logs`

Future tables:

12. `plans`
13. `subscriptions`
14. `billing_history`
15. `storage_usage`

Future tables are planned but not required for V1.

---

## 5. Enum Values

Using enums can make data cleaner.

Recommended enums:

### 5.1 Album Role

Name:

`album_role`

Values:

* `admin`
* `contributor`
* `viewer`

---

### 5.2 Invite Status

Name:

`invite_status`

Values:

* `pending`
* `accepted`
* `declined`
* `expired`
* `cancelled`

---

### 5.3 File Type

Name:

`media_file_type`

Values:

* `photo`
* `video`

---

### 5.4 Upload Status

Name:

`upload_status`

Values:

* `pending`
* `uploading`
* `completed`
* `failed`

---

### 5.5 Storage Provider Type

Name:

`storage_provider_type`

Values:

* `google_drive`
* `cloudflare_r2`
* `google_cloud_storage`
* `supabase_storage`

V1 will use:

* `google_drive`

---

### 5.6 Platform Type

Name:

`platform_type`

Values:

* `ios`
* `android`
* `web`

---

### 5.7 Notification Type

Name:

`notification_type`

Values:

* `album_invite`
* `invite_accepted`
* `new_upload`
* `upload_complete`
* `member_added`
* `member_removed`
* `role_changed`
* `file_deleted`
* `file_restored`

---

### 5.8 Activity Action

Name:

`activity_action`

Values:

* `album_created`
* `album_updated`
* `album_deleted`
* `member_invited`
* `invite_accepted`
* `member_removed`
* `role_changed`
* `file_upload_started`
* `file_upload_completed`
* `file_deleted`
* `file_restored`
* `file_downloaded`

---

## 6. Table Plan: `user_profiles`

## 6.1 Purpose

Stores app profile data for each user.

This table connects to Supabase `auth.users`.

---

## 6.2 Planned Columns

| Column           | Type        | Rule                              |
| ---------------- | ----------- | --------------------------------- |
| `id`             | uuid        | Primary key, same as auth user ID |
| `email`          | text        | Required                          |
| `display_name`   | text        | Optional                          |
| `avatar_url`     | text        | Optional                          |
| `created_at`     | timestamptz | Default now                       |
| `updated_at`     | timestamptz | Auto update                       |
| `last_active_at` | timestamptz | Optional                          |
| `is_active`      | boolean     | Default true                      |
| `is_banned`      | boolean     | Default false                     |

---

## 6.3 Relationship

`user_profiles.id` references `auth.users.id`.

---

## 6.4 RLS Rules

Enable RLS.

Rules:

* User can read their own profile.
* User can update their own profile.
* Album members can see limited profile info of other members in the same album.
* User cannot update another user’s profile.

---

# 7. Table Plan: `albums`

## 7.1 Purpose

Stores private albums.

---

## 7.2 Planned Columns

| Column                | Type        | Rule                              |
| --------------------- | ----------- | --------------------------------- |
| `id`                  | uuid        | Primary key                       |
| `owner_id`            | uuid        | References `user_profiles.id`     |
| `name`                | text        | Required                          |
| `description`         | text        | Optional                          |
| `cover_file_id`       | uuid        | Optional                          |
| `storage_provider_id` | uuid        | References `storage_providers.id` |
| `created_at`          | timestamptz | Default now                       |
| `updated_at`          | timestamptz | Auto update                       |
| `is_deleted`          | boolean     | Default false                     |
| `deleted_at`          | timestamptz | Optional                          |
| `delete_expires_at`   | timestamptz | Optional                          |
| `is_archived`         | boolean     | Default false                     |

---

## 7.3 Relationships

* `owner_id` references `user_profiles.id`
* `storage_provider_id` references `storage_providers.id`
* `cover_file_id` may reference `media_files.id`

---

## 7.4 RLS Rules

Enable RLS.

Rules:

* User can read an album only if they are an active member.
* User can create an album where `owner_id` is their own user ID.
* Only album Admin can update album details.
* Only album Admin can soft delete album.
* Deleted albums should not appear in normal album queries.

---

## 7.5 Special Rule

When a user creates an album, the database or Edge Function must also create an `album_members` record.

The creator must become:

`admin`

---

# 8. Table Plan: `album_members`

## 8.1 Purpose

Stores album membership and roles.

This is one of the most important tables.

---

## 8.2 Planned Columns

| Column       | Type        | Rule                                    |
| ------------ | ----------- | --------------------------------------- |
| `id`         | uuid        | Primary key                             |
| `album_id`   | uuid        | References `albums.id`                  |
| `user_id`    | uuid        | References `user_profiles.id`           |
| `role`       | album_role  | Required                                |
| `invited_by` | uuid        | References `user_profiles.id`, optional |
| `joined_at`  | timestamptz | Default now                             |
| `removed_at` | timestamptz | Optional                                |
| `is_active`  | boolean     | Default true                            |

---

## 8.3 Unique Rule

There should be only one active membership per user per album.

Recommended unique constraint:

* `album_id`
* `user_id`

---

## 8.4 RLS Rules

Enable RLS.

Rules:

* User can read album members if they are an active member of the same album.
* Admin can add members.
* Admin can update roles.
* Admin can remove members.
* User cannot remove themselves if they are the last Admin.
* Non-admin users cannot manage members.

---

## 8.5 Role Rules

Allowed values:

* `admin`
* `contributor`
* `viewer`

---

## 8.6 Admin Safety Rule

Every active album must have at least one active Admin.

The database must prevent:

* Removing the last Admin
* Changing the last Admin to another role
* Deactivating the last Admin membership

This can be handled by:

* Edge Function validation
* Database trigger
* Database helper function

---

# 9. Table Plan: `album_invites`

## 9.1 Purpose

Stores album invite records.

---

## 9.2 Planned Columns

| Column         | Type          | Rule                          |
| -------------- | ------------- | ----------------------------- |
| `id`           | uuid          | Primary key                   |
| `album_id`     | uuid          | References `albums.id`        |
| `email`        | text          | Required, lowercase           |
| `role`         | album_role    | Required                      |
| `invited_by`   | uuid          | References `user_profiles.id` |
| `status`       | invite_status | Default `pending`             |
| `created_at`   | timestamptz   | Default now                   |
| `accepted_at`  | timestamptz   | Optional                      |
| `declined_at`  | timestamptz   | Optional                      |
| `cancelled_at` | timestamptz   | Optional                      |
| `expires_at`   | timestamptz   | Required or default           |

---

## 9.3 RLS Rules

Enable RLS.

Rules:

* Admin can create invite for their album.
* Admin can view invites for their album.
* Invited user can view invite only if their auth email matches invite email.
* Invited user can accept invite only if email matches.
* Admin can cancel pending invites.
* Expired invites cannot be accepted.

---

## 9.4 Invite Email Rule

Emails should be saved in lowercase.

Example:

`Friend@Email.com`

should be saved as:

`friend@email.com`

This avoids email matching problems.

---

# 10. Table Plan: `storage_providers`

## 10.1 Purpose

Stores storage provider options.

V1 uses Google Drive-backed storage.

This table makes future migration easier.

---

## 10.2 Planned Columns

| Column       | Type                  | Rule         |
| ------------ | --------------------- | ------------ |
| `id`         | uuid                  | Primary key  |
| `name`       | text                  | Required     |
| `type`       | storage_provider_type | Required     |
| `is_active`  | boolean               | Default true |
| `created_at` | timestamptz           | Default now  |

---

## 10.3 V1 Seed Data

Create one default provider:

| Name              | Type           |
| ----------------- | -------------- |
| Google Drive Main | `google_drive` |

---

## 10.4 RLS Rules

Normal users do not need to manage this table.

Recommended:

* Users may read active provider names only if needed.
* Only backend/service role can insert, update, or delete providers.

---

# 11. Table Plan: `storage_objects`

## 11.1 Purpose

Stores references to actual files in storage.

This table does not store the actual file.

It stores the provider file ID or path.

---

## 11.2 Planned Columns

| Column               | Type        | Rule                                      |
| -------------------- | ----------- | ----------------------------------------- |
| `id`                 | uuid        | Primary key                               |
| `provider_id`        | uuid        | References `storage_providers.id`         |
| `provider_file_id`   | text        | Google Drive file ID or future object key |
| `provider_folder_id` | text        | Optional                                  |
| `storage_path`       | text        | Logical path                              |
| `file_size_bytes`    | bigint      | Required                                  |
| `mime_type`          | text        | Required                                  |
| `checksum`           | text        | Optional                                  |
| `created_at`         | timestamptz | Default now                               |
| `is_deleted`         | boolean     | Default false                             |
| `deleted_at`         | timestamptz | Optional                                  |

---

## 11.3 RLS Rules

This table should be protected.

Rules:

* Users should not directly access storage objects unless allowed through related media file access.
* Inserts and updates should mostly happen through Edge Functions.
* Users should not see raw permanent storage credentials.
* Provider file IDs should not be exposed unless needed and safe.

---

# 12. Table Plan: `media_files`

## 12.1 Purpose

Stores media file metadata.

The actual original file is stored in Google Drive-backed storage.

---

## 12.2 Planned Columns

| Column                   | Type            | Rule                            |
| ------------------------ | --------------- | ------------------------------- |
| `id`                     | uuid            | Primary key                     |
| `album_id`               | uuid            | References `albums.id`          |
| `uploader_id`            | uuid            | References `user_profiles.id`   |
| `storage_object_id`      | uuid            | References `storage_objects.id` |
| `original_filename`      | text            | Required                        |
| `file_type`              | media_file_type | Required                        |
| `mime_type`              | text            | Required                        |
| `file_size_bytes`        | bigint          | Required                        |
| `width`                  | integer         | Optional                        |
| `height`                 | integer         | Optional                        |
| `duration_seconds`       | numeric         | Optional for videos             |
| `upload_status`          | upload_status   | Default `pending`               |
| `created_at`             | timestamptz     | Default now                     |
| `uploaded_at`            | timestamptz     | Optional                        |
| `updated_at`             | timestamptz     | Auto update                     |
| `is_deleted`             | boolean         | Default false                   |
| `deleted_at`             | timestamptz     | Optional                        |
| `delete_expires_at`      | timestamptz     | Optional                        |
| `deleted_by`             | uuid            | Optional                        |
| `restored_at`            | timestamptz     | Optional                        |
| `permanently_deleted_at` | timestamptz     | Optional                        |

---

## 12.3 RLS Rules

Enable RLS.

Rules:

* Album members can read completed, active files in their albums.
* Admin and Contributor can create file records in albums where they are members.
* Viewer cannot create file records.
* Only uploader can soft delete their own file.
* Only uploader can restore their own deleted file.
* User can see their own deleted files in Trash.
* Non-uploader cannot see deleted files unless future admin audit feature is added.
* Permanently deleted files should not appear in normal queries.

---

## 12.4 Upload Status Rules

Allowed values:

* `pending`
* `uploading`
* `completed`
* `failed`

Normal album view should only show:

`completed`

and

`is_deleted = false`

---

# 13. Table Plan: `media_thumbnails`

## 13.1 Purpose

Stores thumbnail references for previews.

Thumbnails are separate from original files.

---

## 13.2 Planned Columns

| Column              | Type        | Rule                            |
| ------------------- | ----------- | ------------------------------- |
| `id`                | uuid        | Primary key                     |
| `media_file_id`     | uuid        | References `media_files.id`     |
| `storage_object_id` | uuid        | References `storage_objects.id` |
| `width`             | integer     | Optional                        |
| `height`            | integer     | Optional                        |
| `mime_type`         | text        | Required                        |
| `file_size_bytes`   | bigint      | Required                        |
| `created_at`        | timestamptz | Default now                     |

---

## 13.3 RLS Rules

Rules:

* Album members can read thumbnails for files they can access.
* Users cannot access thumbnails from albums they are not part of.
* Thumbnail access must not give access to original file automatically.
* Download original must not use thumbnail.

---

# 14. Table Plan: `device_tokens`

## 14.1 Purpose

Stores device tokens for push notifications.

---

## 14.2 Planned Columns

| Column         | Type          | Rule                          |
| -------------- | ------------- | ----------------------------- |
| `id`           | uuid          | Primary key                   |
| `user_id`      | uuid          | References `user_profiles.id` |
| `device_token` | text          | Required                      |
| `platform`     | platform_type | Required                      |
| `device_name`  | text          | Optional                      |
| `is_active`    | boolean       | Default true                  |
| `created_at`   | timestamptz   | Default now                   |
| `last_used_at` | timestamptz   | Optional                      |
| `revoked_at`   | timestamptz   | Optional                      |

---

## 14.3 RLS Rules

Enable RLS.

Rules:

* Users can only read their own device tokens.
* Users can only add their own device tokens.
* Users can only update or remove their own device tokens.
* Backend can read active tokens when sending notifications.

---

# 15. Table Plan: `notifications`

## 15.1 Purpose

Stores notification records.

---

## 15.2 Planned Columns

| Column          | Type              | Rule                          |
| --------------- | ----------------- | ----------------------------- |
| `id`            | uuid              | Primary key                   |
| `user_id`       | uuid              | References `user_profiles.id` |
| `album_id`      | uuid              | Optional                      |
| `media_file_id` | uuid              | Optional                      |
| `type`          | notification_type | Required                      |
| `title`         | text              | Required                      |
| `body`          | text              | Required                      |
| `is_read`       | boolean           | Default false                 |
| `created_at`    | timestamptz       | Default now                   |
| `sent_at`       | timestamptz       | Optional                      |
| `read_at`       | timestamptz       | Optional                      |

---

## 15.3 RLS Rules

Enable RLS.

Rules:

* Users can only read their own notifications.
* Users can mark their own notifications as read.
* Users cannot read other users’ notifications.
* Backend can create notifications for target users.

---

## 15.4 Privacy Rule

Do not store sensitive file names in notification title or body.

Good:

`New memories were added to your album.`

Bad:

`IMG_1234_private.jpg was uploaded.`

---

# 16. Table Plan: `activity_logs`

## 16.1 Purpose

Stores important app actions.

Used for debugging, security, and future admin tools.

---

## 16.2 Planned Columns

| Column          | Type            | Rule                    |
| --------------- | --------------- | ----------------------- |
| `id`            | uuid            | Primary key             |
| `actor_id`      | uuid            | User who did the action |
| `album_id`      | uuid            | Optional                |
| `media_file_id` | uuid            | Optional                |
| `action`        | activity_action | Required                |
| `metadata`      | jsonb           | Optional                |
| `created_at`    | timestamptz     | Default now             |

---

## 16.3 RLS Rules

For V1:

* Normal users do not need full access to activity logs.
* Backend can insert activity logs.
* Future admin dashboard may show safe activity logs.
* Do not expose private file content in logs.

---

# 17. Future Table Plan: `plans`

## 17.1 Purpose

Future monetization table.

Not needed for V1.

---

## 17.2 Possible Columns

| Column                | Type        |
| --------------------- | ----------- |
| `id`                  | uuid        |
| `name`                | text        |
| `price`               | numeric     |
| `currency`            | text        |
| `billing_cycle`       | text        |
| `album_limit`         | integer     |
| `member_limit`        | integer     |
| `storage_limit_bytes` | bigint      |
| `is_active`           | boolean     |
| `created_at`          | timestamptz |

---

## 17.3 Rule

Do not implement payments in V1.

This table is only for future planning.

---

# 18. Future Table Plan: `subscriptions`

## 18.1 Purpose

Stores future user subscriptions.

Not needed for V1.

---

## 18.2 Possible Columns

| Column       | Type        |
| ------------ | ----------- |
| `id`         | uuid        |
| `user_id`    | uuid        |
| `plan_id`    | uuid        |
| `status`     | text        |
| `started_at` | timestamptz |
| `ends_at`    | timestamptz |
| `renewed_at` | timestamptz |
| `created_at` | timestamptz |

---

# 19. Future Table Plan: `billing_history`

## 19.1 Purpose

Stores future billing records.

Not needed for V1.

---

## 19.2 Possible Columns

| Column             | Type        |
| ------------------ | ----------- |
| `id`               | uuid        |
| `user_id`          | uuid        |
| `subscription_id`  | uuid        |
| `amount`           | numeric     |
| `currency`         | text        |
| `status`           | text        |
| `payment_provider` | text        |
| `created_at`       | timestamptz |

---

# 20. Future Table Plan: `storage_usage`

## 20.1 Purpose

Tracks storage use.

This can be useful in V1 or soon after V1.

---

## 20.2 Possible Columns

| Column       | Type        |
| ------------ | ----------- |
| `id`         | uuid        |
| `user_id`    | uuid        |
| `album_id`   | uuid        |
| `used_bytes` | bigint      |
| `file_count` | integer     |
| `updated_at` | timestamptz |

---

## 20.3 Recommendation

This table is not required for the first proof of concept.

But it is useful for monitoring storage growth.

It should be added before public App Store release if possible.

---

# 21. Helper Function Plan

Helper functions make RLS easier and cleaner.

Recommended helper functions:

---

## 21.1 `is_album_member(album_id, user_id)`

Purpose:

Checks if a user is an active member of an album.

Returns:

* true
* false

Used for:

* Reading albums
* Reading media files
* Reading members
* Download access

---

## 21.2 `get_album_role(album_id, user_id)`

Purpose:

Gets the user role in an album.

Returns:

* `admin`
* `contributor`
* `viewer`
* null if not member

Used for:

* Upload permission
* Invite permission
* Member management
* Album update

---

## 21.3 `is_album_admin(album_id, user_id)`

Purpose:

Checks if user is active Admin in album.

Returns:

* true
* false

Used for:

* Invite
* Role change
* Remove member
* Rename album
* Delete album

---

## 21.4 `can_upload_to_album(album_id, user_id)`

Purpose:

Checks if user can upload.

Returns true if user role is:

* `admin`
* `contributor`

Returns false if user role is:

* `viewer`
* null

---

## 21.5 `is_file_uploader(media_file_id, user_id)`

Purpose:

Checks if user uploaded a file.

Used for:

* Delete file
* Restore file

---

## 21.6 `album_has_other_admin(album_id, user_id)`

Purpose:

Checks if an album has another active Admin besides the selected user.

Used to prevent:

* Removing the last Admin
* Changing the last Admin to Contributor or Viewer

---

# 22. Trigger Plan

Triggers can automate important tasks.

---

## 22.1 Update `updated_at`

Tables needing auto `updated_at`:

* `user_profiles`
* `albums`
* `media_files`

Trigger:

When row is updated, set `updated_at = now()`.

---

## 22.2 Create Profile After Auth Signup

Option A:

Create profile in Edge Function after login.

Option B:

Create profile using database trigger from `auth.users`.

Recommended for V1:

**Option A: Edge Function or app-controlled profile creation**

Reason:

It is easier to control and debug during early development.

---

## 22.3 Prevent Last Admin Removal

Trigger should prevent:

* Removing last Admin
* Changing last Admin role
* Deactivating last Admin membership

This protects album ownership.

---

## 22.4 Set Delete Expiration

When a file is soft deleted:

Set:

`delete_expires_at = deleted_at + 30 days`

This can be handled by:

* Edge Function
* Database trigger

Recommended for V1:

Use Edge Function first.

---

# 23. Index Plan

Indexes help make the app faster.

---

## 23.1 `album_members`

Recommended indexes:

* `album_members_album_id_idx` on `album_id`
* `album_members_user_id_idx` on `user_id`
* `album_members_album_user_idx` on `album_id, user_id`
* `album_members_album_role_idx` on `album_id, role`

Used for:

* Permission checks
* My albums
* Role checks

---

## 23.2 `albums`

Recommended indexes:

* `albums_owner_id_idx` on `owner_id`
* `albums_is_deleted_idx` on `is_deleted`
* `albums_updated_at_idx` on `updated_at`

Used for:

* Album list
* Sorting
* Filtering deleted albums

---

## 23.3 `album_invites`

Recommended indexes:

* `album_invites_email_idx` on `email`
* `album_invites_album_id_idx` on `album_id`
* `album_invites_status_idx` on `status`
* `album_invites_expires_at_idx` on `expires_at`

Used for:

* Pending invites
* Invite expiration

---

## 23.4 `media_files`

Recommended indexes:

* `media_files_album_id_idx` on `album_id`
* `media_files_uploader_id_idx` on `uploader_id`
* `media_files_album_deleted_idx` on `album_id, is_deleted`
* `media_files_upload_status_idx` on `upload_status`
* `media_files_delete_expires_at_idx` on `delete_expires_at`

Used for:

* Album gallery
* Trash
* Cleanup job

---

## 23.5 `device_tokens`

Recommended indexes:

* `device_tokens_user_id_idx` on `user_id`
* `device_tokens_token_idx` on `device_token`
* `device_tokens_active_idx` on `is_active`

---

## 23.6 `notifications`

Recommended indexes:

* `notifications_user_id_idx` on `user_id`
* `notifications_user_read_idx` on `user_id, is_read`
* `notifications_created_at_idx` on `created_at`

---

# 24. RLS Policy Plan

This section gives simple English RLS rules.

Actual SQL policies will be created later.

---

## 24.1 `user_profiles` RLS

Policies:

1. User can read their own profile.
2. User can update their own profile.
3. User can read limited profiles of users in the same album.
4. User cannot update another user’s profile.

---

## 24.2 `albums` RLS

Policies:

1. User can read album if active member.
2. User can create album if `owner_id = auth.uid()`.
3. Admin can update album.
4. Admin can soft delete album.
5. Non-members cannot read album.

---

## 24.3 `album_members` RLS

Policies:

1. User can read members if they are active member of same album.
2. Admin can add members.
3. Admin can update member roles.
4. Admin can remove members.
5. User cannot manage members if not Admin.

---

## 24.4 `album_invites` RLS

Policies:

1. Admin can create invite for their album.
2. Admin can read invites for their album.
3. Invited user can read invite if invite email matches auth email.
4. Invited user can accept or decline invite if email matches.
5. Admin can cancel invite.

---

## 24.5 `media_files` RLS

Policies:

1. Album members can read active completed files in their albums.
2. Uploader can read their own deleted files in Trash.
3. Admin and Contributor can create file records.
4. Only uploader can soft delete their own file.
5. Only uploader can restore their own file.
6. Non-members cannot read files.

---

## 24.6 `media_thumbnails` RLS

Policies:

1. Album members can read thumbnails for files they can access.
2. Non-members cannot read thumbnails.
3. Thumbnail access does not give original file download access.

---

## 24.7 `storage_objects` RLS

Policies:

1. Users should not directly read raw storage object data unless needed.
2. Access should normally happen through Edge Functions.
3. Backend/service role can insert and update storage objects.

---

## 24.8 `device_tokens` RLS

Policies:

1. User can read their own device tokens.
2. User can insert their own device token.
3. User can update their own device token.
4. User can delete or revoke their own device token.

---

## 24.9 `notifications` RLS

Policies:

1. User can read their own notifications.
2. User can update read status for their own notifications.
3. User cannot read other users’ notifications.
4. Backend can create notifications.

---

## 24.10 `activity_logs` RLS

Policies for V1:

1. Backend can insert logs.
2. Normal users do not need full log access.
3. Future admin dashboard can add safe log viewing.

---

# 25. Database Views Plan

Views can make app queries easier.

Possible views:

---

## 25.1 `my_albums_view`

Purpose:

Shows albums where current user is active member.

Includes:

* Album ID
* Album name
* Cover file
* User role
* File count
* Member count
* Last updated

---

## 25.2 `album_files_view`

Purpose:

Shows active files in an album.

Includes:

* File ID
* Album ID
* Uploader name
* Thumbnail info
* File type
* Upload date
* File size

Only active files:

* `is_deleted = false`
* `upload_status = completed`

---

## 25.3 `my_trash_view`

Purpose:

Shows deleted files uploaded by current user.

Includes:

* File ID
* Album name
* Deleted date
* Restore deadline

Only files where:

* `uploader_id = auth.uid()`
* `is_deleted = true`
* `delete_expires_at` has not passed

---

## 25.4 `pending_invites_view`

Purpose:

Shows invites for current user email.

Only invites where:

* email matches logged-in user email
* status is pending
* not expired

---

# 26. Cleanup Job Plan

## 26.1 Expired Deleted Files Cleanup

Purpose:

Permanently delete files after 30 days in Trash.

Schedule:

* Once per day

Process:

1. Find files where `is_deleted = true`.
2. Check `delete_expires_at < now()`.
3. Check `permanently_deleted_at is null`.
4. Delete or mark storage object as deleted.
5. Set `permanently_deleted_at`.
6. Add activity log.

---

## 26.2 Expired Invites Cleanup

Purpose:

Mark expired invites as expired.

Schedule:

* Once per day or when invite is checked

Process:

1. Find invites where status is `pending`.
2. Check `expires_at < now()`.
3. Set status to `expired`.

---

# 27. Seed Data Plan

V1 should seed:

## 27.1 Storage Provider

Create one active storage provider:

Name:

`Google Drive Main`

Type:

`google_drive`

---

## 27.2 Optional Test Data

For local or staging only:

* Test user profile
* Test album
* Test album member
* Test media file metadata

Do not seed fake test data into production.

---

# 28. Data Validation Plan

## 28.1 Required Fields

Important required fields:

* User email
* Album name
* Album owner
* Album member role
* Invite email
* Invite role
* Media file album ID
* Media file uploader ID
* Storage object ID
* Original filename
* MIME type
* File size
* File type

---

## 28.2 File Size Rule

File size should be greater than 0.

---

## 28.3 Album Name Rule

Album name should not be empty.

Recommended limit:

* 1 to 100 characters

---

## 28.4 Email Rule

Invite email must be valid.

Email should be saved lowercase.

---

## 28.5 Role Rule

Role must be one of:

* `admin`
* `contributor`
* `viewer`

---

# 29. Implementation Order

Recommended Supabase build order:

---

## Step 1: Create Enums

Create enum types first:

* `album_role`
* `invite_status`
* `media_file_type`
* `upload_status`
* `storage_provider_type`
* `platform_type`
* `notification_type`
* `activity_action`

---

## Step 2: Create Core Tables

Create:

* `user_profiles`
* `storage_providers`
* `albums`
* `album_members`

---

## Step 3: Create Invite Tables

Create:

* `album_invites`

---

## Step 4: Create Storage and Media Tables

Create:

* `storage_objects`
* `media_files`
* `media_thumbnails`

---

## Step 5: Create Notification Tables

Create:

* `device_tokens`
* `notifications`

---

## Step 6: Create Activity Logs

Create:

* `activity_logs`

---

## Step 7: Add Indexes

Add all important indexes.

---

## Step 8: Add Helper Functions

Add:

* `is_album_member`
* `get_album_role`
* `is_album_admin`
* `can_upload_to_album`
* `is_file_uploader`
* `album_has_other_admin`

---

## Step 9: Enable RLS

Enable Row Level Security on all protected tables.

---

## Step 10: Add RLS Policies

Add RLS policies table by table.

---

## Step 11: Add Triggers

Add:

* `updated_at` trigger
* last Admin protection trigger if needed

---

## Step 12: Add Seed Data

Seed:

* Google Drive Main storage provider

---

## Step 13: Test RLS

Test:

* Admin access
* Contributor access
* Viewer access
* Non-member blocked
* Removed member blocked
* Uploader-only restore
* Invite email matching

---

# 30. RLS Testing Checklist

Before using the app, test these:

## 30.1 Album Access

* Member can see album.
* Non-member cannot see album.
* Removed member cannot see album.

## 30.2 File Access

* Member can see active files.
* Non-member cannot see files.
* Deleted files are hidden from album.
* Uploader can see own deleted files in Trash.
* Other users cannot see uploader Trash.

## 30.3 Upload Access

* Admin can upload.
* Contributor can upload.
* Viewer cannot upload.
* Non-member cannot upload.

## 30.4 Invite Access

* Admin can invite.
* Contributor cannot invite.
* Viewer cannot invite.
* Invite email must match login email.

## 30.5 Delete and Restore

* Uploader can delete own file.
* Uploader can restore own file.
* Admin cannot restore another user’s file.
* Viewer cannot delete or restore.

## 30.6 Notification Access

* User can see own notifications.
* User cannot see another user’s notifications.

---

# 31. Important Supabase Notes

## 31.1 Service Role Key

The Supabase service role key must never be placed in Flutter.

It should only be used in:

* Supabase Edge Functions
* Secure backend environment

---

## 31.2 Anon Key

The Supabase anon key can be used in Flutter.

But RLS must be enabled to protect data.

---

## 31.3 Direct Client Queries

Flutter can directly query some tables if RLS is correct.

Good direct queries:

* My albums
* Album files
* Notifications
* My trash

Sensitive actions should use Edge Functions.

Sensitive actions:

* Upload session creation
* Download access generation
* Invite acceptance
* Role changes
* Storage operations

---

# 32. Main RLS Rule

The main RLS rule is:

**Never trust the frontend only.**

Even if the button is hidden in Flutter, the database must still block the action if the user has no permission.

---

# 33. Final SQL and RLS Decision Summary

Confirmed decisions:

* Use Supabase Postgres.
* Use public schema for main app tables.
* Use Supabase Auth users linked to `user_profiles`.
* Use enums for roles and statuses.
* Use album membership as the main access control.
* Enable RLS on important tables.
* Use helper functions for role checks.
* Use Edge Functions for sensitive actions.
* Use Google Drive-backed storage for V1.
* Store only metadata and storage references in Postgres.
* Keep thumbnails separate from originals.
* Only uploader can delete and restore their own file.
* Deleted files are restorable for 30 days.
* Admin cannot restore another user’s file.
* Every album must have at least one Admin.
* No social media tables for V1.
* Future monetization tables are planned but not implemented.

---

## 34. Next Recommended Document

The next recommended document is:

**Potoos App Store and TestFlight Preparation Document v1.0**

This document should define:

* Apple Developer requirements
* TestFlight setup
* App Store listing needs
* App icons
* Screenshots
* Privacy policy needs
* Terms of use needs
* iOS permission text
* Release checklist
