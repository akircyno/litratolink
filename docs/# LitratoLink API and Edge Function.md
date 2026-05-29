# LitratoLink API and Edge Functions Specification v1.0

## 1. Document Purpose

This document explains the backend API and Edge Functions needed for LitratoLink.

This document is based on:

* LitratoLink Master Product Plan v1.0
* LitratoLink System Architecture Document v1.0
* LitratoLink Database Design Document v1.0
* LitratoLink UI/UX Flow Document v1.0
* LitratoLink Development Roadmap v1.0
* LitratoLink Codex Development Instructions v1.0

The goal of this document is to define:

* Edge Function names
* What each function does
* Request body
* Response body
* Permission checks
* Error messages
* Upload flow
* Download flow
* Invite flow
* Notification flow
* Delete and restore flow

This document is not final code. It is the guide for backend implementation.

---

## 2. Backend Style

LitratoLink will use:

* Supabase Auth
* Supabase Postgres
* Supabase Row Level Security
* Supabase Edge Functions
* Google Drive / Google One-backed storage for V1

The Flutter app will call Supabase and Edge Functions.

Sensitive actions should be handled by Edge Functions.

Examples:

* Creating upload sessions
* Completing uploads
* Generating download access
* Sending notifications
* Accepting invites
* Soft deleting files
* Restoring files

---

## 3. Main API Rule

Every protected request must include the logged-in user.

The backend must always check:

1. Is the user logged in?
2. Is the user active?
3. Is the album active?
4. Is the user a member of the album?
5. What is the user role?
6. Is the file active?
7. Is the user allowed to perform this action?

The frontend UI is not enough for security.

The backend must block unauthorized actions.

---

## 4. Authentication Rule

Most Edge Functions require a Supabase Auth token.

The Flutter app should send the user session token when calling Edge Functions.

Backend must get the current user from the token.

If there is no valid user:

Return:

```json
{
  "success": false,
  "error_code": "UNAUTHENTICATED",
  "message": "Please log in to continue."
}
```

---

## 5. Standard Response Format

All Edge Functions should use a consistent response format.

### 5.1 Success Response

```json
{
  "success": true,
  "data": {}
}
```

### 5.2 Error Response

```json
{
  "success": false,
  "error_code": "ERROR_CODE",
  "message": "User-friendly error message."
}
```

---

## 6. Standard Error Codes

Use simple and consistent error codes.

| Error Code         | Meaning                            |
| ------------------ | ---------------------------------- |
| `UNAUTHENTICATED`  | User is not logged in              |
| `FORBIDDEN`        | User does not have permission      |
| `NOT_FOUND`        | Record or file was not found       |
| `ALBUM_NOT_FOUND`  | Album was not found                |
| `FILE_NOT_FOUND`   | File was not found                 |
| `INVITE_NOT_FOUND` | Invite was not found               |
| `INVALID_REQUEST`  | Request body is missing or invalid |
| `INVALID_ROLE`     | Role value is invalid              |
| `ALREADY_MEMBER`   | User is already an album member    |
| `INVITE_EXPIRED`   | Invite is expired                  |
| `INVITE_CANCELLED` | Invite was cancelled               |
| `STORAGE_ERROR`    | Storage provider failed            |
| `UPLOAD_FAILED`    | Upload failed                      |
| `DOWNLOAD_FAILED`  | Download failed                    |
| `STORAGE_FULL`     | Storage is full                    |
| `SERVER_ERROR`     | Unexpected server error            |

---

## 7. User-Friendly Error Messages

Do not expose raw backend errors to users.

Examples:

Bad:

```text
Postgres error 23503 foreign key violation
```

Good:

```text
This action could not be completed. Please try again.
```

Common messages:

* Please log in to continue.
* You do not have permission to do this.
* This album is no longer available.
* This file is no longer available.
* This invite has expired. Please ask for a new invite.
* Upload failed. Please try again.
* Download failed. Please try again.
* Upload failed because storage is currently full. Please try again later.

---

# 8. Edge Function List

V1 Edge Functions:

1. `create-user-profile`
2. `create-album`
3. `update-album`
4. `delete-album`
5. `invite-member`
6. `accept-invite`
7. `decline-invite`
8. `change-member-role`
9. `remove-member`
10. `create-upload-session`
11. `complete-upload`
12. `get-download-access`
13. `soft-delete-file`
14. `restore-file`
15. `cleanup-expired-files`
16. `register-device-token`
17. `remove-device-token`
18. `send-notification`
19. `mark-notification-read`

