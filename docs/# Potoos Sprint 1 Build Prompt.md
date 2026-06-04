# Potoos Sprint 1 Build Prompt Pack v1.0

## 1. Document Purpose

This document contains ready-to-copy prompts for Codex or any AI coding assistant.

The goal is to help build **Sprint 1: Core Original Quality Proof** in the correct order.

Sprint 1 must prove that Potoos can:

1. Log in with Google.
2. Create a private album.
3. Upload one original photo.
4. Store it in Google Drive-backed storage.
5. Save metadata in Supabase.
6. Show the file in the album.
7. Download the original file.
8. Confirm original quality is preserved.

---

## 2. Main Instruction for All Prompts

Use this instruction in every coding session if needed:

```text
You are helping me build Potoos.

Potoos is a private photo and video sharing app.

App name: Potoos
Tagline: Share Memories in Original Quality

Main rule:
The app must upload, store, and download original-quality files. Do not compress, resize, convert, or replace original files. Thumbnails are allowed only later and must be separate from the original.

Tech stack:
- Flutter frontend
- Supabase backend
- Supabase Auth with Google Login only for V1
- Supabase Postgres
- Supabase Edge Functions
- Google Drive / Google One-backed storage for V1

V1 is not social media.
Do not add:
- likes
- comments
- followers
- public feed
- public albums
- chat
- payment system
- photo editing

User roles:
- Admin
- Contributor
- Viewer

Core rules:
- Albums are private by default.
- Only invited album members can access albums.
- Admin and Contributor can upload.
- Viewer can only view and download.
- Only original uploader can delete and restore their own files.
- Deleted files are restorable for 30 days.
- Save All must download original files, not thumbnails.

Sprint 1 goal:
Build the Core Original Quality Proof only.

Sprint 1 includes:
1. Flutter setup.
2. Supabase connection.
3. Google Login.
4. User profile creation.
5. Create album.
6. Creator becomes Admin.
7. Google Drive connection test.
8. Upload one original photo.
9. Save file metadata.
10. Show uploaded file.
11. Download original photo.
12. Compare original and downloaded file size.
13. Block non-member access.

Do not build invites, Save All, notifications, soft delete, restore, monetization, or social features yet.

Never store secrets in Flutter.
Never store Supabase service role key in Flutter.
Never store Google Drive client secret or refresh token in Flutter.
Use environment variables.
Keep code clean and organized.
```

---

# PART A: PROJECT SETUP PROMPTS

---

## 3. Prompt 1: Create Project Structure

Use this prompt first.

```text
Create the initial project structure for Potoos.

Root folder should be:

potoos/
  app/
  supabase/
  docs/
  assets/
  README.md

Inside docs/, prepare placeholder markdown files:

01-master-product-plan.md
02-system-architecture.md
03-database-design.md
04-ui-ux-flow.md
05-development-roadmap.md
06-codex-development-instructions.md
07-api-edge-functions.md
08-supabase-sql-rls-plan.md
09-app-store-testflight-plan.md
10-privacy-terms-plan.md
11-mvp-checklist-testing-plan.md
12-project-summary-master-index.md
13-implementation-starter-pack.md
14-google-drive-api-proof-plan.md
15-first-sprint-task-list.md
16-actual-sql-migration-draft.md
17-edge-functions-implementation-plan.md
18-flutter-project-structure-guide.md
19-sprint-1-build-prompt-pack.md

Add a README.md with:
- Project name: Potoos
- Tagline: Share Memories in Original Quality
- Short description
- Tech stack
- Sprint 1 goal
- Main rules

Do not add code yet.
```

---

## 4. Prompt 2: Create Flutter App

