# LitratoLink Flutter Project Structure Guide v1.1

## 1. Purpose

This guide explains the LitratoLink Flutter structure in a beginner-friendly way.

Use this document when you need to answer:

* Where should this file go?
* What does this folder do?
* Which screen should I build first?
* Where should backend calls live?
* Which files are only UI, and which files are logic?

The app UI should follow `litratolink_mobile_ui.html` as the source of truth.

Do not redesign the UI while implementing Flutter. Match the HTML mockup's:

* Layout
* Navigation
* Colors
* Component hierarchy
* User flow

Backend behavior should follow the Master Product Plan.

---

## 2. App Summary

**App Name:** LitratoLink
**Tagline:** Share Memories in Original Quality
**App Type:** Private cloud sharing app

LitratoLink allows users to:

* Log in with Google
* Create private albums
* Upload original-quality photos and videos
* Download original files
* Share albums with selected people later

For Sprint 1, the goal is only to prove:

**Upload one original photo and download the same original photo without quality loss.**

---

## 3. Main Flutter Rule

The Flutter app must not compress, resize, convert, or replace original files.

Original-quality rule:

* Pick the original file.
* Upload the original file.
* Download the original file.
* Never use thumbnail as final download.

This is the most important app rule.

---

## 4. Main Security Rule

The Flutter app must not contain private backend secrets.

Never put these in Flutter:

* Supabase service role key
* Google Drive client secret
* Google Drive refresh token
* Google service account key
* Push notification server key

Flutter can contain:

* Supabase URL
* Supabase anon key

Sensitive actions must go through Supabase Edge Functions.

---

# PART A: QUICK MAP

---

## 5. Root Project Structure

Recommended root folder:

```text
LitratoLink/
  app/
  supabase/
  docs/
  assets/
  README.md
```

What each folder means:

* `app/` is the mobile app users see.
* `supabase/` is the backend: database migrations and Edge Functions.
* `docs/` is the planning library.
* `assets/` is for shared brand files.
* `README.md` is the first file a new developer reads.

---

## 6. Flutter App Folder

Inside `app/`:

```text
app/
  android/
  ios/
  lib/
  assets/
  test/
  pubspec.yaml
  .env
  .gitignore
```

Important:

`.env` should not be committed to GitHub.

---

# PART B: LIB FOLDER STRUCTURE

---

## 7. Beginner-Friendly `lib/` Structure

Use this structure:

```text
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
        login_screen.dart
        splash_screen.dart
      widgets/
        google_login_button.dart

    albums/
      data/
        album_repository.dart
      models/
        album.dart
        album_member.dart
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
```

Simple meaning:

* `main.dart` starts the app only.
* `app/` controls app-wide setup like routes and theme.
* `config/` stores public configuration and repeated constants.
* `core/` stores shared code used by many features.
* `features/` stores one product area per folder.
* `screens/` are full pages.
* `widgets/` are smaller reusable UI parts.
* `models/` describe data shapes.
* `data/` talks to APIs, repositories, or services.
* `providers/` manages state.

Rule of thumb:

If a file belongs to only one feature, keep it inside that feature.
If many features use it, move it to `core/`.

---

## 8. Feature Build Order

Build in this order so the app stays easy to understand:

1. App shell: `main.dart`, theme, routes.
2. Shared UI components: buttons, cards, inputs, empty states.
3. Auth screens: splash and login.
4. Albums screens: home, create album, album details.
5. Upload screens: selection and progress.
6. Download screen: file preview and download original.
7. Backend connection: repositories, providers, services.
8. Later features: invites, notifications, trash, member management.

## 9. Future Feature Folders

Add these later, not during Sprint 1:

```text
features/
  invites/
  members/
  trash/
  notifications/
  settings/
```

Do not build these first.

Sprint 1 should focus only on:

* Auth
* Albums
* Uploads
* Downloads

Note:

The UI mockup may show future components such as Invite Form, Notification items, Save All, and Trash. They can exist as UI placeholders, but backend logic should wait for the planned sprint.

---

# PART B: MAIN APP FILES

---