Some of these can be built later depending on development phase.

---

# 9. Function: `create-user-profile`

## 9.1 Purpose

Creates a user profile after first Google login.

## 9.2 When Used

Used after the user logs in for the first time.

## 9.3 Request Body

```json
{
  "display_name": "User Name",
  "avatar_url": "https://example.com/avatar.jpg"
}
```

## 9.4 Permission Check

User must be logged in.

## 9.5 Backend Actions

1. Get logged-in user ID.
2. Get user email from Supabase Auth.
3. Check if profile already exists.
4. If no profile exists, create profile.
5. Return profile.

## 9.6 Success Response

```json
{
  "success": true,
  "data": {
    "user_id": "uuid",
    "email": "user@example.com",
    "display_name": "User Name"
  }
}
```

## 9.7 Error Cases

* User not logged in
* Profile creation failed

---

# 10. Function: `create-album`

## 10.1 Purpose

Creates a new private album.

## 10.2 Request Body

```json
{
  "name": "Me and GF",
  "description": "Private memories"
}
```

## 10.3 Permission Check

User must be logged in.

## 10.4 Backend Actions

1. Validate album name.
2. Create album record.
3. Set `owner_id` to logged-in user.
4. Add creator to `album_members` as `admin`.
5. Return album data.

## 10.5 Success Response

```json
{
  "success": true,
  "data": {
    "album_id": "uuid",
    "name": "Me and GF",
    "role": "admin"
  }
}
```

## 10.6 Error Cases

* Missing album name
* User not logged in
* Database error

---

# 11. Function: `update-album`

## 11.1 Purpose

Updates album information.

Examples:

* Rename album
* Update description
* Change cover

## 11.2 Request Body

```json
{
  "album_id": "uuid",
  "name": "New Album Name",
  "description": "New description",
  "cover_file_id": "uuid"
}
```

## 11.3 Permission Check

User must be Admin of the album.

## 11.4 Backend Actions

1. Check if user is logged in.
2. Check if album exists.
3. Check if user is active Admin.
4. Update allowed fields.
5. Return updated album.

## 11.5 Success Response

```json
{
  "success": true,
  "data": {
    "album_id": "uuid",
    "name": "New Album Name"
  }
}
```

## 11.6 Error Cases

* Album not found
* User is not Admin
* Invalid request

---

# 12. Function: `delete-album`

## 12.1 Purpose

Soft deletes an album.

## 12.2 Request Body

```json
{
  "album_id": "uuid"
}
```

## 12.3 Permission Check

User must be Admin of the album.

## 12.4 Backend Actions

1. Check user is logged in.
2. Check album exists.
3. Check user is Admin.
4. Mark album as deleted.
5. Set `deleted_at`.
6. Set `delete_expires_at`.
7. Hide album from members.
8. Create activity log.

## 12.5 Success Response

```json
{
  "success": true,
  "data": {
    "album_id": "uuid",
    "is_deleted": true
  }
}
```

## 12.6 Error Cases

* Album not found
* User is not Admin
* Album already deleted

---

# 13. Function: `invite-member`

## 13.1 Purpose

Allows an Album Admin to invite another user by email.

## 13.2 Request Body

```json
{
  "album_id": "uuid",
  "email": "friend@example.com",
  "role": "viewer"
}
```

## 13.3 Permission Check

User must be Admin of the album.

## 13.4 Valid Roles

Allowed invite roles:

* `admin`
* `contributor`
* `viewer`

Recommended default:

* `viewer`

## 13.5 Backend Actions

1. Check user is logged in.
2. Check album exists.
3. Check user is Admin.
4. Validate email.
5. Validate role.
6. Check if email is already a member.
7. Create invite record.
8. Send notification or email if available.
9. Return invite data.

## 13.6 Success Response

```json
{
  "success": true,
  "data": {
    "invite_id": "uuid",
    "album_id": "uuid",
    "email": "friend@example.com",
    "role": "viewer",
    "status": "pending"
  }
}
```

## 13.7 Error Cases

