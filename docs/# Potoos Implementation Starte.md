# Potoos Implementation Starter Pack v1.0

## 1. Document Purpose

This document prepares Potoos for actual development.

This document is based on all previous Potoos planning documents.

The goal of this document is to help start coding the project in the correct order.

This document includes:

* Required accounts
* Required tools
* Project setup checklist
* Flutter setup checklist
* Supabase setup checklist
* Google Cloud setup checklist
* Google Drive API setup checklist
* iOS setup checklist
* Android setup checklist
* Environment variables
* Flutter packages to consider
* Supabase Edge Functions setup
* First proof of concept
* First Codex prompt
* Development milestone checklist

---

## 2. Project Summary

**App Name:** Potoos
**Tagline:** Share Memories in Original Quality
**App Type:** Private cloud sharing app

Potoos allows users to:

* Log in with Google
* Create private albums
* Invite selected people
* Upload original-quality photos and videos
* Download original files
* Use Save All
* Delete and restore their own uploaded files

Potoos is not social media.

V1 must not include:

* Likes
* Comments
* Followers
* Public feed
* Public albums
* Chat
* Payment system
* Photographer mode
* Business mode

---

## 3. Main Development Goal

The first development goal is not to build the full app immediately.

The first goal is to prove the main feature:

**Upload one original photo and download the same original photo without quality loss.**

The first working proof must include:

1. Google Login
2. Create album
3. Upload one original photo
4. Store file metadata
5. Download original photo
6. Compare original and downloaded file

If this works, the full app can be built step by step.

---

# PART A: REQUIRED ACCOUNTS

---

## 4. Accounts Needed

### 4.1 Google Account

Needed for:

* Google Login testing
* Google Cloud Console
* Google Drive API
* Google storage setup

### 4.2 Supabase Account

Needed for:

* Backend
* Database
* Auth
* Edge Functions
* RLS policies

### 4.3 Apple Developer Account

Needed later for:

* iOS device testing
* TestFlight
* App Store release

This is not required for the first local Flutter setup, but it will be needed before TestFlight.

### 4.4 Firebase Account or Google Cloud Messaging Setup

Needed for:

* Push notifications using FCM/APNs path

This can be added after the core upload/download flow works.

### 4.5 GitHub Account

Needed for:

* Code backup
* Version control
* Codex workflow
* Collaboration later

---

# PART B: REQUIRED TOOLS

---

## 5. Development Tools Needed

Install these tools before starting:

### 5.1 Flutter SDK

Used to build the app.

### 5.2 Dart SDK

Usually included with Flutter.

### 5.3 VS Code or Android Studio

Recommended editor:

* VS Code

Useful extensions:

* Flutter
* Dart
* GitLens
* Supabase snippets if available

### 5.4 Android Studio

Needed for:

* Android emulator
* Android SDK
* Android build tools

### 5.5 Xcode

Needed for iOS development.

Required only on macOS.

Needed for:

* iPhone build
* iPad build
* TestFlight build

### 5.6 Git

Needed for version control.

### 5.7 Supabase CLI

Needed for:

* Supabase local development
* Edge Functions
* Database migrations

### 5.8 Node.js

May be needed for:

* Supabase CLI
* Edge Functions tooling
* Web tooling

### 5.9 Google Cloud CLI

Optional but useful for Google Cloud setup.

---

# PART C: PROJECT SETUP CHECKLIST

---

## 6. Create Project Folder

Recommended folder name:

`potoos`

Recommended structure:

```text
potoos/
  app/
  supabase/
  docs/
  assets/
  README.md
```

Explanation:

* `app/` = Flutter app
* `supabase/` = Supabase functions and migrations
* `docs/` = project documents
* `assets/` = logo, icons, images
* `README.md` = project overview

---

## 7. Create Git Repository

Steps:

1. Create GitHub repository.
2. Name it `potoos`.
3. Initialize Git locally.
4. Add `.gitignore`.
5. Push initial commit.

Recommended first commit message:

`Initial project setup for Potoos`

---

## 8. Create Documentation Folder

Inside `docs/`, add all planning documents later.

Recommended files:

```text
docs/
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
```

This keeps the project organized.

---

# PART D: FLUTTER SETUP

---

## 9. Create Flutter App

Recommended command:

```bash
flutter create app
```

Then go inside:

```bash
cd app
```

Run:

```bash
flutter doctor
```

Fix any issues before continuing.

---

## 10. Flutter Platforms

V1 should support:

* Android
* iOS
* iPadOS
* Web or PC if possible

Development priority:

1. Android
2. iOS
3. iPad
4. Web / PC

Reason:

Mobile is the main user experience.

PC/Web is important for easier upload, but it can be improved after the core mobile app works.

---