```text
Create the Flutter app inside the app/ folder.

Use Flutter.

After creating the app, organize lib/ into this structure:

lib/
  main.dart

  app/
    app.dart
    routes.dart
    theme.dart

  config/
    env.dart
    constants.dart

  core/
    errors/
      app_error.dart
      error_mapper.dart

    services/
      supabase_service.dart
      edge_function_service.dart
      file_service.dart

    utils/
      file_utils.dart
      format_utils.dart
      validation_utils.dart

    widgets/
      app_button.dart
      app_text_field.dart
      app_loading.dart
      app_empty_state.dart
      app_error_state.dart

  features/
    auth/
      data/
        auth_repository.dart
      models/
        user_profile.dart
      providers/
        auth_provider.dart
      screens/
        splash_screen.dart
        login_screen.dart
      widgets/
        google_login_button.dart

    albums/
      data/
        album_repository.dart
      models/
        album.dart
        album_member.dart
        media_file.dart
      providers/
        album_provider.dart
      screens/
        home_screen.dart
        create_album_screen.dart
        album_details_screen.dart
      widgets/
        album_card.dart
        album_empty_state.dart

    uploads/
      data/
        upload_repository.dart
      models/
        upload_file.dart
        upload_session.dart
      providers/
        upload_provider.dart
      screens/
        upload_screen.dart
        upload_progress_screen.dart
      widgets/
        selected_file_card.dart
        upload_progress_card.dart

    downloads/
      data/
        download_repository.dart
      models/
        download_access.dart
      providers/
        download_provider.dart
      screens/
        file_preview_screen.dart
      widgets/
        download_button.dart

    profile/
      data/
        profile_repository.dart
      providers/
        profile_provider.dart
      screens/
        profile_screen.dart

Keep main.dart short.
Do not put all code in main.dart.
Use clean, simple structure.
Do not build future features yet.
```

---

## 5. Prompt 3: Add Flutter Packages

```text
Add the required Flutter packages for Sprint 1.

Use packages for:
- Supabase Flutter
- Riverpod
- Environment variables
- File picking
- Upload/download with progress
- Local file path support
- Permissions if needed

Suggested packages:
- supabase_flutter
- flutter_riverpod
- flutter_dotenv
- file_picker
- dio
- path_provider
- path
- permission_handler

Do not add notification packages yet.
Do not add Firebase Messaging yet.
Do not add payment packages.
Do not add photo editing packages.

After adding packages:
- Update pubspec.yaml
- Make sure app still builds
- Add basic comments about why each package is used
```

---

# PART B: SUPABASE DATABASE PROMPTS

---

## 6. Prompt 4: Create Sprint 1 SQL Migration

```text
Create the Sprint 1 Supabase SQL migration for Potoos.

This migration is for development only.

It must create only these Sprint 1 tables:

1. user_profiles
2. storage_providers
3. albums
4. album_members
5. storage_objects
6. media_files

Create these enum types:
- album_role: admin, contributor, viewer
- media_file_type: photo, video
- upload_status: pending, uploading, completed, failed
- storage_provider_type: google_drive, cloudflare_r2, google_cloud_storage, supabase_storage

Add:
- Primary keys
- Foreign keys
- Basic constraints
- Indexes
- updated_at trigger
- Helper functions:
  - is_album_member
  - get_album_role
  - is_album_admin
  - can_upload_to_album
  - is_file_uploader
  - album_has_other_admin

Enable Row Level Security on:
- user_profiles
- storage_providers
- albums
- album_members
- storage_objects
- media_files

Add Sprint 1 RLS policies:
- User can read/insert/update own profile.
- User can read active storage providers.
- User can read albums where they are active member.
- User can create album where owner_id is auth.uid().
- Admin can update albums.
- Members can read album members.
- Admin can insert/update album members.
- Members can read media files only if they are active album members.
- Uploaders can read their own deleted files.
- Admin and Contributor can insert media file records.
- Non-members cannot access albums or media files.

Seed one storage provider:
Name: Google Drive Main
Type: google_drive

Important:
This is Sprint 1 only.
Do not create invites, notifications, trash, payments, or monetization tables yet.
```

---

## 7. Prompt 5: Review SQL Migration for Security

