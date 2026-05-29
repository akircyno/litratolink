# LitratoLink Google Drive API Proof Plan v1.0

## 1. Document Purpose

This document explains how to test the Google Drive API storage plan for LitratoLink.

This document is based on all previous LitratoLink planning documents.

The goal of this document is to test the most important technical risk early:

**Can LitratoLink upload and download original-quality photos and videos using Google Drive-backed storage?**

This document is not the full app plan.

This is only the proof plan for Google Drive storage.

---

## 2. Why This Proof Is Important

LitratoLink depends on original-quality file sharing.

The app is only useful if it can:

1. Upload the original file.
2. Store the original file safely.
3. Save file metadata.
4. Download the same original file.
5. Keep file quality unchanged.

If Google Drive API storage does not work well, we must know early before building the full app.

---

## 3. Main Proof Goal

The main proof goal is:

**Upload one original photo to Google Drive storage, save metadata in Supabase, then download the same original photo without quality loss.**

After photo proof works, test:

* One video
* Multiple photos
* Large file
* Interrupted upload
* Download retry

---

## 4. Confirmed V1 Storage Direction

V1 storage direction:

**LitratoLink-managed Google Drive / Google One-backed storage**

This means:

* Users do not need their own Google Drive.
* Users do not need their own Google One subscription.
* Users do not manage Drive folders.
* LitratoLink handles storage behind the scenes.
* Users only use the app.

Important:

This is for V1 and small personal or early user testing.

If the app grows, storage can be migrated later using the storage adapter idea.

---

## 5. Main Technical Question

The main technical question is:

**Can the backend upload and download original files from a managed Google Drive storage account without exposing private credentials to the Flutter app?**

The answer must be tested before building full MVP features.

---

# PART A: GOOGLE DRIVE API SETUP

---

## 6. Required Google Setup

Create or prepare:

1. Google Cloud project
2. Google Drive API enabled
3. OAuth consent screen
4. OAuth client credentials
5. Managed Google Drive storage account
6. Root storage folder
7. Backend environment variables
8. Supabase Edge Function test

---

## 7. Google Cloud Project

Recommended project name:

**LitratoLink**

Purpose:

* Google Login
* Google Drive API
* OAuth credentials
* API quota monitoring

---

## 8. Enable Google Drive API

Inside Google Cloud Console:

1. Open project.
2. Go to APIs and Services.
3. Enable Google Drive API.
4. Confirm API is active.

Purpose:

The backend needs Google Drive API to upload and download files.

---

## 9. OAuth Consent Screen

Prepare OAuth consent screen.

Needed information:

* App name: LitratoLink
* User support email
* Developer contact email
* App logo later
* Privacy Policy URL later
* Terms of Use URL later

For early development, the app can start in testing mode if needed.

Before public release, OAuth setup may need more complete information.

---

## 10. OAuth Scopes

Use the smallest scope possible.

Preferred direction:

Use limited Drive access if possible.

Possible scope:

`drive.file`

Reason:

It gives more limited file access than full Drive access.

However, because V1 uses LitratoLink-managed storage, we must test if `drive.file` works well for the planned backend storage flow.

If it does not fit the managed storage approach, review the required scope carefully.

Important rule:

Do not request broad Google Drive permissions unless they are truly needed.

---

## 11. Managed Storage Account

V1 uses one managed storage account.

This account owns the Drive storage used by LitratoLink.

Purpose:

* Store original files
* Store thumbnails if needed
* Keep storage centralized
* Avoid requiring users to connect their own Drive

Important privacy note:

Because files are stored in managed storage, LitratoLink controls the storage location.

For V1 testing, this is acceptable.

If the app becomes public, privacy policy and storage design should be reviewed again.

---

## 12. Root Folder Setup

Create root folder in the managed Google Drive account.

Recommended folder name:

**LitratoLink Storage**

Inside it, create:

```text
LitratoLink Storage/
  development/
  production/
```

Inside development:

```text
development/
  albums/
```

Inside production later:

```text
production/
  albums/
```

---

## 13. Album Folder Structure

For each album:

```text
albums/
  {album_id}/
    originals/
    thumbnails/
```

Example:

```text
albums/
  2f1a-album-id/
    originals/
      9c2b-file-id_IMG_001.JPG
    thumbnails/
      9c2b-file-id_thumb.jpg
```

Rules:

* Originals folder stores original files.
* Thumbnails folder stores preview files only.
* Thumbnails must never replace originals.

---

# PART B: BACKEND STORAGE DESIGN

---

## 14. Backend Responsibility

The backend should handle Google Drive API logic.

The Flutter app should not contain:

* Google client secret
* Google refresh token
* Supabase service role key
* Storage owner credentials
* Private API keys

These must stay in Supabase Edge Functions or secure backend environment variables.

---

## 15. Storage Service Design

