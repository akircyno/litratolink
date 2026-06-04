# Potoos Database Design Document v1.0

## 1. Document Purpose

This document explains the database design for Potoos.

This document is based on:

* Potoos Master Product Plan v1.0
* Potoos System Architecture Document v1.0

The goal of this document is to define:

* Main database tables
* Table purposes
* Important columns
* Relationships between tables
* User roles
* Album permissions
* Upload rules
* Download rules
* Soft delete rules
* Invite rules
* Notification tables
* Future-ready monetization tables

This is not final SQL code yet. This is the database planning document before actual implementation.

---

## 2. Database System

Potoos will use:

**Supabase Postgres**

Supabase will handle:

* User data
* Album data
* Album members
* Roles
* Invites
* Media file metadata
* Upload status
* Delete status
* Notifications
* Device tokens
* Future subscription records

The actual original photos and videos will not be stored directly inside the database.

The database will only store file information and storage references.

Original files will be stored in:

**Potoos-managed Google Drive / Google One-backed storage**

---

## 3. Main Database Rule

The database must protect this main product rule:

**Only invited album members can access album files.**

The app must not depend only on the Flutter frontend for security.

Supabase Row Level Security must be used to protect private data.

---

## 4. Main Tables Overview

The main tables for V1 are:

1. `user_profiles`
2. `albums`
3. `album_members`
4. `album_invites`
5. `media_files`
6. `media_thumbnails`
7. `device_tokens`
8. `notifications`
9. `activity_logs`
10. `storage_providers`
11. `storage_objects`

Future-ready tables:

12. `plans`
13. `subscriptions`
14. `billing_history`
15. `storage_usage`

The future tables may be planned but not fully used in V1.

---

## 5. Simple Relationship Overview

```text
auth.users
   ↓
user_profiles
   ↓
album_members ← albums
   ↓              ↓
media_files      album_invites
   ↓
media_thumbnails

user_profiles
   ↓
device_tokens
   ↓
notifications
```

Simple explanation:

* A user can create many albums.
* An album can have many members.
* A user can be a member of many albums.
* An album can have many media files.
* A media file belongs to one album.
* A media file has one uploader.
* A media file can have thumbnails.
* A user can have many device tokens.
* A user can receive many notifications.

---

# 6. Table: `user_profiles`

## 6.1 Purpose

This table stores public app profile information for each user.

Supabase already has an internal `auth.users` table.

The `user_profiles` table adds app-specific user details.

---

## 6.2 Important Columns

| Column           | Type      | Purpose                       |
| ---------------- | --------- | ----------------------------- |
| `id`             | uuid      | Same as Supabase auth user ID |
| `email`          | text      | User email                    |
| `display_name`   | text      | User display name             |
| `avatar_url`     | text      | User Google profile photo     |
| `created_at`     | timestamp | When user joined              |
| `updated_at`     | timestamp | Last profile update           |
| `last_active_at` | timestamp | Last activity time            |
| `is_active`      | boolean   | If account is active          |
| `is_banned`      | boolean   | If account is blocked         |

---

## 6.3 Rules

* A user profile is created after first Google login.
* A user can only edit their own profile.
* Other users can only see limited profile info when they share an album.
* Private system data must not be exposed.

---

# 7. Table: `albums`

## 7.1 Purpose

This table stores album information.

An album is a private container for photos and videos.

---

## 7.2 Important Columns

| Column                | Type      | Purpose                               |
| --------------------- | --------- | ------------------------------------- |
| `id`                  | uuid      | Unique album ID                       |
| `owner_id`            | uuid      | User who created the album            |
| `name`                | text      | Album name                            |
| `description`         | text      | Optional album description            |
| `cover_file_id`       | uuid      | Optional album cover                  |
| `created_at`          | timestamp | When album was created                |
| `updated_at`          | timestamp | Last album update                     |
| `deleted_at`          | timestamp | When album was soft deleted           |
| `delete_expires_at`   | timestamp | When album can be permanently deleted |
| `is_deleted`          | boolean   | If album is deleted                   |
| `is_archived`         | boolean   | If album is archived                  |
| `storage_provider_id` | uuid      | Storage provider used for this album  |