```text
Review the Potoos Sprint 1 SQL migration for security issues.

Focus on:
- RLS policies
- Helper functions
- Security definer usage
- Album membership checks
- Non-member access blocking
- Viewer upload blocking
- Service role assumptions
- Whether any table is too open
- Whether storage_objects are exposed too much

Rules:
- Only active album members can access album files.
- Admin and Contributor can upload.
- Viewer cannot upload.
- Non-members cannot read albums or media files.
- Users can only read their own deleted files.
- Frontend hiding is not enough.
- Backend/database must block unauthorized access.

Give:
1. Issues found
2. Why each issue matters
3. Suggested SQL fix
4. Whether it is safe for Sprint 1 testing
```

---

# PART C: EDGE FUNCTIONS PROMPTS

---

## 8. Prompt 6: Create Edge Functions Folder and Shared Helpers

```text
Create the Supabase Edge Functions structure for Potoos Sprint 1.

Use this folder structure:

supabase/
  functions/
    _shared/
      cors.ts
      response.ts
      auth.ts
      supabaseAdmin.ts
      validation.ts
      permissions.ts
      googleDrive.ts
      storagePaths.ts

    create-user-profile/
      index.ts

    create-album/
      index.ts

    test-google-drive-connection/
      index.ts

    create-upload-session/
      index.ts

    complete-upload/
      index.ts

    get-download-access/
      index.ts

Create shared helper files:

cors.ts:
- CORS headers
- OPTIONS handling support

response.ts:
- success(data, status)
- error(error_code, message, status)

supabaseAdmin.ts:
- Creates Supabase client using SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY
- Service role key must only be used inside Edge Functions

auth.ts:
- Reads Authorization: Bearer token
- Gets user from Supabase auth
- Returns user or auth error

validation.ts:
- Validate UUID
- Validate album name
- Validate file type
- Validate file size
- Validate MIME type
- Validate filename

permissions.ts:
- getAlbumRole
- isAlbumMember
- canUploadToAlbum

storagePaths.ts:
- Create album originals path
- Create safe storage filename

googleDrive.ts:
- Get Google access token from refresh token
- Get Drive file metadata
- Create Drive folder
- Create resumable upload session

Do not implement future functions yet.
Do not expose secrets.
Do not return raw Google tokens except only if needed for Sprint 1 download proof.
```

---

## 9. Prompt 7: Build create-user-profile Function

```text
Build the create-user-profile Supabase Edge Function for Potoos.

Purpose:
Create a user profile after Google Login.

Requirements:
- Handle CORS
- Require authenticated user
- Read current user from Authorization Bearer token
- Get email from Supabase Auth user
- Accept optional display_name and avatar_url
- Check if user_profiles record already exists
- If exists, return it
- If missing, insert new profile
- Return consistent success/error response

Request body:
{
  "display_name": "User Name",
  "avatar_url": "https://example.com/avatar.jpg"
}

Success response:
{
  "success": true,
  "data": {
    "user_id": "uuid",
    "email": "user@example.com",
    "display_name": "User Name"
  }
}

Error responses:
- UNAUTHENTICATED
- INVALID_REQUEST
- SERVER_ERROR

Rules:
- Do not expose raw errors to the app.
- Do not use service role key in Flutter.
- Keep code simple and clear.
```

---

## 10. Prompt 8: Build create-album Function

```text
Build the create-album Supabase Edge Function for Potoos.

Purpose:
Create a private album and add creator as Admin.

Requirements:
- Handle CORS
- Require authenticated user
- Validate album name
- Description is optional
- Check user profile exists
- Get active Google Drive Main storage provider
- Insert album with owner_id = logged-in user ID
- Insert album_members record with role = admin
- If album member insert fails, handle cleanup or return safe error
- Return album_id, name, and role

Request body:
{
  "name": "Me and GF",
  "description": "Private memories"
}

Success response:
{
  "success": true,
  "data": {
    "album_id": "uuid",
    "name": "Me and GF",
    "role": "admin"
  }
}

Rules:
- Albums are private by default.
- Creator must become Admin.
- Do not allow empty album name.
- Do not build invite feature yet.
```

---

## 11. Prompt 9: Build Google Drive Connection Test Function