## 11. Recommended Flutter Folder Structure

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

    invites/
      data/
      models/
      screens/
      services/
      widgets/

    members/
      data/
      models/
      screens/
      services/
      widgets/

    trash/
      data/
      models/
      screens/
      services/
      widgets/

    notifications/
      data/
      models/
      screens/
      services/
      widgets/

    profile/
      data/
      models/
      screens/
      services/
      widgets/
```

Do not put everything inside `main.dart`.

---

## 12. State Management

Recommended:

**Riverpod**

Reason:

* Clean
* Good for async data
* Good for services
* Good for large apps
* Easy to organize by features

Do not mix many state management systems.

---

## 13. Flutter Packages to Consider

Check latest versions before installing.

Possible packages:

### Supabase

* `supabase_flutter`

Purpose:

* Supabase Auth
* Supabase database
* Supabase client

### State Management

* `flutter_riverpod`

Purpose:

* App state
* Auth state
* Album state
* Upload state

### File Picker

* `file_picker`

Purpose:

* Pick files from device or PC

### Photo Picker / Image Picker

* `image_picker`
* or platform photo picker package if needed

Purpose:

* Pick photos and videos

Important:

Make sure selected files are original files, not compressed previews.

### Permissions

* `permission_handler`

Purpose:

* Photo permission
* File permission
* Notification permission

### Path and Files

* `path_provider`
* `path`

Purpose:

* Local file handling
* Temporary files
* Downloads

### HTTP Requests

* `dio`
* or `http`

Purpose:

* Upload to storage
* Download original files
* Track progress

Recommendation:

Use `dio` if upload/download progress is needed.

### Notifications

* `firebase_messaging`

Purpose:

* Push notifications

Use later after core upload/download is working.

### Local Notifications

* `flutter_local_notifications`

Purpose:

* Show local notification if needed

### Secure Storage

* `flutter_secure_storage`

Purpose:

* Store sensitive local session data if needed

### Environment Variables

* `flutter_dotenv`

Purpose:

* Load environment config

---

## 14. Flutter Theme Direction

Use maroon-based theme.

Suggested colors:

* Primary: Deep Maroon
* Secondary: Warm Cream
* Accent: Soft Gold
* Background: Off White
* Text: Dark Brown or Near Black

Do not finalize colors until logo is provided.

Temporary theme is okay for early development.

---

# PART E: SUPABASE SETUP

---

## 15. Create Supabase Project

Create one Supabase project first for development.

Recommended project name:

`potoos-dev`

Later create:

`potoos-prod`

Do not mix development and production data.

---

## 16. Supabase Auth Setup

Enable:

* Google OAuth Login

V1 uses Google Login only.

Do not enable Apple Login or Email Login in V1 unless decided later.

---

## 17. Supabase Database Setup

Create tables based on:

**Potoos Supabase SQL and RLS Planning Document v1.0**

Main tables:

* `user_profiles`
* `albums`
* `album_members`
* `album_invites`
* `storage_providers`
* `storage_objects`
* `media_files`
* `media_thumbnails`
* `device_tokens`
* `notifications`
* `activity_logs`

Future tables:

* `plans`
* `subscriptions`
* `billing_history`
* `storage_usage`

Future tables are not required for the first MVP.

---

## 18. Supabase RLS Setup

Enable RLS on important tables.

Important rule:

**Never trust frontend only.**

RLS must protect:

* Albums
* Members
* Invites
* Media files
* Notifications
* Device tokens

---

## 19. Supabase Edge Functions Setup

Create Edge Functions for sensitive actions.

First functions to build:

1. `create-user-profile`
2. `create-album`
3. `create-upload-session`
4. `complete-upload`
5. `get-download-access`

Do not build all functions at once.

Start with the proof of concept.

---

## 20. Supabase Environment Variables

Possible Supabase Edge Function environment variables:

```text
SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GOOGLE_DRIVE_FOLDER_ID=
GOOGLE_DRIVE_REFRESH_TOKEN=
STORAGE_PROVIDER=google_drive
APP_ENV=development
```

Important:

Never put service role key inside Flutter.

Service role key belongs only in backend or Edge Functions.

---

# PART F: GOOGLE CLOUD AND GOOGLE DRIVE SETUP

---

## 21. Google Cloud Project

Create Google Cloud project.

Recommended name:

`Potoos`

Needed for:

* Google OAuth
* Google Drive API
* App credentials

---

## 22. Google OAuth Setup

Configure OAuth for:

* Supabase Google Login
* Google API access if needed

Required:

* App name
* Support email
* Authorized redirect URLs
* Privacy policy URL later
* Terms of use URL later

For early development, temporary URLs may be used if allowed.

Before production, use final URLs.

---

## 23. Google Drive API Setup

Enable:

* Google Drive API

Purpose:

* Store original photos and videos in managed Google Drive-backed storage
* Retrieve files for download

Important:

The app users should not need to connect their own Drive.

Potoos-managed storage handles files behind the scenes.

---

## 24. Google Drive Storage Folder Structure

Recommended structure inside managed storage:

```text
Potoos Storage/
  development/
    albums/
      album_id/
        originals/
        thumbnails/

  production/
    albums/
      album_id/
        originals/
        thumbnails/