---

## 7.3 Rules

* Every user can create their own albums.
* The album creator becomes Admin automatically.
* Albums are private by default.
* There are no public albums in V1.
* Only album members can see the album.
* Only Admin can rename the album.
* Only Admin can delete the album.
* Album deletion should be soft delete first.

---

## 7.4 Album Delete Rule

When an Admin deletes an album:

* The album becomes hidden from normal view.
* Album is marked as deleted.
* Files inside the album become unavailable.
* Album can be recovered for a limited time if this is implemented.
* Permanent delete behavior should be handled carefully.

Recommended V1:

* Soft delete albums.
* Keep deleted album for 30 days.
* Allow only Admin to restore album.
* After 30 days, album may be permanently deleted.

---

# 8. Table: `album_members`

## 8.1 Purpose

This table stores album membership and roles.

This table controls who can access each album.

---

## 8.2 Important Columns

| Column       | Type      | Purpose                       |
| ------------ | --------- | ----------------------------- |
| `id`         | uuid      | Unique membership ID          |
| `album_id`   | uuid      | Album ID                      |
| `user_id`    | uuid      | Member user ID                |
| `role`       | text      | Admin, Contributor, or Viewer |
| `invited_by` | uuid      | User who invited this member  |
| `joined_at`  | timestamp | When user joined              |
| `removed_at` | timestamp | When user was removed         |
| `is_active`  | boolean   | If membership is active       |

---

## 8.3 Role Values

Allowed values:

* `admin`
* `contributor`
* `viewer`

---

## 8.4 Admin Permissions

Admin can:

* View album
* View files
* Download files
* Upload files
* Invite members
* Remove members
* Change member roles
* Rename album
* Delete album
* Manage album settings

Admin cannot:

* Restore files uploaded by other users
* Delete files uploaded by other users in V1
* Bypass backend permission rules

---

## 8.5 Contributor Permissions

Contributor can:

* View album
* View files
* Download files
* Upload files
* Delete their own uploaded files
* Restore their own deleted files within 30 days

Contributor cannot:

* Invite members
* Remove members
* Change member roles
* Delete album
* Restore files uploaded by other users

---

## 8.6 Viewer Permissions

Viewer can:

* View album
* View files
* Download files
* Use Save All

Viewer cannot:

* Upload files
* Delete files
* Restore files
* Invite members
* Remove members
* Change roles
* Delete album

---

## 8.7 Membership Rules

* A user can be a member of many albums.
* A user can have different roles in different albums.
* A removed member cannot access the album.
* A removed member should not receive new notifications from that album.
* Only Admin can change roles.
* Every active album must have at least one Admin.

---

# 9. Table: `album_invites`

## 9.1 Purpose

This table stores album invitations.

An Admin can invite users by email.

---

## 9.2 Important Columns

| Column         | Type      | Purpose                               |
| -------------- | --------- | ------------------------------------- |
| `id`           | uuid      | Unique invite ID                      |
| `album_id`     | uuid      | Album being shared                    |
| `email`        | text      | Email being invited                   |
| `role`         | text      | Role to assign after acceptance       |
| `invited_by`   | uuid      | Admin who sent invite                 |
| `status`       | text      | Pending, accepted, expired, cancelled |
| `created_at`   | timestamp | Invite creation time                  |
| `accepted_at`  | timestamp | Invite acceptance time                |
| `expires_at`   | timestamp | Invite expiration time                |
| `cancelled_at` | timestamp | Invite cancellation time              |

---

## 9.3 Invite Status Values

Allowed values:

* `pending`
* `accepted`
* `expired`
* `cancelled`

---

## 9.4 Invite Rules