* User is not Admin
* Invalid email
* Invalid role
* User is already a member
* Invite already pending

---

# 14. Function: `accept-invite`

## 14.1 Purpose

Allows an invited user to accept an album invite.

## 14.2 Request Body

```json
{
  "invite_id": "uuid"
}
```

## 14.3 Permission Check

User must be logged in.

The logged-in user email must match the invite email.

## 14.4 Backend Actions

1. Check user is logged in.
2. Get invite.
3. Check invite exists.
4. Check invite status is `pending`.
5. Check invite is not expired.
6. Check logged-in user email matches invite email.
7. Add user to `album_members`.
8. Mark invite as `accepted`.
9. Set `accepted_at`.
10. Notify Album Admin if needed.
11. Return album membership.

## 14.5 Success Response

```json
{
  "success": true,
  "data": {
    "album_id": "uuid",
    "role": "viewer",
    "joined": true
  }
}
```

## 14.6 Error Cases

* Invite not found
* Invite expired
* Invite cancelled
* Email does not match invite
* User already member

---

# 15. Function: `decline-invite`

## 15.1 Purpose

Allows invited user to decline an invite.

## 15.2 Request Body

```json
{
  "invite_id": "uuid"
}
```

## 15.3 Permission Check

User must be logged in.

Logged-in user email must match invite email.

## 15.4 Backend Actions

1. Check user.
2. Check invite.
3. Check email match.
4. Mark invite as declined or cancelled.
5. Return result.

## 15.5 Success Response

```json
{
  "success": true,
  "data": {
    "invite_id": "uuid",
    "status": "declined"
  }
}
```

## 15.6 Error Cases

* Invite not found
* Email does not match
* Invite already accepted
* Invite expired

---

# 16. Function: `change-member-role`

## 16.1 Purpose

Allows Album Admin to change a member’s role.

## 16.2 Request Body

```json
{
  "album_id": "uuid",
  "member_user_id": "uuid",
  "new_role": "contributor"
}
```

## 16.3 Permission Check

User must be Admin of the album.

## 16.4 Backend Actions

1. Check user is logged in.
2. Check user is Admin.
3. Validate new role.
4. Check target member exists.
5. Check album will still have at least one Admin.
6. Update member role.
7. Create activity log.
8. Return updated member.

## 16.5 Success Response

```json
{
  "success": true,
  "data": {
    "album_id": "uuid",
    "member_user_id": "uuid",
    "role": "contributor"
  }
}
```

## 16.6 Error Cases

* User is not Admin
* Invalid role
* Target member not found
* Cannot remove last Admin

---

# 17. Function: `remove-member`

## 17.1 Purpose

Allows Album Admin to remove a member from an album.

## 17.2 Request Body

```json
{
  "album_id": "uuid",
  "member_user_id": "uuid"
}
```

## 17.3 Permission Check

User must be Admin of the album.

## 17.4 Backend Actions

1. Check user is logged in.
2. Check user is Admin.
3. Check target member exists.
4. Check removing target will not remove last Admin.
5. Mark member as inactive.
6. Set `removed_at`.
7. Stop future album notifications for removed user.
8. Create activity log.

## 17.5 Success Response

```json
{
  "success": true,
  "data": {
    "album_id": "uuid",
    "member_user_id": "uuid",
    "removed": true
  }
}
```

## 17.6 Error Cases

* User is not Admin
* Target member not found
* Cannot remove last Admin

---

# 18. Function: `create-upload-session`

## 18.1 Purpose

Creates permission and storage preparation for uploading a file.

This is used before the Flutter app uploads the original file.

## 18.2 Request Body

```json
{
  "album_id": "uuid",
  "original_filename": "IMG_1234.JPG",
  "mime_type": "image/jpeg",
  "file_size_bytes": 5234567,
  "file_type": "photo"
}
```

## 18.3 Permission Check

User must be:

* Logged in
* Active member of the album
* Role must be `admin` or `contributor`

## 18.4 Backend Actions

1. Check user is logged in.
2. Check album exists.
3. Check album is not deleted.
4. Check user is active member.
5. Check role is Admin or Contributor.
6. Validate file type.
7. Validate MIME type.
8. Create `storage_object` record with pending status if needed.
9. Create `media_files` record with `upload_status = pending`.
10. Create Google Drive upload session or storage upload instruction.
11. Return upload session data.