## 10. `main.dart`

Purpose:

Starts the app.

Responsibilities:

* Load environment variables.
* Initialize Supabase.
* Start the Flutter app.
* Wrap app with Riverpod provider scope.

Rules:

* Keep `main.dart` short.
* Do not put screens inside `main.dart`.
* Do not put business logic inside `main.dart`.

---

## 11. `app/app.dart`

Purpose:

Main app widget.

Responsibilities:

* Set app title.
* Set theme.
* Set routes.
* Control global app setup.

App title:

**LitratoLink**

---

## 12. `app/routes.dart`

Purpose:

Stores app route names and route setup.

Sprint 1 route names:

```text
/
login
home
create-album
album-details
upload
file-preview
profile
```

Recommended route constants:

```text
splashRoute
loginRoute
homeRoute
createAlbumRoute
albumDetailsRoute
uploadRoute
filePreviewRoute
profileRoute
```

Rules:

* Do not hard-code route strings in many files.
* Keep route names in one place.

---

## 13. `app/theme.dart`

Purpose:

Stores app colors and theme.

Brand colors:

* Deep Maroon: `#4A1220`
* Maroon: `#6B1C2E`
* Soft Gold: `#C4973A`
* Warm Cream: `#FAF6F0`

Suggested color names:

```text
deepMaroon
maroon
warmCream
softGold
creamLine
darkText
```

Rules:

* Use one theme file.
* Do not hard-code colors everywhere.
* Use General Sans for display/headings.
* Use Inter for body text and UI labels.

Flutter implementation note:

Bundle the fonts under `app/assets/fonts/` and declare them in `pubspec.yaml`. General Sans is used for headings; Inter is used for body text and UI labels.

---

# PART C: UI SOURCE OF TRUTH

## 14. UI Matching Rule

`litratolink_mobile_ui.html` is the source of truth for Flutter UI.

When implementing a screen:

1. Open the matching section in the HTML.
2. Identify the layout blocks from top to bottom.
3. Recreate the same hierarchy in Flutter.
4. Use the same colors and typography.
5. Use the same navigation flow.
6. Only connect backend behavior after the UI shape is correct.

Do not:

* Invent a new layout.
* Change the palette.
* Replace the navigation model.
* Add extra marketing sections.
* Turn the app into a social feed.

## 15. Screens Found in the HTML Mockup

The current `docs/ui-reference/litratolink_mobile_ui.html` includes these UI screens:

1. Welcome
2. Home / My Albums
3. Album Details
4. Upload Progress
5. Save All
6. Members
7. Invite Member
8. Activity

Flutter should implement those screens first before adding backend-only screens.

## 16. Core UI Components

Create these as reusable widgets:

```text
core/widgets/
  app_button.dart
  app_card.dart
  app_empty_state.dart
  app_progress_bar.dart
  role_chip.dart
  save_all_ring.dart
  invite_form.dart
  notification_item.dart

features/albums/widgets/
  album_card.dart
  gallery_tile.dart

features/uploads/widgets/
  selected_file_card.dart
  upload_progress_card.dart
```

Component responsibilities:

* `AlbumCard` shows album cover, name, file count, member count, updated date, and role.
* `GalleryTile` shows one photo/video preview in the album grid.
* `RoleChip` shows Admin, Contributor, or Viewer.
* `AppProgressBar` shows upload/download/save progress.
* `SaveAllRing` shows circular Save All progress.
* `InviteForm` shows email input and role selection.
* `NotificationItem` shows one app notification.

## 17. Screen Map

```text
Splash
  -> Login
    -> Home
      -> Create Album
      -> Album Details
        -> Upload
          -> Upload Progress
        -> File Preview
```

Bottom navigation:

```text
Albums | Invites | Alerts | Profile
```

For Sprint 1, Albums is the main working tab. Invites, Alerts, and Profile can be UI-only until backend work begins.

---

# PART D: CONFIG FILES

---

## 13. `config/env.dart`

Purpose:

Loads environment values.

Needed values:

```text
APP_ENV
SUPABASE_URL
SUPABASE_ANON_KEY
```

