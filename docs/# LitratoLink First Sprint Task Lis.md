# LitratoLink First Sprint Task List v1.0

## 1. Document Purpose

This document explains the first sprint tasks for LitratoLink.

This document is based on:

* LitratoLink Master Product Plan v1.0
* LitratoLink System Architecture Document v1.0
* LitratoLink Database Design Document v1.0
* LitratoLink UI/UX Flow Document v1.0
* LitratoLink Development Roadmap v1.0
* LitratoLink Codex Development Instructions v1.0
* LitratoLink API and Edge Functions Specification v1.0
* LitratoLink Supabase SQL and RLS Planning Document v1.0
* LitratoLink Implementation Starter Pack v1.0
* LitratoLink Google Drive API Proof Plan v1.0

The goal of this sprint is to start development in the correct order.

This sprint should focus only on the first proof of concept.

---

## 2. First Sprint Name

**Sprint 1: Core Original Quality Proof**

---

## 3. Sprint Goal

The goal of Sprint 1 is to prove that LitratoLink can:

1. Log in with Google.
2. Create a private album.
3. Upload one original photo.
4. Store the file in Google Drive-backed storage.
5. Save file metadata in Supabase.
6. Show the uploaded file in the album.
7. Download the original file.
8. Confirm that the downloaded file keeps original quality.

This sprint is not for the full app.

This sprint is only to prove the core idea.

---

## 4. Main Sprint Rule

Do not build extra features during Sprint 1.

Do not build yet:

* Invites
* Save All
* Notifications
* Soft delete
* Restore
* Members management
* Full UI polish
* Payment
* Social features
* Photographer mode
* Business mode

Only build the core proof.

---

## 5. Sprint Success Criteria

Sprint 1 is successful if:

* Flutter project runs.
* Supabase connects.
* Google Login works.
* User profile is created.
* User can create an album.
* Album creator becomes Admin.
* User can upload one original photo.
* File is stored in Google Drive-backed storage.
* File metadata is saved in Supabase.
* User can download the original photo.
* Downloaded photo matches the original quality.
* No private secrets are exposed in Flutter.

---

# PART A: PROJECT SETUP TASKS

---

## 6. Task 1: Create Project Folder

### Goal

Create the main project folder.

### Folder Name

`litratolink`

### Folder Structure

Create:

```text
litratolink/
  app/
  supabase/
  docs/
  assets/
  README.md
```

### Done When

* Project folder exists.
* Main subfolders exist.
* README file exists.

---

## 7. Task 2: Create Git Repository

### Goal

Set up version control.

### Steps

1. Create GitHub repository.
2. Name it `litratolink`.
3. Initialize Git locally.
4. Add `.gitignore`.
5. Commit the first project structure.
6. Push to GitHub.

### First Commit Message

```text
Initial project setup for LitratoLink
```

### Done When

* Git repository exists.
* Project is pushed to GitHub.
* `.gitignore` is added.

---

## 8. Task 3: Add Documentation Folder

### Goal

Prepare a place for all planning documents.

### Folder

`docs/`

### Recommended Files

```text
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
```

### Done When

* `docs/` folder exists.
* Planning documents are ready to be added.

---

# PART B: FLUTTER SETUP TASKS

---

## 9. Task 4: Create Flutter App

### Goal

Create the Flutter app inside the `app/` folder.

### Command

```bash
flutter create app
```

### Then Run

```bash
cd app
flutter doctor
```

### Done When

* Flutter app is created.
* App runs on at least one device or emulator.
* `flutter doctor` issues are reviewed.

---

## 10. Task 5: Set Up Flutter Folder Structure

### Goal

Organize the Flutter project early.

### Create This Structure

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
    utils/
    widgets/
    services/

  features/
    auth/
      data/
      models/
      screens/
      services/
      widgets/

    albums/
      data/
      models/
      screens/
      services/
      widgets/

    uploads/
      data/
      models/
      screens/
      services/
      widgets/

    downloads/
      data/
      models/
      screens/
      services/
      widgets/