* Only Admin can create invites.
* Invite must be linked to one album.
* Invite must include an email.
* Invite must include a role.
* Invited email must match the login email.
* A pending invite does not give access yet.
* Access is only given after invite is accepted.
* Admin can cancel pending invites.
* Expired invites cannot be accepted.
* If accepted, create an `album_members` record.

---

# 10. Table: `media_files`

## 10.1 Purpose

This table stores information about uploaded photos and videos.

It does not store the full file itself.

The actual file is stored in Google Drive-backed storage.

---

## 10.2 Important Columns

| Column                   | Type      | Purpose                               |
| ------------------------ | --------- | ------------------------------------- |
| `id`                     | uuid      | Unique file ID                        |
| `album_id`               | uuid      | Album where file belongs              |
| `uploader_id`            | uuid      | User who uploaded the file            |
| `storage_object_id`      | uuid      | Link to storage object record         |
| `original_filename`      | text      | Original file name                    |
| `file_type`              | text      | photo or video                        |
| `mime_type`              | text      | File MIME type                        |
| `file_size_bytes`        | bigint    | File size                             |
| `width`                  | integer   | Optional image/video width            |
| `height`                 | integer   | Optional image/video height           |
| `duration_seconds`       | numeric   | Video duration if video               |
| `upload_status`          | text      | pending, uploading, completed, failed |
| `created_at`             | timestamp | Upload record creation                |
| `uploaded_at`            | timestamp | Upload completion time                |
| `updated_at`             | timestamp | Last update                           |
| `is_deleted`             | boolean   | If file is soft deleted               |
| `deleted_at`             | timestamp | When file was deleted                 |
| `delete_expires_at`      | timestamp | When file can be permanently deleted  |
| `deleted_by`             | uuid      | User who deleted the file             |
| `restored_at`            | timestamp | When file was restored                |
| `permanently_deleted_at` | timestamp | When file was permanently deleted     |

---

## 10.3 File Type Values

Allowed values:

* `photo`
* `video`

---

## 10.4 Upload Status Values

Allowed values:

* `pending`
* `uploading`
* `completed`
* `failed`

---

## 10.5 Media File Rules

* Every media file belongs to one album.
* Every media file has one uploader.
* Only Admin and Contributor can upload.
* Viewer cannot upload.
* Only album members can view media files.
* Only active media files should appear in normal album view.
* Deleted media files should only appear in the uploader’s Trash view.
* Original files must not be compressed.
* Original files must not be replaced by thumbnails.

---

## 10.6 Delete and Restore Rules

### Delete

Only the original uploader can delete their own file.

When deleted:

* `is_deleted` becomes true.
* `deleted_at` is set.
* `deleted_by` is set.
* `delete_expires_at` is set to 30 days after deletion.
* File disappears from normal album view.

### Restore

Only the original uploader can restore their own deleted file.

When restored:

* `is_deleted` becomes false.
* `deleted_at` becomes null.
* `deleted_by` becomes null.
* `delete_expires_at` becomes null.
* `restored_at` is set.
* File returns to original album view.

### Permanent Delete

After 30 days:

* The file can be permanently deleted from storage.
* The database record should be marked permanently deleted.
* File cannot be restored anymore.

---

# 11. Table: `media_thumbnails`

## 11.1 Purpose

This table stores thumbnail or preview file information.

Thumbnails are for faster viewing only.

They must never replace the original file.

---

## 11.2 Important Columns

| Column              | Type      | Purpose                    |
| ------------------- | --------- | -------------------------- |
| `id`                | uuid      | Unique thumbnail ID        |
| `media_file_id`     | uuid      | Original media file ID     |
| `storage_object_id` | uuid      | Thumbnail storage object   |
| `width`             | integer   | Thumbnail width            |
| `height`            | integer   | Thumbnail height           |
| `mime_type`         | text      | Thumbnail MIME type        |
| `file_size_bytes`   | bigint    | Thumbnail size             |
| `created_at`        | timestamp | When thumbnail was created |

---

## 11.3 Thumbnail Rules