Rules:

* Only public frontend-safe values.
* Do not place service role key here.
* Do not place Google secrets here.

---

## 14. `config/constants.dart`

Purpose:

Stores app constants.

Examples:

```text
appName = LitratoLink
appTagline = Share Memories in Original Quality
defaultUploadLimit = none
```

Rules:

* Keep repeated strings here if used many times.
* Do not store secrets here.

---

# PART E: CORE FOLDER

---

## 15. `core/errors/`

Purpose:

Central place for app errors.

Files:

```text
app_error.dart
error_mapper.dart
```

Use this for user-friendly errors.

Examples:

* No internet connection.
* Upload failed.
* Download failed.
* You do not have permission to do this.
* This album is no longer available.

Do not show raw backend errors directly to users.

---

## 16. `core/services/supabase_service.dart`

Purpose:

Creates and provides the Supabase client.

Responsibilities:

* Initialize Supabase client.
* Provide client access to repositories.

Rules:

* Use Supabase anon key only.
* Never use service role key in Flutter.

---

## 17. `core/services/edge_function_service.dart`

Purpose:

Handles calls to Supabase Edge Functions.

Functions to support in Sprint 1:

* `create-user-profile`
* `create-album`
* `test-google-drive-connection`
* `create-upload-session`
* `complete-upload`
* `get-download-access`

Responsibilities:

* Send authenticated requests.
* Attach auth token.
* Parse success response.
* Parse error response.
* Return clean app data.

---

## 18. `core/services/file_service.dart`

Purpose:

Handles local file operations.

Responsibilities:

* Read file metadata.
* Get file size.
* Get MIME type if possible.
* Save downloaded file.
* Prepare file for upload.
* Compare file details for quality testing.

Important:

This service must not compress or resize files.

---

## 19. `core/utils/file_utils.dart`

Purpose:

Helper functions for files.

Examples:

* Format file size.
* Get file extension.
* Detect file type.
* Validate photo or video.
* Compare original and downloaded file info.

---

## 20. `core/utils/format_utils.dart`

Purpose:

Formatting helper.

Examples:

* Format date.
* Format file size.
* Format upload progress.

---

## 21. `core/widgets/`

Purpose:

Reusable UI widgets.

Recommended widgets:

```text
app_button.dart
app_text_field.dart
app_loading.dart
app_empty_state.dart
app_error_state.dart
```

Rules:

* Keep UI consistent.
* Avoid repeating same button design everywhere.

---

# PART F: AUTH FEATURE

---

## 22. Auth Feature Purpose

The auth feature handles:

* Splash screen
* Login screen
* Google Login
* Logout
* Current user session
* User profile creation

---

## 23. Auth Files

```text
features/auth/
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
```

---

## 24. `user_profile.dart`

Purpose:

Represents the logged-in user profile.

Fields:

```text
id
email
displayName
avatarUrl
createdAt
isActive
isBanned
```

---

## 25. `auth_repository.dart`

Purpose:

Handles auth-related data actions.

Responsibilities:

* Sign in with Google.
* Sign out.
* Get current user.
* Call `create-user-profile`.
* Return user profile.

---

## 26. `auth_provider.dart`

Purpose:

Manages auth state.

States:

```text
loading
loggedOut
loggedIn
error
```

Responsibilities:

* Check session on app start.
* Login user.
* Logout user.
* Store current user profile.

---

## 27. `splash_screen.dart`

Purpose:

First screen when app opens.

Behavior:

* Show logo or app name.
* Check if user is logged in.
* If logged in, go to Home.
* If not logged in, go to Login.

---

## 28. `login_screen.dart`

Purpose:

Allows user to log in.

Content:

```text
LitratoLink
Share Memories in Original Quality
Continue with Google
```

Rules:

* Google Login only in V1.
* Do not add Apple Login yet.
* Do not add Email Login yet.

---

# PART G: ALBUMS FEATURE

---

## 29. Albums Feature Purpose

The albums feature handles:

* Home screen
* My albums list
* Create album
* Album details
* Basic album data

---

## 30. Album Files