```text
Build the test-google-drive-connection Supabase Edge Function for Potoos.

Purpose:
Check if backend can connect to Google Drive.

Requirements:
- Handle CORS
- Require authenticated user for development
- Load GOOGLE_DRIVE_ROOT_FOLDER_ID from environment variables
- Use googleDrive.ts helper
- Get folder metadata from Google Drive API
- Confirm folder exists
- Return folder name and connected status
- Do not return Google access token
- Do not return private credentials

Success response:
{
  "success": true,
  "data": {
    "connected": true,
    "root_folder_found": true,
    "root_folder_name": "Potoos Storage"
  }
}

Error responses:
- UNAUTHENTICATED
- STORAGE_ERROR
- SERVER_ERROR

Rules:
- This function is for development testing.
- Later it should be admin-only or removed.
```

---

## 12. Prompt 10: Build create-upload-session Function

```text
Build the create-upload-session Supabase Edge Function for Potoos.

Purpose:
Prepare upload of one original photo or video.

Request body:
{
  "album_id": "uuid",
  "original_filename": "IMG_001.JPG",
  "mime_type": "image/jpeg",
  "file_size_bytes": 5123456,
  "file_type": "photo"
}

Requirements:
- Handle CORS
- Require authenticated user
- Validate album_id
- Validate filename
- Validate MIME type
- Validate file size
- Validate file_type as photo or video
- Check album exists and is not deleted
- Check user is Admin or Contributor in that album
- Viewer must be blocked
- Non-member must be blocked
- Get Google Drive Main storage provider
- Create pending storage_objects record
- Create pending media_files record
- Create or find Google Drive album folder
- Create or find originals folder
- Create safe storage filename
- Create Google Drive resumable upload session
- Return media_file_id, storage_object_id, upload_url, upload_method, required_headers

Success response:
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

Important rules:
- Do not upload file bytes through Edge Function.
- Edge Function only creates the upload session.
- Flutter uploads original file bytes to upload_url.
- Do not compress, resize, or convert files.
- Do not expose Google client secret or refresh token.
```

---

## 13. Prompt 11: Build complete-upload Function

```text
Build the complete-upload Supabase Edge Function for Potoos.

Purpose:
Mark a Google Drive upload as completed.

Request body:
{
  "media_file_id": "uuid",
  "storage_object_id": "uuid",
  "provider_file_id": "google-drive-file-id",
  "final_file_size_bytes": 5123456,
  "checksum": "optional"
}

Requirements:
- Handle CORS
- Require authenticated user
- Validate media_file_id
- Validate storage_object_id
- Validate provider_file_id
- Get media file record
- Check logged-in user is the uploader
- Get Google Drive file metadata using provider_file_id
- Confirm file exists in Google Drive
- Compare size if available
- Update storage_objects with provider_file_id, file size, checksum if available
- Update media_files upload_status to completed
- Set uploaded_at
- Return completed file data

Rules:
- Do not mark upload completed if Google Drive file cannot be confirmed.
- Non-uploader cannot complete upload.
- Do not expose raw Google API error to user.
```

---

## 14. Prompt 12: Build get-download-access Function

```text
Build the get-download-access Supabase Edge Function for Potoos.

Purpose:
Allow active album members to download the original file.

Request body:
{
  "media_file_id": "uuid"
}

Requirements:
- Handle CORS
- Require authenticated user
- Validate media_file_id
- Get media file record
- Check upload_status is completed
- Check file is not deleted
- Check file is not permanently deleted
- Check album is not deleted
- Check user is active member of the album
- Get storage object
- Get Google Drive provider_file_id
- Return download access for original file only

For Sprint 1, you may use:
Option A:
- Return Google Drive download URL plus short-lived access token

or Option B:
- Return proxy download URL if implemented

Important:
- Do not return permanent public links.
- Do not use thumbnail.
- Do not allow non-members to download.
- Download must use original file.
```

---

# PART D: FLUTTER FEATURE PROMPTS

---

## 15. Prompt 13: Build Flutter Environment and Supabase Initialization