```

Example:

```text
albums/
  123-album-id/
    originals/
      456-file-id_IMG_001.JPG
    thumbnails/
      456-file-id_thumb.jpg
```

Keep original files separate from thumbnails.

---

## 25. Google Drive Storage Rules

Rules:

1. Store original files.
2. Do not compress original files.
3. Do not resize original files.
4. Do not convert original files.
5. Keep thumbnails separate.
6. Do not expose permanent public links.
7. Use backend permission checks before download.
8. Store Google Drive file IDs in the database.
9. Keep Google credentials in backend only.

---

# PART G: ENVIRONMENT FILES

---

## 26. Flutter Environment Variables

Example `.env` for Flutter:

```text
APP_ENV=development
SUPABASE_URL=
SUPABASE_ANON_KEY=
```

Do not store:

* Supabase service role key
* Google client secret
* Google refresh token
* Push notification server key

---

## 27. Backend Environment Variables

Example backend variables:

```text
SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=
GOOGLE_DRIVE_CLIENT_ID=
GOOGLE_DRIVE_CLIENT_SECRET=
GOOGLE_DRIVE_REFRESH_TOKEN=
GOOGLE_DRIVE_ROOT_FOLDER_ID=
FCM_SERVER_KEY=
APP_ENV=development
```

These must stay private.

---

## 28. Git Ignore Rules

Make sure these are ignored:

```text
.env
.env.local
.env.production
*.keystore
*.jks
GoogleService-Info.plist
google-services.json
service-account.json
```

Important:

Some Firebase config files may be needed in app builds, but secrets should be handled carefully.

Do not commit private keys.

---

# PART H: IOS SETUP

---

## 29. iOS Development Needs

To build for iOS, you need:

* macOS
* Xcode
* Apple Developer account later
* iPhone or iPad for testing

---

## 30. iOS Bundle ID

Recommended bundle ID:

```text
com.potoos.app
```

---

## 31. iOS Permissions

Prepare permission text for:

### Photo Access

```text
Potoos needs photo access so you can upload original-quality photos and videos.
```

### Save to Photos

```text
Potoos needs permission to save original-quality files to your Photos.
```

### Notifications

```text
Allow notifications so you know when new memories are added to your albums.
```

---

## 32. iOS Testing Priority

Test early on:

* iPhone
* iPad

Do not wait until the app is finished before testing iOS.

Important iOS tests:

* Google Login
* Upload from Photos
* Upload from Files
* Save to Photos
* Save to Files
* Save All
* Notifications

---

# PART I: ANDROID SETUP

---

## 33. Android Package Name

Recommended package name:

```text
com.potoos.app
```

---

## 34. Android Permissions

Prepare for:

* Gallery access
* File access
* Notification permission
* Internet access

---

## 35. Android Testing Priority

Test:

* Google Login
* Upload from Gallery
* Upload from Files
* Video upload
* Download
* Save to Gallery
* Save to Files
* Notifications

---

# PART J: FIRST PROOF OF CONCEPT

---

## 36. Proof of Concept Goal

The first proof of concept must prove the most important technical question:

**Can Potoos upload and download original-quality files using the planned stack?**

---

## 37. Proof of Concept Scope

Build only:

1. Google Login
2. Create album
3. Upload one original photo
4. Store file metadata
5. Download original photo
6. Compare quality

Do not build yet:

* Invites
* Save All
* Notifications
* Soft delete
* Full UI polish
* Payment
* Business features

---

## 38. Proof of Concept Success Criteria

The proof of concept is successful if:

* User can log in.
* User can create an album.
* User can select one photo.
* Photo uploads to storage.
* Metadata saves in Supabase.
* Photo appears in album.
* User can download the photo.
* Downloaded photo keeps original quality.

---

## 39. Original Quality Test for Proof of Concept

Compare:

* Original file size
* Downloaded file size
* Original width
* Downloaded width
* Original height
* Downloaded height
* MIME type
* File extension

If these do not match, check:

* Is the picker returning compressed image?
* Is the app uploading thumbnail instead of original?
* Is Google Drive storing the correct file?
* Is the download using original file ID?
* Is the app converting the file before upload?

---

# PART K: FIRST CODEX PROMPT

---

## 40. First Codex Prompt

Use this prompt when starting development with Codex:

```text
You are helping me build Potoos, a private photo and video sharing app.