```

### Important Rule

Do not put all logic inside `main.dart`.

### Done When

* Folder structure is created.
* App still runs after restructuring.

---

## 11. Task 6: Add Basic App Theme

### Goal

Add a simple LitratoLink theme.

### Temporary Theme Direction

Use:

* Deep maroon
* Warm cream
* Soft gold
* Off white
* Dark text

### Done When

* App has a simple theme.
* Theme is placed in `app/theme.dart`.
* Colors can be changed later when final logo is ready.

---

## 12. Task 7: Add Basic Routing

### Goal

Prepare navigation between screens.

### Screens for Sprint 1

Create simple screens:

1. Splash Screen
2. Login Screen
3. Home Screen
4. Create Album Screen
5. Album Details Screen
6. Upload Screen
7. File Preview Screen

### Done When

* App can navigate between the basic screens.
* Routes are clean and not hard-coded everywhere.

---

## 13. Task 8: Add Required Flutter Packages

### Goal

Install the first set of packages.

### Suggested Packages

Check latest versions before installing.

Possible packages:

```text
supabase_flutter
flutter_riverpod
flutter_dotenv
file_picker
dio
path_provider
path
permission_handler
```

### Do Not Add Yet

Do not add notification packages yet unless needed.

Not needed for Sprint 1:

```text
firebase_messaging
flutter_local_notifications
```

### Done When

* Packages are installed.
* App still builds.
* No unused complex setup is added.

---

# PART C: SUPABASE SETUP TASKS

---

## 14. Task 9: Create Supabase Project

### Goal

Create the development Supabase project.

### Project Name

`litratolink-dev`

### Done When

* Supabase project exists.
* Supabase URL is available.
* Supabase anon key is available.
* Supabase service role key is available but kept private.

---

## 15. Task 10: Configure Supabase Environment

### Goal

Connect Flutter to Supabase.

### Flutter `.env`

Create:

```text
APP_ENV=development
SUPABASE_URL=
SUPABASE_ANON_KEY=
```

### Important Rule

Do not put service role key in Flutter.

### Done When

* Flutter can initialize Supabase.
* App can connect to Supabase.

---

## 16. Task 11: Set Up Google Login in Supabase

### Goal

Enable Google Login.

### Steps

1. Set up Google OAuth credentials.
2. Add client ID and secret to Supabase Auth provider settings.
3. Add required redirect URLs.
4. Test Google Login from Flutter.

### Done When

* User can tap **Continue with Google**.
* Google login opens.
* Supabase session is created after login.

---

## 17. Task 12: Create Minimum Sprint 1 Tables

### Goal

Create only the tables needed for Sprint 1.

### Required Tables

1. `user_profiles`
2. `storage_providers`
3. `albums`
4. `album_members`
5. `storage_objects`
6. `media_files`

### Do Not Create Yet Unless Needed

* `album_invites`
* `media_thumbnails`
* `device_tokens`
* `notifications`
* `activity_logs`
* monetization tables

These can be added later.

### Done When

* Required tables exist.
* Basic relationships are created.
* Tables are ready for testing.

---

## 18. Task 13: Seed Storage Provider

### Goal

Create the default storage provider.

### Seed Data

Name:

```text
Google Drive Main
```

Type:

```text
google_drive
```

### Done When

* `storage_providers` has one active Google Drive provider.
* Albums or files can reference it.

---

## 19. Task 14: Add Basic RLS Policies

### Goal

Protect Sprint 1 data.

### Minimum RLS Rules

For Sprint 1:

* Users can read their own profile.
* Users can create their own profile.
* Users can read albums where they are active members.
* Users can create albums where they are the owner.
* Users can read album members only if they are part of the album.
* Users can read media files only if they are album members.
* Users can create media files only if they are Admin or Contributor.
* Non-members cannot read private album data.

### Done When

* RLS is enabled.
* Basic policies are active.
* Non-member access is blocked.

---

# PART D: GOOGLE DRIVE API SETUP TASKS

---

## 20. Task 15: Create Google Cloud Project

### Goal

Create Google Cloud project for LitratoLink.

### Project Name

`LitratoLink`

### Done When

* Google Cloud project exists.
* Project is selected and active.

---

## 21. Task 16: Enable Google Drive API

### Goal

Allow backend to use Google Drive API.

### Steps

1. Go to Google Cloud Console.
2. Open APIs and Services.
3. Enable Google Drive API.

### Done When

* Google Drive API is enabled.

---

## 22. Task 17: Prepare Google OAuth / API Credentials

### Goal

Prepare credentials for backend Google Drive access.

### Needed

* OAuth client ID
* OAuth client secret
* Refresh token or backend-safe credential method
* Drive folder ID

### Important Rule

Credentials must stay in backend only.

Do not place these in Flutter.

### Done When

* Backend can authenticate with Google Drive API.
* Credentials are stored securely in Supabase Edge Function environment variables.

---

## 23. Task 18: Create Google Drive Root Folder

### Goal

Create root folder for LitratoLink storage.

### Folder Name

```text
LitratoLink Storage
```

### Inside It

Create:

```text
development/
  albums/