Create a storage service concept.

Recommended interface:

```text
StorageService
  uploadOriginalFile()
  getDownloadAccess()
  deleteFile()
  restoreFile()
  createFolderIfNeeded()
```

V1 implementation:

```text
GoogleDriveStorageService
```

Future implementation:

```text
R2StorageService
GoogleCloudStorageService
SupabaseStorageService
```

Reason:

This prevents the app from being locked forever to Google Drive.

---

## 16. Edge Functions Needed for Proof

For the first proof, only create these functions:

1. `create-upload-session`
2. `complete-upload`
3. `get-download-access`

Optional for proof:

4. `test-google-drive-connection`

---

## 17. Proof Function: `test-google-drive-connection`

## 17.1 Purpose

Checks if backend can connect to Google Drive API.

## 17.2 Request

No file upload yet.

## 17.3 Backend Actions

1. Load Google credentials.
2. Connect to Google Drive API.
3. Check root folder exists.
4. Return success.

## 17.4 Success Response

```json
{
  "success": true,
  "data": {
    "connected": true,
    "root_folder_found": true
  }
}
```

## 17.5 Fail Response

```json
{
  "success": false,
  "error_code": "GOOGLE_DRIVE_CONNECTION_FAILED",
  "message": "Google Drive connection failed."
}
```

---

## 18. Proof Function: `create-upload-session`

## 18.1 Purpose

Prepares upload of one original file.

## 18.2 Request Body

```json
{
  "album_id": "uuid",
  "original_filename": "IMG_001.JPG",
  "mime_type": "image/jpeg",
  "file_size_bytes": 5123456,
  "file_type": "photo"
}
```

## 18.3 Backend Checks

The backend must check:

1. User is logged in.
2. Album exists.
3. Album is not deleted.
4. User is active album member.
5. User role is Admin or Contributor.
6. File type is valid.
7. File size is greater than 0.
8. Storage provider is available.

## 18.4 Backend Actions

1. Create or find album folder in Google Drive.
2. Create or find `originals` folder.
3. Create pending `storage_objects` record.
4. Create pending `media_files` record.
5. Create Google Drive upload session.
6. Return upload URL or upload instruction.

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

---

## 19. Proof Function: `complete-upload`

## 19.1 Purpose

Confirms upload is complete.

## 19.2 Request Body

```json
{
  "media_file_id": "uuid",
  "storage_object_id": "uuid",
  "provider_file_id": "google-drive-file-id",
  "final_file_size_bytes": 5123456,
  "checksum": "optional"
}
```

## 19.3 Backend Checks

1. User is logged in.
2. Media file exists.
3. User is original uploader.
4. Storage object exists.
5. Google Drive file exists.
6. File size matches if possible.

## 19.4 Backend Actions

1. Update `storage_objects`.
2. Save Google Drive file ID.
3. Update `media_files`.
4. Set upload status to `completed`.
5. Set uploaded date.
6. Return completed file data.

## 19.5 Success Response

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "upload_status": "completed"
  }
}
```

---

## 20. Proof Function: `get-download-access`

## 20.1 Purpose

Gets secure access to download the original file.

## 20.2 Request Body

```json
{
  "media_file_id": "uuid"
}
```

## 20.3 Backend Checks

1. User is logged in.
2. File exists.
3. File is completed.
4. File is not deleted.
5. Album is not deleted.
6. User is active album member.
7. User role is Admin, Contributor, or Viewer.

## 20.4 Backend Actions

1. Get Google Drive file ID.
2. Create controlled download access.
3. Return download URL or stream response.

## 20.5 Success Response

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "download_url": "temporary-download-url",
    "original_filename": "IMG_001.JPG",
    "mime_type": "image/jpeg",
    "file_size_bytes": 5123456
  }
}
```

---

# PART C: UPLOAD STRATEGY

---

## 21. Upload Type

Use resumable upload for proof if possible.

Reason:

* Better for large files
* Better for mobile networks
* Can recover from interruptions
* Better for videos

For very first test, simple upload can be tested if faster.

But final V1 should use resumable upload.

---

## 22. Upload Original File Rule

The file selected by the user must be the original file.

The app must not:

* Compress file
* Resize file
* Convert file
* Strip quality
* Replace original with preview

Important:

Some picker packages may return compressed images if configured incorrectly.

Codex must check this carefully.

---

## 23. Upload Metadata to Save

Before or after upload, save:

* Album ID
* Uploader ID
* Original filename
* File type
* MIME type
* File size
* Upload status
* Storage object ID
* Google Drive file ID after complete upload
* Created date
* Uploaded date

Optional:

* Width
* Height
* Duration
* Checksum

---

## 24. Upload Progress

For proof, show simple progress.

Example:

```text
Uploading 45%
```

For final app, show:

```text
Uploading 1 of 3
45%
```