## 18.5 Success Response

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "storage_object_id": "uuid",
    "upload_url": "temporary-upload-url",
    "upload_method": "PUT",
    "required_headers": {
      "Content-Type": "image/jpeg"
    }
  }
}
```

## 18.6 Important Rules

* Upload URL must be temporary if possible.
* Upload URL must not expose permanent storage access.
* Backend must not trust file metadata blindly.
* Final file info should be confirmed after upload.
* No compression must happen in this flow.

## 18.7 Error Cases

* User is Viewer
* User is not album member
* Album not found
* Invalid file type
* Storage provider failed
* Storage full

---

# 19. Function: `complete-upload`

## 19.1 Purpose

Marks an upload as complete after the file is successfully uploaded to storage.

## 19.2 Request Body

```json
{
  "media_file_id": "uuid",
  "storage_object_id": "uuid",
  "provider_file_id": "google-drive-file-id",
  "final_file_size_bytes": 5234567,
  "checksum": "optional-checksum"
}
```

## 19.3 Permission Check

User must be the original uploader of the media file.

## 19.4 Backend Actions

1. Check user is logged in.
2. Check media file exists.
3. Check user is uploader.
4. Confirm upload exists in storage if possible.
5. Update storage object record.
6. Update media file status to `completed`.
7. Set `uploaded_at`.
8. Create activity log.
9. Notify album members about new upload.
10. Return completed file data.

## 19.5 Success Response

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "upload_status": "completed",
    "uploaded_at": "timestamp"
  }
}
```

## 19.6 Error Cases

* Media file not found
* User is not uploader
* Storage confirmation failed
* Upload failed

---

# 20. Function: `get-download-access`

## 20.1 Purpose

Gives secure access to download the original file.

## 20.2 Request Body

```json
{
  "media_file_id": "uuid"
}
```

## 20.3 Permission Check

User must be:

* Logged in
* Active member of the file’s album
* Role can be Admin, Contributor, or Viewer

File must not be deleted.

Album must not be deleted.

## 20.4 Backend Actions

1. Check user is logged in.
2. Get media file.
3. Get album.
4. Check album is not deleted.
5. Check file is not deleted.
6. Check user is active album member.
7. Generate secure download access.
8. Return download data.

## 20.5 Success Response

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "download_url": "temporary-download-url",
    "original_filename": "IMG_1234.JPG",
    "mime_type": "image/jpeg",
    "file_size_bytes": 5234567
  }
}
```

## 20.6 Important Rules

* Download must use original file.
* Download must not use thumbnail.
* Download access should be temporary or controlled.
* Non-members must not receive download access.

## 20.7 Error Cases

* File not found
* File deleted
* Album deleted
* User not member
* Storage error

---

# 21. Save All Backend Flow

## 21.1 Purpose

Save All downloads many original files.

Save All may use `get-download-access` per file, or a batch version later.

## 21.2 Optional Future Function

Future function:

`get-batch-download-access`

## 21.3 Request Body

```json
{
  "album_id": "uuid",
  "media_file_ids": ["uuid-1", "uuid-2", "uuid-3"]
}
```

## 21.4 Permission Check

User must be an active member of the album.

## 21.5 Success Response

```json
{
  "success": true,
  "data": {
    "files": [
      {
        "media_file_id": "uuid-1",
        "download_url": "temporary-download-url",
        "original_filename": "IMG_1.JPG",
        "mime_type": "image/jpeg",
        "file_size_bytes": 1234567
      }
    ]
  }
}
```

## 21.6 V1 Recommendation

For V1, it is acceptable to call `get-download-access` one file at a time.

This is simpler and safer.

Later, batch download access can be added for better performance.

---

# 22. Function: `soft-delete-file`

## 22.1 Purpose

Soft deletes a file uploaded by the current user.

## 22.2 Request Body

```json
{
  "media_file_id": "uuid"
}
```

## 22.3 Permission Check

User must be the original uploader of the file.

## 22.4 Backend Actions

1. Check user is logged in.
2. Get media file.
3. Check user is uploader.
4. Check file is not already deleted.
5. Set `is_deleted = true`.
6. Set `deleted_at`.
7. Set `deleted_by`.
8. Set `delete_expires_at` to 30 days from deletion.
9. Create activity log.
10. Return result.

## 22.5 Success Response

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "is_deleted": true,
    "delete_expires_at": "timestamp"
  }
}
```