* Thumbnail belongs to one media file.
* Thumbnail is optional but recommended.
* Thumbnail is for preview only.
* Download must never use thumbnail.
* Save All must never use thumbnail.
* Original file must always be used for download.

---

# 12. Table: `storage_providers`

## 12.1 Purpose

This table stores the storage providers used by Potoos.

V1 will use Google Drive-backed storage.

This table makes it easier to support other storage systems in the future.

---

## 12.2 Important Columns

| Column       | Type      | Purpose                                 |
| ------------ | --------- | --------------------------------------- |
| `id`         | uuid      | Unique provider ID                      |
| `name`       | text      | Provider name                           |
| `type`       | text      | google_drive, r2, gcs, supabase_storage |
| `is_active`  | boolean   | If provider is active                   |
| `created_at` | timestamp | When provider was added                 |

---

## 12.3 Provider Type Values

Possible values:

* `google_drive`
* `cloudflare_r2`
* `google_cloud_storage`
* `supabase_storage`

V1 will use:

* `google_drive`

---

# 13. Table: `storage_objects`

## 13.1 Purpose

This table stores references to actual files in the storage provider.

The database does not store the file itself.

It stores the location or ID of the file.

---

## 13.2 Important Columns

| Column               | Type      | Purpose                                     |
| -------------------- | --------- | ------------------------------------------- |
| `id`                 | uuid      | Unique storage object ID                    |
| `provider_id`        | uuid      | Storage provider ID                         |
| `provider_file_id`   | text      | File ID from Google Drive or other provider |
| `provider_folder_id` | text      | Folder ID if needed                         |
| `storage_path`       | text      | Logical file path                           |
| `file_size_bytes`    | bigint    | File size                                   |
| `mime_type`          | text      | MIME type                                   |
| `checksum`           | text      | Optional file checksum                      |
| `created_at`         | timestamp | When storage object was created             |
| `deleted_at`         | timestamp | When storage object was deleted             |
| `is_deleted`         | boolean   | If storage object is deleted                |

---

## 13.3 Storage Object Rules

* Every uploaded original file should have a storage object record.
* Every thumbnail may also have a storage object record.
* Storage object should not be publicly exposed.
* Download access should go through permission checks.
* Storage keys or secrets must never be stored in frontend code.

---

# 14. Table: `device_tokens`

## 14.1 Purpose

This table stores device tokens for push notifications.

A user can have multiple devices.

Example:

* iPhone
* iPad
* Android phone
* Web browser

---

## 14.2 Important Columns

| Column         | Type      | Purpose                 |
| -------------- | --------- | ----------------------- |
| `id`           | uuid      | Unique token ID         |
| `user_id`      | uuid      | Owner of device         |
| `device_token` | text      | Push notification token |
| `platform`     | text      | ios, android, web       |
| `device_name`  | text      | Optional device name    |
| `is_active`    | boolean   | If token is active      |
| `created_at`   | timestamp | Token creation          |
| `last_used_at` | timestamp | Last notification use   |
| `revoked_at`   | timestamp | When token was disabled |

---

## 14.3 Platform Values

Allowed values:

* `ios`
* `android`
* `web`

---

## 14.4 Device Token Rules

* A user can have many device tokens.
* Device tokens must belong to logged-in users.
* If user logs out, token should be disabled or removed.
* Removed album members should not receive album notifications.
* Notifications must not expose private details.

---

# 15. Table: `notifications`

## 15.1 Purpose

This table stores notification records.

It helps track what notification was created and sent.

---

## 15.2 Important Columns

| Column          | Type      | Purpose                |
| --------------- | --------- | ---------------------- |
| `id`            | uuid      | Unique notification ID |
| `user_id`       | uuid      | Receiver user          |
| `album_id`      | uuid      | Related album if any   |
| `media_file_id` | uuid      | Related file if any    |
| `type`          | text      | Notification type      |
| `title`         | text      | Notification title     |
| `body`          | text      | Notification body      |
| `is_read`       | boolean   | If user opened/read it |
| `created_at`    | timestamp | Notification creation  |
| `sent_at`       | timestamp | When push was sent     |
| `read_at`       | timestamp | When user read it      |