```

### Done When

* Root folder exists.
* Folder ID is saved for backend config.
* Folder is accessible by the managed storage account.

---

# PART E: EDGE FUNCTION TASKS

---

## 24. Task 19: Set Up Supabase Edge Functions

### Goal

Prepare Edge Function development.

### Needed Functions for Sprint 1

1. `create-user-profile`
2. `create-album`
3. `test-google-drive-connection`
4. `create-upload-session`
5. `complete-upload`
6. `get-download-access`

### Done When

* Supabase Edge Functions can be created.
* Local or deployed function testing works.

---

## 25. Task 20: Add Backend Environment Variables

### Goal

Store private backend config.

### Environment Variables

```text
SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=
GOOGLE_DRIVE_CLIENT_ID=
GOOGLE_DRIVE_CLIENT_SECRET=
GOOGLE_DRIVE_REFRESH_TOKEN=
GOOGLE_DRIVE_ROOT_FOLDER_ID=
STORAGE_PROVIDER=google_drive
APP_ENV=development
```

### Important Rule

Never expose these in Flutter.

### Done When

* Edge Functions can access required variables.
* Variables are not committed to Git.

---

## 26. Task 21: Build `test-google-drive-connection`

### Goal

Confirm backend can connect to Google Drive.

### Function Should

1. Load Google credentials.
2. Connect to Google Drive API.
3. Check root folder exists.
4. Return success or failure.

### Success Response

```json
{
  "success": true,
  "data": {
    "connected": true,
    "root_folder_found": true
  }
}
```

### Done When

* Function returns success.
* Backend can access Google Drive folder.

---

## 27. Task 22: Build `create-user-profile`

### Goal

Create profile after Google Login.

### Function Should

1. Get logged-in user from Supabase Auth.
2. Get email.
3. Check if profile exists.
4. Create profile if missing.
5. Return profile.

### Done When

* User profile is created after first login.
* Existing profile is reused after next login.

---

## 28. Task 23: Build `create-album`

### Goal

Create a private album.

### Function Should

1. Check logged-in user.
2. Validate album name.
3. Create album.
4. Add creator to `album_members` as `admin`.
5. Return album data.

### Done When

* User can create album.
* Creator becomes Admin.
* Album appears in database.

---

## 29. Task 24: Build `create-upload-session`

### Goal

Prepare upload of one original photo.

### Function Should

1. Check user is logged in.
2. Check album exists.
3. Check user is Admin or Contributor.
4. Validate file metadata.
5. Create album folder if needed.
6. Create pending storage object.
7. Create pending media file record.
8. Create Google Drive upload session.
9. Return upload URL or upload instructions.

### Done When

* App receives upload session.
* Pending file record is created.
* Google Drive upload can begin.

---

## 30. Task 25: Build `complete-upload`

### Goal

Mark upload as complete.

### Function Should

1. Check user is logged in.
2. Check media file exists.
3. Check user is uploader.
4. Confirm Google Drive file exists if possible.
5. Save Google Drive file ID.
6. Mark media file as completed.
7. Return completed file data.

### Done When

* Upload status becomes `completed`.
* Storage object has provider file ID.
* Album can display uploaded file.

---

## 31. Task 26: Build `get-download-access`

### Goal

Allow member to download original file.

### Function Should

1. Check user is logged in.
2. Check media file exists.
3. Check file is completed.
4. Check file is not deleted.
5. Check user is active album member.
6. Return secure download access.

### Done When

* Logged-in album member can download file.
* Non-member cannot download file.
* Download uses original file.

---

# PART F: FLUTTER FEATURE TASKS

---

## 32. Task 27: Build Login Screen

### Goal

Allow user to log in with Google.

### Screen Content

Show:

* LitratoLink name
* Tagline
* Continue with Google button

### Done When

* User can log in.
* User can log out.
* Session persists after app restart.

---

## 33. Task 28: Build Home Screen

### Goal

Show user albums.

### For Sprint 1

Show:

* App title
* Create Album button
* List of albums

### Done When

* Logged-in user sees their albums.
* Empty state shows if no albums.

---

## 34. Task 29: Build Create Album Screen

### Goal

Allow user to create an album.

### Fields

* Album name
* Optional description

### Done When

* User can create album.
* App opens new album after creation.

---

## 35. Task 30: Build Album Details Screen

### Goal

Show album and uploaded files.

### For Sprint 1

Show:

* Album name
* User role
* Upload button
* File list or simple gallery

### Done When

* Album opens.
* Uploaded file appears after upload.

---

## 36. Task 31: Build Upload Screen

### Goal

Allow user to select one original photo.

### For Sprint 1

Only one photo is required.

### Important Rule

Picker must return original file if possible.

Do not compress or resize.

### Done When

* User can select one photo.
* App can show file name and file size.
* App can start upload.

---

## 37. Task 32: Build Upload Progress

### Goal

Show upload progress.

### Show

* Upload percentage
* Uploading status
* Upload success
* Upload failed

### Done When

* User can see upload progress.
* Upload failure is handled.

---

## 38. Task 33: Build File Preview Screen

### Goal

Show uploaded file.

### For Sprint 1

Show:

* Basic image preview
* File name
* File size
* Download Original button

### Done When

* User can open uploaded file.
* User can tap Download Original.

---

## 39. Task 34: Build Download Original

### Goal

Download the original uploaded file.

### Must

* Call `get-download-access`.
* Download original file.
* Save to device or temporary location.
* Show progress if possible.
* Show success or failure.

### Done When

* User can download original file.
* File can be compared with the original.

---

# PART G: QUALITY TEST TASKS

---

## 40. Task 35: Add Quality Test Logging

### Goal

Make it easier to compare original and downloaded file.

### Log or Show

Before upload:

* Original file name
* Original file size
* Original MIME type

After download:

* Downloaded file name
* Downloaded file size
* Downloaded MIME type

Optional:

* Width
* Height
* Checksum

### Done When

* Tester can compare original and downloaded file.

---

## 41. Task 36: Test One iPhone Photo

### Goal

Check original quality for iPhone photo.

### Steps

1. Select iPhone photo.
2. Upload it.
3. Download it.
4. Compare file size and resolution.

### Pass When

Downloaded photo matches original as much as possible.

---

## 42. Task 37: Test One Android Photo

### Goal

Check original quality for Android photo.

### Steps

1. Select Android photo.
2. Upload it.
3. Download it.
4. Compare file size and resolution.

### Pass When

Downloaded photo matches original as much as possible.

---

## 43. Task 38: Test One Video

### Goal

Check original quality for video.

### Steps

1. Select short video.
2. Upload it.
3. Download it.
4. Compare file size, resolution, and duration.

### Pass When

Downloaded video matches original as much as possible.

---

## 44. Task 39: Test Non-Member Access

### Goal

Confirm privacy works.

### Steps

1. User A creates album.
2. User A uploads file.
3. User B is not a member.
4. User B tries to access album or file.

### Pass When

User B is blocked.

---

# PART H: BUG FIXING TASKS

---

## 45. Task 40: Fix Login Issues

Fix if:

* Google Login fails.
* Session does not persist.
* User profile is not created.
* Logout does not work.

### Done When

Login flow is stable.

---

## 46. Task 41: Fix Upload Issues

Fix if:

* Upload does not start.
* Upload fails without clear error.
* Upload marks failed file as completed.
* File is compressed.
* File metadata is wrong.
* File does not appear in Google Drive.

### Done When

Upload is reliable for one photo.

---

## 47. Task 42: Fix Download Issues

Fix if:

* Download access fails.
* Download uses wrong file.
* Downloaded file is thumbnail.
* Downloaded file is compressed.
* Download progress is wrong.
* File cannot be saved.

### Done When

Download returns the original file.

---

## 48. Task 43: Fix RLS and Permission Issues

Fix if:

* Non-member can see album.
* Non-member can see file metadata.
* Viewer can upload.
* User can access another user’s data.
* Edge Function skips permission check.

### Done When

Backend blocks unauthorized access.

---

# PART I: SPRINT REVIEW

---

## 49. Sprint Review Checklist

At the end of Sprint 1, review:

* Does Google Login work?
* Does user profile creation work?
* Does album creation work?
* Does creator become Admin?
* Does Google Drive connection work?
* Does one photo upload successfully?
* Is file metadata saved?
* Does one photo download successfully?
* Does original quality remain?
* Are secrets safe?
* Is non-member access blocked?

---

## 50. Sprint 1 Pass or Fail Decision

### Pass

Sprint 1 passes if the original-quality proof works.

If Sprint 1 passes, continue to Sprint 2:

**Album MVP and Multiple Uploads**

---

### Partial Pass

Sprint 1 partially passes if:

* Login works.
* Album works.
* Upload works.
* But download or quality test has issues.

If partial pass:

Fix Google Drive upload/download before adding more features.

---

### Fail

Sprint 1 fails if:

* Google Drive upload is not possible.
* Original quality cannot be preserved.
* Backend credentials cannot be secured.
* Permission model is unsafe.

If fail:

Do not continue full app development yet.

Review storage plan.

---

# PART J: FIRST SPRINT CODEX PROMPT

---

## 51. Codex Prompt for Sprint 1

Use this prompt when starting Sprint 1 with Codex:

```text
You are helping me build LitratoLink.