```text
features/albums/
  data/
    album_repository.dart

  models/
    album.dart
    album_member.dart

  providers/
    album_provider.dart

  screens/
    home_screen.dart
    create_album_screen.dart
    album_details_screen.dart

  widgets/
    album_card.dart
    album_empty_state.dart
```

---

## 31. `album.dart`

Purpose:

Represents an album.

Fields:

```text
id
ownerId
name
description
storageProviderId
createdAt
updatedAt
isDeleted
isArchived
userRole
fileCount
memberCount
```

For Sprint 1, not all fields are required in UI.

Minimum fields:

```text
id
name
description
userRole
createdAt
```

---

## 32. `album_member.dart`

Purpose:

Represents a member of an album.

Fields:

```text
id
albumId
userId
role
joinedAt
isActive
```

Roles:

```text
admin
contributor
viewer
```

---

## 33. `album_repository.dart`

Purpose:

Handles album data actions.

Responsibilities:

* Get my albums.
* Create album through Edge Function.
* Get album details.
* Get album files later.

Sprint 1 required methods:

```text
getMyAlbums()
createAlbum(name, description)
getAlbumById(albumId)
```

---

## 34. `album_provider.dart`

Purpose:

Manages album state.

States:

```text
loading
loaded
empty
error
```

Responsibilities:

* Load my albums.
* Create album.
* Refresh album list.
* Load album details.

---

## 35. `home_screen.dart`

Purpose:

Shows the user’s albums.

Content:

* App name
* Create Album button
* Album list
* Empty state

Empty state:

```text
No albums yet
Create your first private album and start sharing original-quality memories.
```

---

## 36. `create_album_screen.dart`

Purpose:

Allows user to create album.

Fields:

* Album name
* Description optional

Button:

```text
Create Album
```

Rules:

* Album name is required.
* Album name should be 1 to 100 characters.
* Creator becomes Admin through backend.

---

## 37. `album_details_screen.dart`

Purpose:

Shows album contents.

Sprint 1 content:

* Album name
* User role
* Upload button
* Uploaded file list
* File preview access

Rules:

* Upload button visible only if Admin or Contributor.
* For Sprint 1, creator is Admin.
* Gallery can be simple first.

---

# PART H: UPLOADS FEATURE

---

## 38. Uploads Feature Purpose

The uploads feature handles:

* Selecting files
* Reading original file metadata
* Creating upload session
* Uploading original file
* Completing upload
* Upload progress

---

## 39. Upload Files

```text
features/uploads/
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
```

---

## 40. `upload_file.dart`

Purpose:

Represents a file selected for upload.

Fields:

```text
localPath
originalFilename
mimeType
fileSizeBytes
fileType
width
height
durationSeconds
```

Sprint 1 minimum fields:

```text
localPath
originalFilename
mimeType
fileSizeBytes
fileType
```

---

## 41. `upload_session.dart`

Purpose:

Represents backend upload session.

Fields:

```text
mediaFileId
storageObjectId
uploadUrl
uploadMethod
requiredHeaders
```

---

## 42. `upload_repository.dart`

Purpose:

Handles upload actions.

Responsibilities:

1. Pick original file.
2. Read metadata.
3. Call `create-upload-session`.
4. Upload original file bytes to upload URL.
5. Read Google Drive final upload response.
6. Call `complete-upload`.
7. Return completed media file.

Important:

Upload repository must not compress or resize the file.

---

## 43. `upload_provider.dart`

Purpose:

Manages upload state.

States:

```text
idle
selected
uploading
success
failed
```

State data:

```text
selectedFile
progressPercent
errorMessage
completedMediaFile
```

---

## 44. `upload_screen.dart`

Purpose:

Allows user to select one file for Sprint 1.

Content:

* Select Photo button
* File name
* File size
* MIME type
* Upload Original File button

Message:

```text
Files will be uploaded in original quality.
```

Sprint 1:

* One photo upload is enough.
* Video can be tested after photo works.

---

## 45. `upload_progress_screen.dart`

Purpose:

Shows upload progress.

Content:

```text
Uploading...
45%
```

Success:

```text
Upload complete.
```

Failure:

```text
Upload failed. Please try again.
```

---

# PART I: DOWNLOADS FEATURE

---

## 46. Downloads Feature Purpose

The downloads feature handles:

* File preview
* Download access request
* Download original file
* Save downloaded file
* Quality test logging

---

## 47. Download Files

```text
features/downloads/
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
```

---

## 48. `download_access.dart`

Purpose:

Represents backend download access.

Fields:

```text
mediaFileId
downloadUrl
accessToken
proxyDownloadUrl
originalFilename
mimeType
fileSizeBytes
```

Sprint 1 can use:

```text
mediaFileId
downloadUrl
accessToken
originalFilename
mimeType
fileSizeBytes
```

or proxy download if implemented.

---

## 49. `download_repository.dart`

Purpose:

Handles download actions.

Responsibilities:

1. Call `get-download-access`.
2. Download original file.
3. Save file locally.
4. Track progress.
5. Return downloaded file info.

Important:

Download repository must download original file only.

It must never download thumbnail as final file.

---

## 50. `download_provider.dart`

Purpose:

Manages download state.

States:

```text
idle
downloading
success
failed
```

State data:

```text
progressPercent
downloadedFilePath
errorMessage
```

---

## 51. `file_preview_screen.dart`

Purpose:

Shows uploaded file and allows download.

Sprint 1 content:

* File preview if possible
* File name
* File size
* MIME type
* Download Original button

Button:

```text
Download Original
```

---

# PART J: MODELS FOR SPRINT 1

---

## 52. Required Models

Sprint 1 models:

```text
UserProfile
Album
AlbumMember
UploadFile
UploadSession
MediaFile
StorageObject
DownloadAccess
```

---

## 53. `media_file.dart`

Recommended location:

```text
features/albums/models/media_file.dart
```

Fields:

```text
id
albumId
uploaderId
storageObjectId
originalFilename
fileType
mimeType
fileSizeBytes
uploadStatus
uploadedAt
isDeleted
```

---

## 54. `storage_object.dart`

Recommended location:

```text
features/uploads/models/storage_object.dart
```

Fields:

```text
id
providerId
providerFileId
providerFolderId
storagePath
fileSizeBytes
mimeType
checksum
```

Flutter may not need to use this model often.

Most storage work should happen through Edge Functions.

---

# PART K: RIVERPOD PROVIDERS

---

## 55. Provider Strategy

Use Riverpod for state management.

Recommended provider types:

* `Provider` for services
* `FutureProvider` for async loading
* `StateNotifierProvider` or `AsyncNotifierProvider` for feature state

Keep it simple during Sprint 1.

---

## 56. Core Providers

Create providers for:

```text
supabaseClientProvider
edgeFunctionServiceProvider
fileServiceProvider
```

---

## 57. Auth Providers

Create:

```text
authRepositoryProvider
authStateProvider
currentUserProvider
```

Purpose:

* Know if user is logged in.
* Get current user profile.
* Log in and log out.

---

## 58. Album Providers

Create:

```text
albumRepositoryProvider
myAlbumsProvider
albumDetailsProvider
```

Purpose:

* Load user albums.
* Create album.
* Load album details.

---

## 59. Upload Providers

Create:

```text
uploadRepositoryProvider
uploadStateProvider
```

Purpose:

* Select file.
* Upload file.
* Track upload progress.

---

## 60. Download Providers

Create:

```text
downloadRepositoryProvider
downloadStateProvider
```

Purpose:

* Download original file.
* Track download progress.

---

# PART L: EDGE FUNCTION CALLING RULES

---

## 61. Edge Function Service

All Edge Function calls should go through one service:

```text
edge_function_service.dart
```

Responsibilities:

* Get current access token.
* Send request to Edge Function.
* Parse response.
* Throw app-friendly errors.

---

## 62. Edge Function Response Format

Expected success response:

```json
{
  "success": true,
  "data": {}
}
```

Expected error response:

```json
{
  "success": false,
  "error_code": "FORBIDDEN",
  "message": "You do not have permission to do this."
}
```