---

## 15.3 Notification Type Values

Possible values:

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

## 15.4 Notification Rules

* Notifications should only be created for users who should receive them.
* Notifications must not reveal private filenames.
* Notifications must not reveal sensitive album details.
* If user is removed from album, they should stop receiving notifications.
* User can mark notifications as read.

Good notification:

“New photos were added to your album.”

Bad notification:

“private_photo_001.jpg was uploaded by your girlfriend.”

---

# 16. Table: `activity_logs`

## 16.1 Purpose

This table stores important actions for audit and debugging.

This helps track what happened in the app.

---

## 16.2 Important Columns

| Column          | Type      | Purpose                 |
| --------------- | --------- | ----------------------- |
| `id`            | uuid      | Unique log ID           |
| `actor_id`      | uuid      | User who did the action |
| `album_id`      | uuid      | Related album           |
| `media_file_id` | uuid      | Related file            |
| `action`        | text      | Action type             |
| `metadata`      | jsonb     | Extra info              |
| `created_at`    | timestamp | When action happened    |

---

## 16.3 Activity Examples

Possible actions:

* `album_created`
* `album_renamed`
* `album_deleted`
* `member_invited`
* `member_joined`
* `member_removed`
* `role_changed`
* `file_uploaded`
* `file_deleted`
* `file_restored`
* `file_downloaded`

---

## 16.4 Activity Log Rules

* Logs are useful for debugging.
* Logs should not expose private file contents.
* Normal users do not need to see all logs in V1.
* Logs may be used later for account security or business features.

---

# 17. Future Table: `plans`

## 17.1 Purpose

This table is for future monetization.

It is not required for V1.

---

## 17.2 Possible Columns

| Column                | Type      | Purpose                   |
| --------------------- | --------- | ------------------------- |
| `id`                  | uuid      | Unique plan ID            |
| `name`                | text      | Plan name                 |
| `price`               | numeric   | Plan price                |
| `billing_cycle`       | text      | monthly, yearly, lifetime |
| `album_limit`         | integer   | Max albums                |
| `member_limit`        | integer   | Max members               |
| `storage_limit_bytes` | bigint    | Storage limit             |
| `is_active`           | boolean   | If plan is active         |
| `created_at`          | timestamp | Plan creation             |

---

## 17.3 Plan Examples

Possible future plans:

* Free
* Plus
* Family
* Couple
* Photographer
* Business
* Lifetime

Not for V1 implementation.

---

# 18. Future Table: `subscriptions`

## 18.1 Purpose

This table stores future user subscription records.

It is not required for V1.

---

## 18.2 Possible Columns

| Column       | Type      | Purpose                    |
| ------------ | --------- | -------------------------- |
| `id`         | uuid      | Unique subscription ID     |
| `user_id`    | uuid      | Subscribed user            |
| `plan_id`    | uuid      | Selected plan              |
| `status`     | text      | active, cancelled, expired |
| `started_at` | timestamp | Start date                 |
| `ends_at`    | timestamp | End date                   |
| `renewed_at` | timestamp | Last renewal               |
| `created_at` | timestamp | Record creation            |

---

## 18.3 Rules

* Not active in V1.
* Only prepared for future.
* Should not block V1 users.
* No payment system in V1.

---

# 19. Future Table: `billing_history`

## 19.1 Purpose

This table stores future payment records.

It is not part of V1.

---

## 19.2 Possible Columns

| Column             | Type      | Purpose                |
| ------------------ | --------- | ---------------------- |
| `id`               | uuid      | Unique billing ID      |
| `user_id`          | uuid      | Paying user            |
| `subscription_id`  | uuid      | Related subscription   |
| `amount`           | numeric   | Payment amount         |
| `currency`         | text      | Payment currency       |
| `status`           | text      | paid, failed, refunded |
| `payment_provider` | text      | Payment provider       |
| `created_at`       | timestamp | Payment record date    |