---

## 25. Upload Failure Handling

If upload fails:

* Do not mark file as completed.
* Keep status as failed or pending.
* Show error message.
* Allow retry later.
* Do not create duplicate completed records.

User message:

**Upload failed. Please try again.**

---

# PART D: DOWNLOAD STRATEGY

---

## 26. Download Original File Rule

Download must use the original Google Drive file.

Do not download:

* Thumbnail
* Preview image
* Compressed version
* Converted file

---

## 27. Download Options

For proof:

* Download file to app storage or device Downloads folder.

Later:

* Save to Photos / Gallery
* Save to Files
* Save All
* Selected download

---

## 28. Download Progress

For proof, show simple progress.

Example:

```text
Downloading 45%
```

For final app:

```text
Saving 3 of 30
45%
```

---

## 29. Download Failure Handling

If download fails:

* Show clear error.
* Allow retry.
* Do not save partial file as complete.
* Do not mark download as successful.

User message:

**Download failed. Please try again.**

---

# PART E: ORIGINAL QUALITY PROOF

---

## 30. Test File Set

Use these test files:

### Photo Tests

1. iPhone photo
2. Android photo
3. Screenshot
4. Large high-resolution photo
5. Edited photo from another app

### Video Tests

1. Short iPhone video
2. Short Android video
3. Large video
4. High-resolution video
5. Long video if possible

---

## 31. Required Quality Comparison

For each uploaded and downloaded file, compare:

* Original file name
* Downloaded file name
* Original file size
* Downloaded file size
* Original MIME type
* Downloaded MIME type
* Original width
* Downloaded width
* Original height
* Downloaded height
* Original video duration
* Downloaded video duration

Pass condition:

Downloaded file should match original file as closely as possible.

---

## 32. Optional Checksum Test

If possible, calculate checksum before upload and after download.

Example:

* SHA-256 hash

If checksum matches:

The file is exactly the same.

If checksum does not match:

Check if metadata changed or if file content changed.

For strongest proof, checksum should match.

---

## 33. Proof Result Table

Use this table during testing.

| Test File     | Type  | Original Size | Downloaded Size | Resolution Match | Duration Match | Checksum Match | Result |
| ------------- | ----- | ------------: | --------------: | ---------------- | -------------- | -------------- | ------ |
| iPhone photo  | Photo |               |                 |                  | N/A            |                |        |
| Android photo | Photo |               |                 |                  | N/A            |                |        |
| Screenshot    | Photo |               |                 |                  | N/A            |                |        |
| Short video   | Video |               |                 |                  |                |                |        |
| Large video   | Video |               |                 |                  |                |                |        |

---

# PART F: DATABASE RECORDS NEEDED FOR PROOF

---

## 34. Required Tables for Proof

Only these tables are needed for first Google Drive proof:

1. `user_profiles`
2. `albums`
3. `album_members`
4. `storage_providers`
5. `storage_objects`
6. `media_files`

Do not build the full database yet if proof is the goal.

---

## 35. Minimum `storage_objects` Data

Store:

* Provider ID
* Google Drive file ID
* Folder ID if needed
* Storage path
* File size
* MIME type
* Created date

---

## 36. Minimum `media_files` Data

Store:

* Album ID
* Uploader ID
* Storage object ID
* Original filename
* File type
* MIME type
* File size
* Upload status
* Uploaded date

---

# PART G: PROOF TEST CASES

---

## 37. Test Case 1: Google Drive Connection

Steps:

1. Call `test-google-drive-connection`.
2. Backend connects to Google Drive.
3. Backend checks root folder.

Expected result:

Connection success.

Pass if:

Backend can access Google Drive storage folder.

---

## 38. Test Case 2: Upload One Photo

Steps:

1. Login.
2. Create album.
3. Select one photo.
4. Call `create-upload-session`.
5. Upload file.
6. Call `complete-upload`.

Expected result:

Photo uploads and metadata is saved.

Pass if:

* File exists in Google Drive.
* `media_files` record exists.
* `storage_objects` record exists.
* Upload status is completed.

---

## 39. Test Case 3: Download One Photo

Steps:

1. Open uploaded photo.
2. Call `get-download-access`.
3. Download file.
4. Save file locally.
5. Compare original and downloaded file.

Expected result:

File downloads in original quality.

Pass if:

Downloaded file matches original.

---

## 40. Test Case 4: Upload One Video

Steps:

1. Select one video.
2. Upload original video.
3. Complete upload.
4. Download video.
5. Compare original and downloaded file.

Expected result:

Video quality is unchanged.

Pass if:

Downloaded video matches original.

---

## 41. Test Case 5: Permission Check

Steps:

1. User A creates album.
2. User A uploads file.
3. User B is not invited.
4. User B tries to access file.

Expected result:

User B is blocked.

Pass if:

Backend returns permission error.

---

## 42. Test Case 6: Viewer Download

Steps:

1. User A creates album.
2. User A invites User B as Viewer.
3. User B accepts invite.
4. User B downloads file.

Expected result:

Viewer can download original file.

Pass if:

Download works for Viewer.

Note:

This test can be done after invite feature exists.

---

## 43. Test Case 7: Interrupted Upload

Steps:

1. Start large upload.
2. Interrupt network.
3. Resume or retry upload.

Expected result:

Upload can recover or retry safely.

Pass if:

No corrupted completed file is created.

---

# PART H: DECISION POINTS AFTER PROOF

---

## 44. If Proof Works

If proof works:

Continue with:

1. Multiple uploads
2. Gallery
3. Invites
4. Roles
5. Save All
6. Soft delete
7. Notifications

Keep Google Drive-backed storage for V1.

---

## 45. If Proof Partly Works

If upload works but download is hard:

Review:

* Download access approach
* Backend proxy download
* Temporary file access
* Google Drive API method

If original quality changes:

Review:

* Picker package
* Upload method
* Download method
* Thumbnail confusion
* File conversion

If API quota is a problem:

Review:

* Request pattern
* Batch behavior
* Backoff and retry
* Storage provider future migration

---

## 46. If Proof Fails

If Google Drive-backed storage fails badly:

Do not continue full MVP yet.

Review backup storage options:

1. Google Cloud Storage
2. Cloudflare R2
3. Supabase Storage

But for current plan, first try to make Google Drive proof work.

---

# PART I: COMMON RISKS

---

## 47. Risk: Wrong OAuth Scope

Problem:

The chosen Google Drive scope may not allow required backend storage actions.

Solution:

Test early with minimum scope.

Use the least broad scope that supports the required flow.

---

## 48. Risk: Exposed Credentials

Problem:

Google storage credentials might accidentally be placed in Flutter.

Solution:

Keep credentials only in backend environment variables.

Never commit secrets to GitHub.

---

## 49. Risk: Compressed File Picker Output

Problem:

The Flutter picker may return a compressed version of a photo.

Solution:

Use file picker settings that return original files.

Test file size and checksum.

---

## 50. Risk: Large Video Upload Failure

Problem:

Large videos may fail on mobile internet.

Solution:

Use resumable uploads and retry logic.

---

## 51. Risk: Google Drive Quota or Rate Limits

Problem:

Too many uploads/downloads may hit quota or rate limits.

Solution:

Use efficient requests.

Add retry with exponential backoff.

Track errors.

For V1 small use, this is likely manageable, but still test.

---

## 52. Risk: Permanent Public Links

Problem:

Download links may become public or long-lived.

Solution:

Use backend permission checks.

Avoid permanent public file links.

Use controlled access.

---

# PART J: PROOF COMPLETION CHECKLIST

---

## 53. Google Setup Checklist

* Google Cloud project created.
* Google Drive API enabled.
* OAuth consent screen created.
* Required OAuth scopes selected.
* Managed Google Drive storage account ready.
* Root storage folder created.
* Environment variables prepared.

---

## 54. Supabase Setup Checklist

* Supabase project created.
* Required proof tables created.
* RLS enabled.
* Storage provider seeded.
* Edge Functions prepared.
* Environment variables added.
* Service role key kept backend-only.

---

## 55. Flutter Setup Checklist

* Flutter app runs.
* Supabase client connects.
* Google Login works.
* File picker selects original file.
* Upload progress displays.
* Download progress displays.
* Quality test values can be shown or logged.

---

## 56. Proof Success Checklist

Proof is successful if:

* Backend connects to Google Drive.
* User can upload one original photo.
* User can download the same photo.
* Downloaded file keeps original quality.
* User can upload one original video.
* User can download the same video.
* Downloaded video keeps original quality.
* Non-member access is blocked.
* Secrets are not exposed in Flutter.
* Metadata is saved correctly.

---

## 57. Final Decision After Proof

After proof, decide one of these:

### Decision A: Continue With Google Drive

Choose this if:

* Upload works.
* Download works.
* Quality is preserved.
* Quota is acceptable.
* Backend storage access is secure.

### Decision B: Continue But Improve Google Drive Flow

Choose this if:

* Upload works but needs better retry.
* Download works but needs better access control.
* Folder structure needs changes.

### Decision C: Review Backup Storage

Choose this only if:

* Google Drive API blocks required flow.
* Original quality cannot be preserved.
* Upload/download is unreliable.
* Permission design becomes too risky.

---

## 58. Next Recommended Document

The next recommended document is:

**LitratoLink First Sprint Task List v1.0**

This document should break the first development sprint into small tasks.

It should include:

* Setup tasks
* Supabase tasks
* Flutter tasks
* Google Drive proof tasks
* Testing tasks
* Done criteria