Flutter should show:

```text
message
```

not raw technical error.

---

## 63. Sprint 1 Edge Functions to Call

Flutter should call:

```text
create-user-profile
create-album
create-upload-session
complete-upload
get-download-access
```

Optional development test:

```text
test-google-drive-connection
```

---

# PART M: ROUTING FLOW

---

## 64. Sprint 1 Route Flow

```text
Splash
 ↓
Login
 ↓
Home / My Albums
 ↓
Create Album
 ↓
Album Details
 ↓
Upload
 ↓
File Preview
 ↓
Download Original
```

---

## 65. Splash Logic

If user has active session:

```text
Go to Home
```

If no session:

```text
Go to Login
```

---

## 66. Login Logic

After successful Google Login:

1. Call `create-user-profile`.
2. Go to Home.

---

## 67. Create Album Logic

After album is created:

1. Return album ID.
2. Go to Album Details.

---

## 68. Upload Logic

After upload is complete:

1. Return to Album Details.
2. Refresh file list.
3. Show uploaded file.

---

## 69. Download Logic

After download is complete:

1. Show success message.
2. Show saved file path if useful.
3. Log quality comparison info if enabled.

---

# PART N: SPRINT 1 SCREENS

---

## 70. Sprint 1 Screen Priority

Build screens in this order:

1. Splash Screen
2. Login Screen
3. Home Screen
4. Create Album Screen
5. Album Details Screen
6. Upload Screen
7. File Preview Screen

---

## 71. Splash Screen Minimum UI

Show:

```text
LitratoLink
Share Memories in Original Quality
```

Loading indicator.

---

## 72. Login Screen Minimum UI

Show:

```text
LitratoLink
Share Memories in Original Quality
[Continue with Google]
```

---

## 73. Home Screen Minimum UI

Show:

```text
Your Albums
[Create Album]
Album list
```

Empty state:

```text
No albums yet.
Create your first private album.
```

---

## 74. Create Album Screen Minimum UI

Show:

```text
Create Album
Album Name
Description
[Create Album]
```

---

## 75. Album Details Screen Minimum UI

Show:

```text
Album Name
Your role: Admin
[Upload]
File list
```

---

## 76. Upload Screen Minimum UI

Show:

```text
Upload Original File
[Select Photo]
Selected file name
Selected file size
[Upload Original File]
```

---

## 77. File Preview Screen Minimum UI

Show:

```text
File preview
Filename
File size
MIME type
[Download Original]
```

---

# PART O: QUALITY TESTING IN FLUTTER

---

## 78. Quality Test Logging

During Sprint 1, show or log:

Before upload:

```text
Original filename
Original size
Original MIME type
Original path
```

After download:

```text
Downloaded filename
Downloaded size
Downloaded MIME type
Downloaded path
```

Optional later:

```text
Image width
Image height
Video duration
SHA-256 checksum
```

---

## 79. Quality Test Rule

If downloaded file size is different from original file size, investigate.

Possible causes:

* Picker returned compressed file.
* Upload used wrong file.
* Download used thumbnail.
* File was converted.
* Partial download happened.
* Metadata mismatch.

---

# PART P: ERROR HANDLING

---

## 80. Common Error Messages

Use simple messages.

### Login Failed

```text
Login failed. Please try again.
```

### No Internet

```text
No internet connection. Please check your connection and try again.
```

### Album Create Failed

```text
Album could not be created. Please try again.
```

### Upload Failed

```text
Upload failed. Please try again.
```

### Download Failed

```text
Download failed. Please try again.
```

### Permission Denied

```text
You do not have permission to do this.
```

### File Not Found

```text
This file is no longer available.
```

---

## 81. Error Handling Rule

Do not show raw errors like:

```text
Postgres error 23503
DioException 403
Invalid JWT
```

Map them to friendly messages.

---

# PART Q: PLATFORM NOTES

---

## 82. Android Notes

Sprint 1 should run on Android first if easier.

Test:

* Google Login
* File picker
* Upload original photo
* Download original photo
* Save to device