---

# 20. Future Table: `storage_usage`

## 20.1 Purpose

This table stores future storage usage tracking.

Even in V1, storage usage tracking is useful.

---

## 20.2 Possible Columns

| Column       | Type      | Purpose          |
| ------------ | --------- | ---------------- |
| `id`         | uuid      | Unique record ID |
| `user_id`    | uuid      | Related user     |
| `album_id`   | uuid      | Related album    |
| `used_bytes` | bigint    | Storage used     |
| `file_count` | integer   | Number of files  |
| `updated_at` | timestamp | Last calculation |

---

## 20.3 Storage Usage Rules

* Useful for future premium plans.
* Useful for detecting storage problems.
* Useful for admin monitoring.
* Can be implemented later or partially in V1.

---

# 21. Core Permission Rules

## 21.1 Album View Permission

A user can view an album only if:

* User is logged in.
* User is an active member of the album.
* Album is not deleted.

---

## 21.2 File View Permission

A user can view media files only if:

* User is logged in.
* User is an active member of the album.
* File is not deleted.
* Album is not deleted.

---

## 21.3 File Download Permission

A user can download files only if:

* User is logged in.
* User is an active member of the album.
* File is not deleted.
* Album is not deleted.
* User role is Admin, Contributor, or Viewer.

---

## 21.4 File Upload Permission

A user can upload files only if:

* User is logged in.
* User is an active member of the album.
* Album is not deleted.
* User role is Admin or Contributor.

Viewer cannot upload.

---

## 21.5 Invite Permission

A user can invite others only if:

* User is logged in.
* User is an active member of the album.
* User role is Admin.
* Album is not deleted.

---

## 21.6 Role Change Permission

A user can change roles only if:

* User is logged in.
* User role is Admin.
* Target user is a member of the same album.
* Album is not deleted.

Important rule:

An album should always keep at least one Admin.

---

## 21.7 File Delete Permission

A user can delete a file only if:

* User is logged in.
* User is the original uploader.
* File is not already deleted.
* Album is not deleted.

Admin cannot delete another user’s file in V1.

---

## 21.8 File Restore Permission

A user can restore a file only if:

* User is logged in.
* User is the original uploader.
* File is soft deleted.
* File is not permanently deleted.
* Restore is within 30 days.

Admin cannot restore another user’s file.

---

# 22. Row Level Security Rules

Supabase RLS must be enabled on important tables.

RLS should be used on:

* `user_profiles`
* `albums`
* `album_members`
* `album_invites`
* `media_files`
* `media_thumbnails`
* `device_tokens`
* `notifications`
* `activity_logs`

---

## 22.1 RLS Rule for Albums

Users can read albums only if they are active members.

Simple rule:

```text
Allow read album if user exists in album_members for that album.
```

Users can create albums for themselves.

Simple rule:

```text
Allow create album if owner_id equals logged-in user ID.
```

Only Admin can update album.

Simple rule:

```text
Allow update album if logged-in user is Admin in that album.
```

---

## 22.2 RLS Rule for Album Members

Users can read album members only for albums they belong to.

Only Admin can add, remove, or update members.

Simple rule:

```text
Allow member management only if logged-in user is Admin in the album.
```

---

## 22.3 RLS Rule for Invites

Only Admin can create invites.

Invited user can read invite only if invite email matches their email.

Simple rule:

```text
Allow invited user to read invite if auth email equals invite email.
```

---

## 22.4 RLS Rule for Media Files

Album members can read active files.

Simple rule:

```text
Allow read file if logged-in user is active member of file album.
```

Admin and Contributor can create upload records.

Simple rule:

```text
Allow insert file if user is Admin or Contributor in the album.
```

Only uploader can update delete or restore status.

Simple rule:

```text
Allow delete or restore action if uploader_id equals logged-in user ID.
```

---