## 22.6 Important Rules

* File disappears from album for everyone.
* File appears only in uploader’s Trash.
* File is not permanently deleted immediately.
* Admin cannot delete another user’s file in V1.

## 22.7 Error Cases

* File not found
* User is not uploader
* File already deleted

---

# 23. Function: `restore-file`

## 23.1 Purpose

Restores a soft deleted file.

## 23.2 Request Body

```json
{
  "media_file_id": "uuid"
}
```

## 23.3 Permission Check

User must be the original uploader of the file.

File must still be within the 30-day restore period.

## 23.4 Backend Actions

1. Check user is logged in.
2. Get media file.
3. Check user is uploader.
4. Check file is soft deleted.
5. Check restore period has not expired.
6. Set `is_deleted = false`.
7. Clear `deleted_at`.
8. Clear `deleted_by`.
9. Clear `delete_expires_at`.
10. Set `restored_at`.
11. Create activity log.
12. Return result.

## 23.5 Success Response

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "is_deleted": false,
    "restored": true
  }
}
```

## 23.6 Important Rules

* Only original uploader can restore.
* Admin cannot restore another user’s file.
* Viewer cannot restore.
* Restored file returns to original album.

## 23.7 Error Cases

* File not found
* User is not uploader
* File is not deleted
* Restore period expired

---

# 24. Function: `cleanup-expired-files`

## 24.1 Purpose

Permanently deletes expired soft deleted files.

## 24.2 Trigger

This should be called by a scheduled job, not normal users.

Example:

* Once per day

## 24.3 Permission Check

This function should only be called by a backend service or scheduled job.

Normal users must not call this directly.

## 24.4 Backend Actions

1. Find files where `is_deleted = true`.
2. Check `delete_expires_at` is in the past.
3. Check `permanently_deleted_at` is null.
4. Delete file from storage.
5. Mark file as permanently deleted.
6. Create activity log.

## 24.5 Success Response

```json
{
  "success": true,
  "data": {
    "deleted_count": 12
  }
}
```

## 24.6 Error Cases

* Unauthorized scheduler
* Storage deletion failed
* Server error

---

# 25. Function: `register-device-token`

## 25.1 Purpose

Registers a user device for push notifications.

## 25.2 Request Body

```json
{
  "device_token": "push-token",
  "platform": "ios",
  "device_name": "Jerald's iPhone"
}
```

## 25.3 Permission Check

User must be logged in.

## 25.4 Backend Actions

1. Check user is logged in.
2. Validate platform.
3. Check if token already exists.
4. Insert or update device token.
5. Mark token as active.

## 25.5 Success Response

```json
{
  "success": true,
  "data": {
    "registered": true
  }
}
```

## 25.6 Platform Values

Allowed values:

* `ios`
* `android`
* `web`

---

# 26. Function: `remove-device-token`

## 26.1 Purpose

Removes or disables a device token.

Used when user logs out.

## 26.2 Request Body

```json
{
  "device_token": "push-token"
}
```

## 26.3 Permission Check

User must be logged in.

## 26.4 Backend Actions

1. Check user.
2. Find token for user.
3. Mark as inactive or delete.
4. Set `revoked_at`.

## 26.5 Success Response

```json
{
  "success": true,
  "data": {
    "removed": true
  }
}
```

---

# 27. Function: `send-notification`

## 27.1 Purpose

Sends push notifications to users.

This should mostly be called internally by backend actions.

## 27.2 Request Body

```json
{
  "user_ids": ["uuid-1", "uuid-2"],
  "type": "new_upload",
  "album_id": "uuid",
  "title": "New memories added",
  "body": "New photos were added to your album."
}
```

## 27.3 Permission Check

This should be backend-only or service-only.

Normal users should not freely call this function.

## 27.4 Backend Actions

1. Validate target users.
2. Create notification records.
3. Get active device tokens.
4. Send push notification.
5. Mark `sent_at`.

## 27.5 Success Response

```json
{
  "success": true,
  "data": {
    "sent_count": 2
  }
}
```

## 27.6 Privacy Rules

Do not send private filenames.

Do not send sensitive details.

Good:

```text
New photos were added to your album.
```

Bad:

```text
IMG_1234_private.jpg was uploaded.
```

---

# 28. Function: `mark-notification-read`

## 28.1 Purpose

Marks a notification as read.

## 28.2 Request Body

```json
{
  "notification_id": "uuid"
}
```

## 28.3 Permission Check

User must own the notification.

## 28.4 Backend Actions

1. Check user.
2. Check notification belongs to user.
3. Set `is_read = true`.
4. Set `read_at`.

## 28.5 Success Response

```json
{
  "success": true,
  "data": {
    "notification_id": "uuid",
    "is_read": true
  }
}
```

---

# 29. Album Query APIs

Some simple data can be fetched directly from Supabase using RLS.

These may not need Edge Functions.

## 29.1 Get My Albums

Purpose:

Show albums where user is an active member.

Data needed:

* Album ID
* Album name
* Cover
* User role
* File count
* Member count
* Last updated date

Permission:

* RLS should only return albums where user is active member.

---

## 29.2 Get Album Details

Purpose:

Show album page.

Data needed:

* Album info
* User role
* Members
* Files
* Upload permission
* Download permission

Permission:

* User must be active album member.

---

## 29.3 Get Album Files

Purpose:

Show album gallery.

Data needed:

* Active files only
* Thumbnail
* File type
* Upload date
* Uploader

Permission:

* User must be active album member.

---

## 29.4 Get My Trash

Purpose:

Show deleted files uploaded by current user.

Data needed:

* Deleted files where uploader is current user
* Album name
* Deleted date
* Restore deadline

Permission:

* User can only see their own deleted files.

---

## 29.5 Get Pending Invites

Purpose:

Show invites for logged-in user.

Data needed:

* Invites where email matches logged-in user email
* Status is pending
* Not expired

Permission:

* User can only see invites sent to their email.

---

## 29.6 Get Notifications

Purpose:

Show notifications for current user.

Permission:

* User can only see their own notifications.

---

# 30. Upload Flow Full Sequence

## 30.1 User Uploads One File

```text
User selects file
 ↓