```text
Build Flutter environment loading and Supabase initialization for Potoos.

Requirements:
- Use flutter_dotenv for .env
- Load APP_ENV, SUPABASE_URL, SUPABASE_ANON_KEY
- Initialize Supabase in main.dart
- Keep main.dart short
- Create config/env.dart
- Create core/services/supabase_service.dart
- Do not store service role key in Flutter
- Do not store Google secrets in Flutter

.env example:
APP_ENV=development
SUPABASE_URL=
SUPABASE_ANON_KEY=

After setup:
- App should run
- Supabase should initialize without errors
```

---

## 16. Prompt 14: Build App Theme and Basic Routes

```text
Build the Potoos Flutter app shell.

Requirements:
- Create app/app.dart
- Create app/routes.dart
- Create app/theme.dart
- Use app name: Potoos
- Use tagline: Share Memories in Original Quality
- Use simple maroon-based theme
- Add routes for:
  - Splash
  - Login
  - Home
  - Create Album
  - Album Details
  - Upload
  - File Preview
  - Profile

Keep design simple.
Do not build future screens yet.
```

---

## 17. Prompt 15: Build Flutter Auth Feature

```text
Build the Flutter Auth feature for Potoos Sprint 1.

Requirements:
- Use Supabase Auth with Google Login only
- Create splash screen
- Create login screen
- Add Continue with Google button
- After login, call create-user-profile Edge Function
- Store/load current user profile
- Session should persist after app restart
- Add logout function
- Use Riverpod for auth state

Files:
features/auth/data/auth_repository.dart
features/auth/models/user_profile.dart
features/auth/providers/auth_provider.dart
features/auth/screens/splash_screen.dart
features/auth/screens/login_screen.dart
features/auth/widgets/google_login_button.dart

Rules:
- Do not add Apple Login yet.
- Do not add Email Login yet.
- Show user-friendly errors.
```

---

## 18. Prompt 16: Build Edge Function Service in Flutter

```text
Build core/services/edge_function_service.dart for Potoos.

Purpose:
All Flutter calls to Supabase Edge Functions should go through this service.

Requirements:
- Get current Supabase session access token
- Send Authorization: Bearer token
- Support POST requests
- Parse standard success response:
  { "success": true, "data": {} }
- Parse standard error response:
  { "success": false, "error_code": "...", "message": "..." }
- Throw or return user-friendly app errors
- Do not show raw backend errors directly

Functions needed:
- callFunction(name, body)
- Optional typed helpers later

Rules:
- Do not duplicate Edge Function call logic in every repository.
- Keep this service reusable.
```

---

## 19. Prompt 17: Build Album Feature

```text
Build the Flutter Albums feature for Sprint 1.

Requirements:
- Home screen shows current user's albums
- Create Album screen allows album name and optional description
- Call create-album Edge Function
- After album creation, open Album Details screen
- Album Details screen shows:
  - Album name
  - User role
  - Upload button
  - Uploaded file list or simple gallery

Files:
features/albums/data/album_repository.dart
features/albums/models/album.dart
features/albums/models/album_member.dart
features/albums/models/media_file.dart
features/albums/providers/album_provider.dart
features/albums/screens/home_screen.dart
features/albums/screens/create_album_screen.dart
features/albums/screens/album_details_screen.dart
features/albums/widgets/album_card.dart
features/albums/widgets/album_empty_state.dart

Rules:
- Albums are private by default.
- Creator becomes Admin.
- Upload button should only show for Admin or Contributor.
- For Sprint 1, invite/member management is not needed yet.
```

---

## 20. Prompt 18: Build File Selection and Upload Metadata

```text
Build the file selection part of the Upload feature.

Requirements:
- User can select one photo for Sprint 1
- Use file picker or safest package to get original file
- Do not compress
- Do not resize
- Do not convert
- Read:
  - local path
  - original filename
  - MIME type
  - file size
  - file type photo/video
- Show selected file name and size on Upload Screen

Files:
features/uploads/models/upload_file.dart
features/uploads/screens/upload_screen.dart
core/services/file_service.dart
core/utils/file_utils.dart

Important:
If using an image picker, make sure it does not return a compressed image.
The selected file must be the original file as much as possible.
```

---