App name: Potoos
Tagline: Share Memories in Original Quality

Main rule:
The app must upload, store, and download original-quality photos and videos. Do not compress, resize, convert, or replace original files. Thumbnails are allowed only if they are separate from the original file.

Tech stack:
- Flutter frontend
- Supabase backend
- Supabase Auth with Google Login only for V1
- Supabase Postgres database
- Supabase Edge Functions
- Google Drive / Google One-backed storage for V1
- Push notifications later

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

Main rules:
- Albums are private by default.
- Only invited album members can access albums.
- Admin and Contributor can upload.
- Viewer can only view and download.
- Only original uploader can delete and restore their own files.
- Deleted files are restorable for 30 days.
- Save All must download original files, not thumbnails.

Development goal for now:
Build the first proof of concept only.

Proof of concept features:
1. Create Flutter project structure.
2. Connect Supabase.
3. Implement Google Login.
4. Create user profile after login.
5. Create album.
6. Add creator as Admin.
7. Upload one original photo to Google Drive-backed storage.
8. Save file metadata in Supabase.
9. Show the uploaded file in album.
10. Download the original photo.
11. Add simple quality test notes so we can compare original vs downloaded file.

Do not build invites, Save All, notifications, soft delete, or monetization yet.

Follow clean folder structure.
Do not put all code in main.dart.
Do not store secrets in Flutter.
Use environment variables.
Use simple, clear code.
```

---

# PART L: FIRST DEVELOPMENT MILESTONE

---

## 41. Milestone 1: Core Proof

Milestone name:

**Core Original Quality Proof**

Goal:

Prove that original photo upload and download works.

Features:

* Flutter app opens
* Supabase connects
* Google Login works
* User profile is created
* User can create album
* Creator becomes Admin
* User can upload one original photo
* Metadata is saved
* User can download original photo
* Quality check passes

---

## 42. Milestone 1 Done Checklist

Milestone 1 is done when:

* App runs on Android emulator or real device.
* App runs on iPhone if available.
* Google Login works.
* User appears in Supabase.
* Album appears in Supabase.
* Album creator is Admin.
* Photo uploads to storage.
* Media file record appears in Supabase.
* Storage object record appears in Supabase.
* Downloaded file is original quality.
* No secrets are exposed in Flutter.

---

# PART M: DEVELOPMENT RULES

---

## 43. Rules During Coding

Always follow these rules:

1. Build small parts first.
2. Test after each part.
3. Do not build future features early.
4. Do not skip permission checks.
5. Do not expose secrets.
6. Do not compress original files.
7. Do not use thumbnail as download file.
8. Do not add social features.
9. Keep storage logic separate.
10. Keep code clean and readable.

---

## 44. What Not to Build First

Do not build these first:

* Full app UI polish
* Payment system
* Photographer mode
* Business mode
* White label
* Apple Login
* Email Login
* Chat
* Likes
* Comments
* AI features
* Public albums

Reason:

These can distract from the core proof.

---

## 45. First Technical Risk to Solve

The biggest first risk is:

**Google Drive-backed storage implementation.**

This must be tested early.

Reason:

The app depends on original-quality storage and download.

If Google Drive API setup becomes too hard or limited, the team needs to know early before building the full app.

---

## 46. Backup Storage Plan

V1 plan remains:

**Google Drive / Google One-backed storage**

But the code should be future-ready.

Future storage options:

* Google Cloud Storage
* Cloudflare R2
* Supabase Storage

Use a storage service pattern if possible.

Example:

```text
StorageService
  GoogleDriveStorageService
  FutureR2StorageService
  FutureSupabaseStorageService
```

This makes future migration easier.

---

# PART N: FUTURE DOCUMENTS

---

## 47. Next Documents After This

After this starter pack, the next useful documents are:

1. **Potoos Actual SQL Migration v1.0**
2. **Potoos Flutter Project Structure Guide v1.0**
3. **Potoos Google Drive API Proof Plan v1.0**
4. **Potoos First Sprint Task List v1.0**

Recommended next document:

**Potoos Google Drive API Proof Plan v1.0**

Reason:

Google Drive-backed storage is the biggest technical risk.

It should be tested before building the full MVP.

---

## 48. Final Starter Pack Summary

Before coding, prepare:

* Flutter
* Supabase
* Google Cloud
* Google Drive API
* GitHub
* Environment variables
* Project folders
* Basic documentation

Start with:

1. Google Login
2. Create album
3. Upload one original photo
4. Download one original photo
5. Check original quality

Do not build the full app until this core proof works.

Main rule:

**Potoos must share memories in original quality.**