Flutter reads file metadata
 ↓
Flutter calls create-upload-session
 ↓
Backend checks album role
 ↓
Backend creates pending records
 ↓
Backend returns upload URL/session
 ↓
Flutter uploads original file
 ↓
Flutter calls complete-upload
 ↓
Backend confirms file
 ↓
Backend marks upload completed
 ↓
Backend notifies album members
```

## 30.2 Important Upload Rule

The Flutter app must select the original file.

It must not select a compressed preview.

If using a photo picker, Codex must make sure the picker returns the original asset/file when possible.

---

# 31. Download Flow Full Sequence

## 31.1 User Downloads One File

```text
User taps Download Original
 ↓
Flutter calls get-download-access
 ↓
Backend checks album membership
 ↓
Backend checks file is active
 ↓
Backend returns secure download access
 ↓
Flutter downloads original file
 ↓
Flutter saves file to device
```

---

# 32. Save All Flow Full Sequence

```text
User taps Save All
 ↓
App shows confirmation
 ↓
User confirms
 ↓
App gets list of active files
 ↓
For each file:
   App calls get-download-access
   App downloads original file
   App saves file to device
   App updates progress
 ↓
If some fail:
   App shows Retry Failed
 ↓
If complete:
   App shows Save All complete
```

Important:

Save All should not request hundreds of download links at once if this creates errors.

It can download files one by one or in small batches.

---

# 33. Invite Flow Full Sequence

```text
Admin enters email
 ↓
Admin chooses role
 ↓
Flutter calls invite-member
 ↓
Backend checks Admin role
 ↓
Backend creates invite
 ↓
Invited user receives notification or sees invite after login
 ↓
Invited user accepts
 ↓
Flutter calls accept-invite
 ↓
Backend checks email match
 ↓
Backend creates album member
 ↓
Album appears in My Albums
```

---

# 34. Delete and Restore Flow Full Sequence

## 34.1 Delete

```text
Uploader taps Delete
 ↓
App shows confirmation
 ↓
Uploader confirms
 ↓
Flutter calls soft-delete-file
 ↓
Backend checks uploader ownership
 ↓
File is marked deleted
 ↓
File disappears from album for everyone
 ↓