## 21. Prompt 19: Build Upload Repository and Upload Progress

```text
Build the upload logic for Sprint 1.

Requirements:
- UploadRepository should:
  1. Call create-upload-session Edge Function
  2. Upload original file bytes to returned upload_url
  3. Track upload progress
  4. Capture Google Drive final response and provider_file_id
  5. Call complete-upload Edge Function
  6. Return completed media file

Use dio or another package that supports upload progress.

Files:
features/uploads/data/upload_repository.dart
features/uploads/models/upload_session.dart
features/uploads/providers/upload_provider.dart
features/uploads/screens/upload_progress_screen.dart
features/uploads/widgets/upload_progress_card.dart

Rules:
- Do not compress file.
- Do not resize file.
- Upload original bytes only.
- Show progress.
- Show clear error if upload fails.
- Do not mark upload complete unless complete-upload succeeds.
```

---

## 22. Prompt 20: Build Album File List

```text
Build the Sprint 1 album file list.

Requirements:
- Album Details screen should load completed active media_files for the album
- Show:
  - original filename
  - file size
  - MIME type
  - upload date if available
- Tapping a file opens File Preview screen

Rules:
- Only show upload_status = completed
- Do not show deleted files
- RLS should ensure only album members can see files
- Gallery can be simple list for Sprint 1
- Thumbnail preview is not required yet
```

---

## 23. Prompt 21: Build Download Original Feature

```text
Build the Download Original feature for Sprint 1.

Requirements:
- File Preview screen shows file info
- Add Download Original button
- On tap:
  1. Call get-download-access Edge Function
  2. Download original file from returned access
  3. Save file locally
  4. Show progress
  5. Show success or error

Files:
features/downloads/data/download_repository.dart
features/downloads/models/download_access.dart
features/downloads/providers/download_provider.dart
features/downloads/screens/file_preview_screen.dart
features/downloads/widgets/download_button.dart

Rules:
- Download original file only.
- Do not download thumbnail.
- Do not use compressed version.
- Non-members must be blocked by backend.
- Show user-friendly error messages.
```

---

## 24. Prompt 22: Build Quality Test Logging

```text
Build simple quality test logging for Sprint 1.

Purpose:
Help compare original file vs downloaded file.

Before upload, log or display:
- Original filename
- Original file size
- Original MIME type
- Original local path

After download, log or display:
- Downloaded filename
- Downloaded file size
- Downloaded MIME type
- Downloaded local path

Optional if simple:
- SHA-256 checksum before upload and after download

Add this in a simple developer-only section or debug log.

Rules:
- Do not add complicated UI.
- This is for testing original quality.
- If file sizes differ, show a warning in logs.
```

---

# PART E: TESTING PROMPTS

---

## 25. Prompt 23: Test Sprint 1 Core Flow

```text
Test the Potoos Sprint 1 core flow.

Flow:
1. Open app.
2. Log in with Google.
3. Confirm user profile is created.
4. Create album.
5. Confirm creator becomes Admin.
6. Open album.
7. Select one original photo.
8. Upload photo.
9. Confirm file exists in Google Drive.
10. Confirm storage_objects record exists.
11. Confirm media_files record exists.
12. Confirm upload_status is completed.
13. Open uploaded file.
14. Download original file.
15. Compare original and downloaded file size.
16. Confirm non-member access is blocked.

Report:
- What passed
- What failed
- Any errors
- Any quality mismatch
- Any security issue
```

---

## 26. Prompt 24: Test Original Quality

```text
Test if Potoos keeps original quality.

Use at least:
- 1 iPhone photo
- 1 Android photo
- 1 screenshot
- 1 short video if video upload is already supported

For each file, compare:
- Original file size
- Downloaded file size
- Original MIME type
- Downloaded MIME type
- Original resolution
- Downloaded resolution
- Video duration if video
- SHA-256 checksum if available

Pass condition:
Downloaded file should match original as much as possible.
Best condition:
Checksum matches exactly.

If quality does not match, investigate:
- Picker may be compressing file
- Upload may use wrong file path
- Download may use thumbnail
- File may be converted
- Partial download may be saved
```