---

## 83. iOS Notes

Test on iPhone early if possible.

iOS permissions to prepare:

* Photo access
* Save to Photos
* Files access if needed

Do not wait until the app is finished before testing iOS.

---

## 84. Web / PC Notes

PC/Web is useful for upload later.

For Sprint 1, it is okay if mobile works first.

But the project should not block web/PC support later.

---

# PART R: CODING RULES

---

## 85. General Coding Rules

Codex or developer must follow:

1. Keep code simple.
2. Use clear file names.
3. Use clear class names.
4. Keep features separated.
5. Do not put all code in one file.
6. Do not duplicate logic.
7. Use repositories for data access.
8. Use services for shared logic.
9. Use providers for app state.
10. Use widgets for repeated UI.

---

## 86. Security Coding Rules

1. Never store secrets in Flutter.
2. Never expose Google credentials.
3. Never expose service role key.
4. Always call backend for protected actions.
5. Do not rely only on hidden buttons.
6. Always handle permission errors.

---

## 87. Original Quality Coding Rules

1. Do not compress original files.
2. Do not resize original files.
3. Do not convert original files.
4. Do not upload thumbnails as originals.
5. Do not download thumbnails as originals.
6. Always use original file path.
7. Always compare quality during testing.

---

## 88. UI Coding Rules

1. Keep UI clean.
2. Use maroon-based theme.
3. Use simple English.
4. Show clear loading states.
5. Show clear error states.
6. Show empty states.
7. Avoid clutter.
8. Do not make it look like social media.

---

# PART S: WHAT NOT TO BUILD IN SPRINT 1

---

## 89. Do Not Build Yet

Do not build:

* Invites
* Save All
* Soft delete
* Restore
* Notifications
* Member management
* Apple Login
* Email Login
* Payment
* Premium plans
* Likes
* Comments
* Followers
* Public feed
* Chat
* Photo editing
* AI tools

These are for later phases.

---

## 90. Why Not Build Them Yet

Because Sprint 1 must answer the most important technical question:

**Can LitratoLink upload and download original-quality files privately?**

If this does not work, other features do not matter yet.

---

# PART T: SPRINT 1 DONE CHECKLIST

---

## 91. Flutter Structure Done

Checklist:

* App folder exists.
* `lib/` is organized.
* Theme exists.
* Routes exist.
* Core services exist.
* Feature folders exist.
* App runs.

---

## 92. Auth Done

Checklist:

* Google Login works.
* Profile creation works.
* Session persists.
* Logout works.

---

## 93. Albums Done

Checklist:

* Home screen shows albums.
* User can create album.
* Creator becomes Admin.
* Album details screen opens.

---

## 94. Upload Done

Checklist:

* User can select one photo.
* App reads file metadata.
* App calls create upload session.
* App uploads original file.
* App completes upload.
* File appears in album.

---

## 95. Download Done

Checklist:

* User can open uploaded file.
* User can request download access.
* App downloads original file.
* App saves file.
* App shows download success.

---

## 96. Quality Test Done

Checklist:

* Original file size recorded.
* Downloaded file size recorded.
* Original MIME type recorded.
* Downloaded MIME type recorded.
* Quality appears unchanged.
* Any mismatch is investigated.

---

## 97. Security Done

Checklist:

* No service role key in Flutter.
* No Google secret in Flutter.
* Non-member access is blocked.
* Upload requires Admin or Contributor.
* Download requires album membership.

---

## 98. Final Project Structure Summary

Sprint 1 should end with a clean Flutter app structure that supports:

* Auth
* Albums
* Uploads
* Downloads

The app does not need full UI polish yet.

The app must prove original-quality upload and download.

---

## 99. Next Recommended Document

The next recommended document is:

**LitratoLink Sprint 1 Build Prompt Pack v1.0**

This document should contain ready-to-copy prompts for Codex.

It should include:

* Project setup prompt
* Supabase setup prompt
* Edge Functions prompt
* Flutter auth prompt
* Flutter albums prompt
* Upload proof prompt
* Download proof prompt
* Testing prompt