File appears in uploader Trash
```

## 34.2 Restore

```text
Uploader opens Trash
 ↓
Uploader taps Restore
 ↓
Flutter calls restore-file
 ↓
Backend checks uploader ownership
 ↓
Backend checks 30-day restore period
 ↓
File is restored
 ↓
File appears again in original album
```

---

# 35. Permission Matrix

| Action                | Admin    | Contributor | Viewer |
| --------------------- | -------- | ----------- | ------ |
| View album            | Yes      | Yes         | Yes    |
| View files            | Yes      | Yes         | Yes    |
| Download files        | Yes      | Yes         | Yes    |
| Save All              | Yes      | Yes         | Yes    |
| Upload files          | Yes      | Yes         | No     |
| Invite members        | Yes      | No          | No     |
| Remove members        | Yes      | No          | No     |
| Change roles          | Yes      | No          | No     |
| Rename album          | Yes      | No          | No     |
| Delete album          | Yes      | No          | No     |
| Delete own file       | Yes      | Yes         | No     |
| Restore own file      | Yes      | Yes         | No     |
| Delete others’ files  | No in V1 | No          | No     |
| Restore others’ files | No       | No          | No     |

---

# 36. Storage Access Rules

## 36.1 Original File

Original file must be stored and downloaded unchanged.

## 36.2 Thumbnail

Thumbnail is only for preview.

## 36.3 Public Links

Do not use permanent public file links.

## 36.4 Temporary Access

Download access should be temporary or controlled by backend.

## 36.5 Storage Credentials

Google API or storage credentials must stay in backend environment variables.

Never store them in the Flutter app.

---

# 37. Important Technical Note About Google Drive Storage

V1 plans to use LitratoLink-managed Google Drive / Google One-backed storage.

This must be tested early in a proof of concept.

Reason:

Google Drive storage setup depends on the correct Google API and OAuth configuration.

The app should not expose the storage owner’s credentials.

The backend should manage storage access.

If Google Drive API becomes limiting later, the app should be ready to move to another storage provider through a storage adapter.

Future storage options:

* Google Cloud Storage
* Cloudflare R2
* Supabase Storage
* Other S3-compatible storage

---

# 38. Backend Security Rules

Every Edge Function must:

1. Validate user session.
2. Validate request body.
3. Check album membership if album-related.
4. Check role if role-related.
5. Check uploader ownership if delete or restore.
6. Never expose service keys.
7. Return user-friendly errors.
8. Log important activity safely.

---

# 39. Activity Log Events

Create activity logs for important actions.

Possible events:

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

Do not log private file contents.

---

# 40. API Build Priority

Build Edge Functions in this order:

## Priority 1: Core Proof

1. `create-user-profile`
2. `create-album`
3. `create-upload-session`
4. `complete-upload`
5. `get-download-access`

## Priority 2: Sharing

6. `invite-member`
7. `accept-invite`
8. `decline-invite`
9. `change-member-role`
10. `remove-member`

## Priority 3: Save and Restore

11. `soft-delete-file`
12. `restore-file`
13. `cleanup-expired-files`

## Priority 4: Notifications

14. `register-device-token`
15. `remove-device-token`
16. `send-notification`
17. `mark-notification-read`

## Priority 5: Album Management

18. `update-album`
19. `delete-album`

---

# 41. Final API Decision Summary

Confirmed backend decisions:

* Use Supabase Edge Functions for sensitive actions.
* Use Supabase RLS for database protection.
* Use Google Login for V1 authentication.
* Use album membership for access control.
* Use roles: Admin, Contributor, Viewer.
* Use LitratoLink-managed Google Drive storage for V1.
* Upload must preserve original quality.
* Download must use original files.
* Save All must use original files.
* Only uploader can delete their own files.
* Only uploader can restore their own deleted files.
* Deleted files are restorable for 30 days.
* Admin cannot restore another user’s file.
* Notifications must not expose private file names.
* Storage logic must be future-ready.

---

# 42. Next Recommended Document

The next recommended document is:

**LitratoLink Supabase SQL and RLS Planning Document v1.0**

This document should define:

* Table creation plan
* Column details
* Enum values
* RLS policy plan
* Helper functions
* Indexes
* Database triggers
* Storage cleanup jobs
* Seed data