---

## 27. Prompt 25: Test RLS and Permissions

```text
Test Potoos Sprint 1 database security.

Create:
- User A
- User B

Test:
1. User A creates album.
2. User A uploads file.
3. User B is not a member.
4. User B tries to read album.
5. User B tries to read media file.
6. User B tries to create media file in User A album.
7. User B tries to download User A file.

Expected:
- User B should be blocked from all private album data.
- User B should not see album.
- User B should not see file metadata.
- User B should not upload.
- User B should not download.

Also test:
- Viewer cannot upload if viewer role is manually added.
- Admin can upload.
- Contributor can upload if role is manually added.

Report any RLS policy that is too open.
Suggest fixes.
```

---

## 28. Prompt 26: Debug Upload Problems

```text
Debug Potoos upload problem.

Context:
Upload should work like this:
1. Flutter selects original file.
2. Flutter calls create-upload-session.
3. Backend creates pending storage_objects and media_files records.
4. Backend creates Google Drive resumable upload session.
5. Flutter uploads original file bytes to upload_url.
6. Flutter receives Google Drive file ID.
7. Flutter calls complete-upload.
8. Backend confirms file exists and marks upload completed.

Problem:
[PASTE ERROR OR DESCRIPTION HERE]

Please check:
- File picker result
- File path
- MIME type
- File size
- create-upload-session request
- upload_url
- upload headers
- Google Drive final response
- provider_file_id extraction
- complete-upload request
- Supabase records
- RLS or service role issues
- Google Drive API errors

Rules:
- Do not compress or resize file.
- Do not mark upload complete unless Google Drive confirms file.
- Do not expose secrets.
Give a clear fix.
```

---

## 29. Prompt 27: Debug Download Problems

```text
Debug Potoos download problem.

Context:
Download should work like this:
1. User opens completed media file.
2. Flutter calls get-download-access.
3. Backend checks album membership.
4. Backend checks file is active and completed.
5. Backend returns original file access.
6. Flutter downloads original file.
7. Flutter saves file locally.
8. Tester compares downloaded file with original.

Problem:
[PASTE ERROR OR DESCRIPTION HERE]

Please check:
- media_file_id
- upload_status
- storage_object_id
- provider_file_id
- album membership
- get-download-access response
- download URL
- access token if used
- file save path
- downloaded file size
- whether thumbnail or wrong file is being downloaded
- Google Drive API error
- permission error

Rules:
- Download original file only.
- Do not download thumbnail.
- Non-members must be blocked.
Give a clear fix.
```

---

## 30. Prompt 28: Review Code Against Potoos Rules

```text
Review the current Potoos code against the project rules.

Check:
1. Does the app preserve original quality?
2. Does any code compress, resize, or convert files?
3. Are thumbnails separate or not used yet?
4. Are secrets kept out of Flutter?
5. Are Edge Functions used for protected actions?
6. Does Google Login work correctly?
7. Are albums private by default?
8. Are RLS policies protecting data?
9. Can non-members access private data?
10. Is code organized by feature?
11. Is too much logic inside main.dart?
12. Are error messages user-friendly?
13. Are there any social features accidentally added?
14. Are future features avoided in Sprint 1?

Give:
- Pass/fail per item
- Issues found
- Specific file references
- Suggested fixes
```

---

# PART F: GITHUB / COMMIT PROMPTS

---

## 31. Prompt 29: Create Commit After Setup

```text
Create a clean Git commit for the Potoos setup.

Before committing:
- Check no .env files are committed
- Check no secrets are committed
- Check Flutter app builds
- Check folder structure is clean

Commit message:
Initial Potoos Flutter and Supabase project setup

Include:
- Root project structure
- Flutter app structure
- Basic theme/routes if already added
- Docs placeholders
```

---

## 32. Prompt 30: Create Commit After Auth

```text
Create a clean Git commit for Potoos authentication.

Before committing:
- Check Google Login works
- Check create-user-profile works
- Check logout works
- Check no secrets are committed
- Check app builds

Commit message:
Add Google authentication and user profile setup

Include:
- Auth repository
- Auth provider
- Login screen
- Splash screen
- create-user-profile Edge Function
```