## 22.5 RLS Rule for Device Tokens

Users can manage only their own device tokens.

Simple rule:

```text
Allow read, insert, update, delete only if user_id equals logged-in user ID.
```

---

## 22.6 RLS Rule for Notifications

Users can read only their own notifications.

Simple rule:

```text
Allow read notification if user_id equals logged-in user ID.
```

---

# 23. Important Database Functions

The database or Edge Functions may need helper functions.

Possible functions:

## 23.1 Check Album Role

Purpose:

Check if a user is Admin, Contributor, or Viewer in an album.

Used for:

* Upload
* Download
* Invite
* Role change
* Delete album

---

## 23.2 Check Album Membership

Purpose:

Check if user is active member of album.

Used for:

* Album view
* File view
* File download

---

## 23.3 Check File Uploader

Purpose:

Check if logged-in user is the original uploader.

Used for:

* Delete file
* Restore file

---

## 23.4 Create Album With Admin

Purpose:

When user creates album, automatically add user as Admin.

---

## 23.5 Accept Invite

Purpose:

When user accepts invite:

* Check email match.
* Check invite status.
* Create album member.
* Mark invite accepted.

---

## 23.6 Soft Delete Expired Files

Purpose:

Find files where:

* `is_deleted = true`
* `delete_expires_at` is in the past
* `permanently_deleted_at` is null

Then permanently delete or prepare deletion.

---

# 24. Index Recommendations

Indexes help make queries faster.

Recommended indexes:

## 24.1 `album_members`

* `album_id`
* `user_id`
* `album_id + user_id`
* `album_id + role`

Reason:

Used often for permission checks.

---

## 24.2 `media_files`

* `album_id`
* `uploader_id`
* `album_id + is_deleted`
* `delete_expires_at`

Reason:

Used for album gallery, uploader trash, and cleanup.

---

## 24.3 `album_invites`

* `email`
* `album_id`
* `status`
* `expires_at`

Reason:

Used for invite lookup and expiration.

---

## 24.4 `notifications`

* `user_id`
* `user_id + is_read`
* `created_at`

Reason:

Used for notification list.

---

## 24.5 `device_tokens`

* `user_id`
* `device_token`

Reason:

Used for push notification delivery.

---

# 25. Data Validation Rules

The database should validate important data.

## 25.1 Required Fields

Required fields:

* Album name
* Album owner
* Album member role
* Media file album ID
* Media file uploader ID
* Media file storage object
* File type
* MIME type
* File size

---

## 25.2 Role Validation

Role must be one of:

* `admin`
* `contributor`
* `viewer`

---

## 25.3 File Type Validation

File type must be one of:

* `photo`
* `video`

---

## 25.4 Invite Status Validation

Invite status must be one of:

* `pending`
* `accepted`
* `expired`
* `cancelled`

---

## 25.5 Upload Status Validation

Upload status must be one of:

* `pending`
* `uploading`
* `completed`
* `failed`

---

# 26. Important Queries Needed by the App

## 26.1 Get My Albums

Purpose:

Show all albums where the user is an active member.

Needs:

* Album data
* User role in album
* Cover photo
* Last updated time
* Member count
* File count

---

## 26.2 Get Album Details

Purpose:

Show album page.

Needs:

* Album info
* User role
* Members
* Active media files
* Upload permission
* Download permission

---

## 26.3 Get Album Files

Purpose:

Show album gallery.

Needs:

* Active media files only
* Thumbnail if available
* File type
* Upload date
* Uploader info

---

## 26.4 Get My Trash

Purpose:

Show deleted files that the user can restore.

Needs:

* Files where uploader is logged-in user
* `is_deleted = true`
* `delete_expires_at` not expired

---

## 26.5 Get Pending Invites

Purpose:

Show invites waiting for the user.

Needs:

* Invites where email matches user email
* Status is pending
* Not expired

---

## 26.6 Get Notifications

Purpose:

Show user notifications.

Needs:

* Notifications where user is receiver
* Newest first
* Read/unread status

---

# 27. Data Privacy Rules

The database must protect private album data.

Rules:

1. Users cannot see albums where they are not members.
2. Users cannot see files from albums where they are not members.
3. Users cannot see invites for other email addresses.
4. Users cannot access device tokens of other users.
5. Users cannot read notifications of other users.
6. Users cannot update roles unless they are Admin.
7. Users cannot delete files uploaded by other users in V1.
8. Users cannot restore files uploaded by other users.
9. Users cannot access deleted files unless they are the uploader.
10. Frontend hiding is not enough. Backend and RLS must enforce rules.

---

# 28. Data Retention Rules

## 28.1 Active Files

Active files stay available unless:

* Uploader deletes them.
* Album is deleted.
* Storage is removed.
* Account rules change in future.

---

## 28.2 Deleted Files

Deleted files stay recoverable for 30 days.

After 30 days, they may be permanently deleted.

---

## 28.3 Activity Logs

Activity logs may be kept longer for debugging and security.

Logs should not include private media contents.

---

## 28.4 Notifications

Old notifications may be deleted or archived later.

V1 can keep them simple.

---

# 29. Storage Mapping

The database must map every media file to storage.

Example:

`media_files.storage_object_id`
points to:
`storage_objects.id`

`storage_objects.provider_file_id`
points to:
Google Drive file ID

This makes it possible to change storage provider in the future.

Example:

Today:

* Google Drive file ID

Future:

* Cloudflare R2 object key
* Google Cloud Storage object path
* Supabase Storage path

The app should not depend on Google Drive IDs directly in the frontend.

---

# 30. Suggested Database Build Order

## Step 1: User and Album Core

Create:

* `user_profiles`
* `albums`
* `album_members`

This allows:

* Login
* Create album
* Join album
* View my albums

---

## Step 2: Invite System

Create:

* `album_invites`

This allows:

* Invite by email
* Accept invite
* Add member

---

## Step 3: Storage and Files

Create:

* `storage_providers`
* `storage_objects`
* `media_files`
* `media_thumbnails`

This allows:

* Upload file metadata
* Show album gallery
* Download original file

---

## Step 4: Delete and Restore

Add or finalize:

* Delete fields in `media_files`
* Trash queries
* Restore rules
* Cleanup logic

---

## Step 5: Notifications

Create:

* `device_tokens`
* `notifications`

This allows:

* Push notification support
* Notification center

---

## Step 6: Logs and Future Tables

Create:

* `activity_logs`
* future monetization tables only if needed

---

# 31. V1 Database Decision Summary

Confirmed V1 database decisions:

* Use Supabase Postgres.
* Use Supabase Auth with Google Login.
* Use `user_profiles` for app user data.
* Use `albums` for private album containers.
* Use `album_members` for roles and access.
* Use roles: Admin, Contributor, Viewer.
* Use `album_invites` for email invites.
* Use `media_files` for original media metadata.
* Use `media_thumbnails` for preview files.
* Use `storage_objects` for file storage references.
* Use Google Drive-backed storage for V1.
* Use soft delete for files.
* Deleted files stay recoverable for 30 days.
* Only original uploader can delete their own file.
* Only original uploader can restore their own file.
* Admin cannot restore another user’s deleted file.
* Users can create their own albums.
* Albums are private by default.
* No social media tables for likes, comments, followers, or public feeds.
* Future monetization tables can be planned but not implemented yet.

---

# 32. Main Database Rule

The most important database rule is:

**Album access controls everything.**

If a user is not an active member of an album, they must not be able to see, upload, download, delete, restore, or manage anything inside that album.

---

# 33. Next Recommended Document

The next recommended document is:

**Potoos UI/UX Flow Document v1.0**

This document should define:

* App screens
* User flows
* Button behavior
* Upload flow
* Download flow
* Save All flow
* Invite flow
* Trash flow
* Mobile and PC experience
* Error messages
* Permission messages