LitratoLink is a private photo and video sharing app.

Main rule:
The app must upload, store, and download original-quality files. Do not compress, resize, convert, or replace original files. Thumbnails are allowed only later and must be separate.

Tech stack:
- Flutter frontend
- Supabase backend
- Supabase Auth with Google Login only
- Supabase Postgres
- Supabase Edge Functions
- Google Drive / Google One-backed storage for V1

Sprint 1 goal:
Build the Core Original Quality Proof only.

Sprint 1 must include:
1. Flutter project setup.
2. Clean folder structure.
3. Supabase connection.
4. Google Login.
5. User profile creation.
6. Create album.
7. Creator becomes Admin.
8. Google Drive connection test from backend.
9. Upload one original photo.
10. Save file metadata in Supabase.
11. Show uploaded file in album.
12. Download original photo.
13. Show or log original vs downloaded file size for quality check.
14. Block non-member access.

Do not build yet:
- Invites
- Save All
- Notifications
- Soft delete
- Restore
- Payments
- Likes
- Comments
- Followers
- Public feed
- Chat
- Photo editing

Important rules:
- Do not store Supabase service role key in Flutter.
- Do not store Google client secret in Flutter.
- Use environment variables.
- Keep storage logic in backend Edge Functions.
- Keep code simple and organized.
- Do not put everything in main.dart.
- Use user-friendly errors.
```

---

## 52. Final Sprint 1 Summary

Sprint 1 should prove the core idea of LitratoLink.

The core idea is not albums, not invites, not notifications, and not UI polish.

The core idea is:

**Can users share original-quality files privately through the app?**

If the answer is yes, continue building the full MVP.

If the answer is no, fix the storage and quality system before building anything else.

---

## 53. Next Recommended Document

The next recommended document is:

**LitratoLink Actual SQL Migration Draft v1.0**

This document should create the first real Supabase SQL migration for Sprint 1.

It should include:

* Sprint 1 enum creation
* Sprint 1 table creation
* Basic indexes
* Basic helper functions
* Basic RLS policies
* Seed storage provider