---

## 33. Prompt 31: Create Commit After Album Core

```text
Create a clean Git commit for Potoos album core.

Before committing:
- Check user can create album
- Check creator becomes Admin
- Check album appears in My Albums
- Check no secrets are committed
- Check app builds

Commit message:
Add private album creation and album listing

Include:
- Album models
- Album repository
- Album provider
- Home screen
- Create album screen
- Album details screen
- create-album Edge Function
```

---

## 34. Prompt 32: Create Commit After Upload/Download Proof

```text
Create a clean Git commit for Potoos original quality upload/download proof.

Before committing:
- Check one original photo uploads successfully
- Check media_files record is completed
- Check storage_objects record has provider file ID
- Check original file downloads successfully
- Check original and downloaded file sizes are logged
- Check no secrets are committed
- Check app builds

Commit message:
Add original quality upload and download proof

Include:
- Google Drive connection helper
- create-upload-session Edge Function
- complete-upload Edge Function
- get-download-access Edge Function
- Upload feature
- Download feature
- Quality test logging
```

---

# PART G: SPRINT 1 FINAL REVIEW PROMPT

---

## 35. Prompt 33: Sprint 1 Final Review

```text
Do a final review of Potoos Sprint 1.

Sprint 1 goal:
Core Original Quality Proof.

Check if these are complete:
1. Flutter project is organized.
2. Supabase connects.
3. Google Login works.
4. User profile is created.
5. User can create album.
6. Creator becomes Admin.
7. Backend can connect to Google Drive.
8. User can upload one original photo.
9. Metadata is saved in Supabase.
10. Uploaded file appears in album.
11. User can download original photo.
12. Original and downloaded quality match.
13. Non-member access is blocked.
14. No secrets are exposed in Flutter.
15. Code does not include future features early.

Give:
- Completed items
- Missing items
- Critical bugs
- Security concerns
- Quality concerns
- Next recommended step
```

---

## 36. Sprint 1 Prompt Usage Order

Use the prompts in this order:

1. Prompt 1: Create Project Structure
2. Prompt 2: Create Flutter App
3. Prompt 3: Add Flutter Packages
4. Prompt 4: Create Sprint 1 SQL Migration
5. Prompt 5: Review SQL Migration for Security
6. Prompt 6: Create Edge Functions Folder and Shared Helpers
7. Prompt 7: Build create-user-profile Function
8. Prompt 8: Build create-album Function
9. Prompt 9: Build Google Drive Connection Test Function
10. Prompt 13: Build Flutter Environment and Supabase Initialization
11. Prompt 14: Build App Theme and Basic Routes
12. Prompt 15: Build Flutter Auth Feature
13. Prompt 16: Build Edge Function Service in Flutter
14. Prompt 17: Build Album Feature
15. Prompt 10: Build create-upload-session Function
16. Prompt 11: Build complete-upload Function
17. Prompt 12: Build get-download-access Function
18. Prompt 18: Build File Selection and Upload Metadata
19. Prompt 19: Build Upload Repository and Upload Progress
20. Prompt 20: Build Album File List
21. Prompt 21: Build Download Original Feature
22. Prompt 22: Build Quality Test Logging
23. Prompt 23: Test Sprint 1 Core Flow
24. Prompt 24: Test Original Quality
25. Prompt 25: Test RLS and Permissions
26. Prompt 28: Review Code Against Potoos Rules
27. Prompt 33: Sprint 1 Final Review

Use debug prompts only when needed:

* Prompt 26: Debug Upload Problems
* Prompt 27: Debug Download Problems

Use commit prompts after each stable section:

* Prompt 29
* Prompt 30
* Prompt 31
* Prompt 32

---

## 37. Final Reminder

Do not build the full app immediately.

Sprint 1 has one main question:

**Can Potoos privately upload and download original-quality files?**

Everything else comes after that.

If Sprint 1 passes, continue to Sprint 2:

**Album MVP and Multiple Uploads.**
