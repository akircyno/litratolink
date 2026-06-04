# Potoos Codex Development Instructions v1.0

## 1. Document Purpose

This document gives clear instructions for building the Potoos app using Codex or any AI coding assistant.

This document is based on:

* Potoos Master Product Plan v1.0
* Potoos System Architecture Document v1.0
* Potoos Database Design Document v1.0
* Potoos UI/UX Flow Document v1.0
* Potoos Development Roadmap v1.0

The goal of this document is to guide the development process step by step.

Codex must follow this document when creating code, editing files, planning features, or fixing bugs.

---

## 2. Project Summary

**App Name:** Potoos
**Tagline:** Share Memories in Original Quality
**Product Type:** Private cloud sharing app

Potoos allows users to create private albums, invite selected people, upload original-quality photos and videos, and download those files without losing quality.

The app must be simple, private, and easy to use.

---

## 3. Main Product Rule

The most important rule:

**Potoos must upload, store, and download original-quality photos and videos.**

Codex must never create code that compresses, resizes, converts, or lowers the quality of the original uploaded file unless the user clearly asks for preview or thumbnail generation.

If thumbnails are created, they must be separate from the original file.

The original file must always stay unchanged.

---

## 4. Product Non-Negotiables

Codex must always follow these rules:

1. Do not add likes.
2. Do not add comments.
3. Do not add followers.
4. Do not add social feed.
5. Do not add public profiles.
6. Do not add public albums in V1.
7. Do not add chat in V1.
8. Do not add photo editing in V1.
9. Do not add payment system in V1.
10. Do not add business or photographer mode in V1.

Potoos is a private cloud sharing app, not a social media app.

---

## 5. Confirmed Technology Stack

### Frontend

Use:

* Flutter

Target platforms:

* Android
* iPhone
* iPad
* Web / PC if possible

### Backend

Use:

* Supabase

Supabase handles:

* Authentication
* Database
* Row Level Security
* Album permissions
* Invites
* Edge Functions
* Device tokens
* Notification records

### Storage

Use:

* Potoos-managed Google Drive / Google One-backed storage for V1

Important:

Users should not need their own Google Drive storage.

The app should manage storage behind the scenes.

### Notifications

Use:

* Supabase for notification records and device tokens
* FCM/APNs delivery for push notifications

Important:

Firebase is not the main backend. It may only be used for push notification delivery if needed.

---

## 6. Authentication Rules

V1 uses:

* Google Login only

Codex must not add Apple Login, Email Login, or Magic Link Login in V1 unless asked later.

Future options must be kept as future enhancements only.

### Login Flow

1. User opens app.
2. User taps **Continue with Google**.
3. Supabase handles login.
4. If user profile does not exist, create one.
5. User goes to Home / My Albums.

---

## 7. User Roles

Each album has roles.

The roles are:

1. Admin
2. Contributor
3. Viewer

A user can have different roles in different albums.

---

## 8. Role Permissions

### Admin Can:

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

### Admin Cannot:

* Restore files uploaded by other users
* Delete files uploaded by other users in V1
* Bypass backend permission rules

---

### Contributor Can:

* View album
* View files
* Download files
* Upload files
* Delete their own uploaded files
* Restore their own deleted files within 30 days

### Contributor Cannot:

* Invite members
* Remove members
* Change member roles
* Delete album
* Restore files uploaded by other users

---

### Viewer Can:

* View album
* View files
* Download files
* Use Save All

### Viewer Cannot:

* Upload files
* Delete files
* Restore files
* Invite members
* Remove members
* Change roles
* Delete album

---

## 9. Privacy Rules

Codex must enforce privacy in the backend and database, not only in the UI.

Rules:

1. Albums are private by default.
2. Only invited members can access albums.
3. Users can only see albums where they are active members.
4. Users cannot see albums where they were removed.
5. Users cannot see files from albums they are not part of.
6. Users cannot access another user’s Trash.
7. Users cannot restore another user’s deleted files.
8. Users cannot read another user’s notifications.
9. Users cannot manage members unless they are Admin.
10. Frontend hiding is not enough. Supabase RLS must enforce access.

---

## 10. Soft Delete Rules

Potoos uses soft delete.

### Delete Rule

Only the original uploader can delete their own uploaded file.

When a file is deleted:

* It disappears from the album for everyone.
* It moves to Trash.
* It remains restorable for 30 days.
* It is not permanently deleted immediately.

### Restore Rule

Only the original uploader can restore their own deleted file.

Admin cannot restore files uploaded by other users.

Contributor cannot restore files uploaded by other users.

Viewer cannot restore files.

### Permanent Delete Rule

After 30 days, deleted files may be permanently deleted.

---

## 11. Album Rules

1. Every user can create albums.
2. The album creator becomes Admin.
3. Albums are private by default.
4. Albums are invite-only.
5. There are no public albums in V1.
6. Every active album must have at least one Admin.
7. Only Admin can invite members.
8. Only Admin can remove members.
9. Only Admin can change roles.
10. Only Admin can delete album.

---

## 12. Upload Rules

Codex must follow these upload rules:

1. Upload photos and videos.
2. Upload original files only.
3. Do not compress.
4. Do not resize.
5. Do not convert.
6. Preserve original file name if possible.
7. Preserve MIME type if possible.
8. Save file size.
9. Save uploader ID.
10. Save album ID.
11. Save storage object ID.
12. Save upload status.
13. Show upload progress.
14. Allow retry if upload fails.

Upload is allowed only for:

* Admin
* Contributor

Viewer cannot upload.

---

## 13. Download Rules

Codex must follow these download rules:

1. Download original file only.
2. Never download thumbnail as the final file.
3. Allow single download.
4. Allow selected download.
5. Allow Save All.
6. Show download progress.
7. Allow retry if download fails.
8. Check permission before downloading.
9. Do not expose permanent public file links.
10. Save to Photos, Gallery, Files, or Downloads depending on platform.

Download is allowed for:

* Admin
* Contributor
* Viewer

as long as the user is an active album member.

---

## 14. Save All Rules

Save All is a core feature.

Codex must make Save All reliable.

Rules:

1. Save All must download original files.
2. Save All must not use thumbnails.
3. Save All must show progress.
4. Save All must handle large albums safely.
5. Save All should download files one by one or in safe batches.
6. Save All must allow retry for failed files.
7. Save All must warn users that large albums may use device storage.
8. Save All should not crash the app.

---

## 15. Notification Rules

Push notifications must be simple and private.

Good notification examples:

* New photos were added to your album.
* You were invited to an album.
* Your upload is complete.
* A member joined your album.

Bad notification examples:

* IMG_1234_private.jpg was uploaded.
* Your girlfriend uploaded private_photo.jpg.

Rules:

1. Do not expose private file names.
2. Do not expose sensitive album content.
3. Do not send one notification per file when many files are uploaded.
4. Group upload notifications.
5. Removed members should not receive album notifications.
6. Logged-out devices should stop receiving notifications if possible.

---

## 16. Recommended Flutter Folder Structure

Use a clear feature-based structure.

Recommended structure:

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

Do not place all logic inside one file.

Do not place all screens in `main.dart`.

---

## 17. Recommended Supabase Structure

Supabase should include:

### Main Tables

* `user_profiles`
* `albums`
* `album_members`
* `album_invites`
* `media_files`
* `media_thumbnails`
* `storage_providers`
* `storage_objects`
* `device_tokens`
* `notifications`
* `activity_logs`

### Future Tables

These are planned but not fully implemented in V1:

* `plans`
* `subscriptions`
* `billing_history`
* `storage_usage`

---

## 18. Important Database Rules

Codex must not create database logic that allows open access.

Every table must be protected by RLS where needed.

Important rules:

1. Users can only read albums where they are members.
2. Users can only read files from albums where they are members.
3. Users can only upload if Admin or Contributor.
4. Users can only invite if Admin.
5. Users can only delete their own uploaded files.
6. Users can only restore their own deleted files.
7. Users can only read their own notifications.
8. Users can only manage their own device tokens.
9. Users can only accept invites sent to their email.
10. Removed users lose album access.

---

## 19. Edge Function Rules

Use Supabase Edge Functions for sensitive backend actions.

Possible Edge Functions:

* `create-upload-session`
* `complete-upload`
* `get-download-url`
* `send-notification`
* `accept-invite`
* `soft-delete-file`
* `restore-file`
* `cleanup-expired-files`

Rules:

1. Do not put sensitive keys in Flutter.
2. Keep Google API credentials in backend environment variables.
3. Check user permissions inside Edge Functions.
4. Return simple errors to the app.
5. Log important actions safely.
6. Do not expose raw secrets or admin tokens.

---

## 20. Google Drive Storage Rules

V1 storage uses Potoos-managed Google Drive / Google One-backed storage.

Codex must treat Google Drive as a storage provider.

Do not hard-code the app so it can only ever use Google Drive.

Use a storage adapter pattern if possible.

### Storage Provider Concept

V1:

* Google Drive

Future:

* Google Cloud Storage
* Cloudflare R2
* Supabase Storage
* Other S3-compatible storage

### Storage Rules

1. Store original files.
2. Store storage object records.
3. Save Google Drive file ID in backend only.
4. Do not expose permanent public links.
5. Use backend permission checks before download.
6. Keep thumbnail separate from original.
7. Do not make all files public.

---

## 21. UI/UX Rules

Codex must keep the app simple.

Main screens:

1. Splash Screen
2. Welcome Screen
3. Login Screen
4. Home / My Albums
5. Create Album
6. Album Details
7. Upload Screen
8. Upload Progress
9. File Preview
10. Save / Download
11. Members
12. Invite Member
13. Pending Invites
14. Notifications
15. Trash
16. Profile
17. Settings

### Design Direction

Use:

* Deep maroon
* Warm cream
* Soft gold
* Off white
* Dark brown or near black

The app should feel:

* Private
* Warm
* Clean
* Simple
* Trustworthy

---

## 22. UI Button Rules

### Show Upload Button Only If:

User role is:

* Admin
* Contributor

Do not show Upload for Viewer.

### Show Invite Button Only If:

User role is:

* Admin

### Show Delete File Button Only If:

User is the original uploader.

### Show Restore Button Only If:

User is the original uploader of the deleted file.

### Show Save All Button If:

User is active album member with role:

* Admin
* Contributor
* Viewer

---

## 23. Error Message Rules

Do not show technical errors directly to users.

Bad:

```text
Error 403 forbidden exception
```

Good:

```text
You do not have access to this album.
```

Common user-friendly messages:

* No internet connection. Please check your connection and try again.
* Upload failed. Please try again.
* Download failed. Please try again.
* You do not have permission to do this.
* This album is no longer available.
* This file is no longer available.
* This invite has expired. Please ask for a new invite.
* Upload failed because storage is currently full. Please try again later.

---

## 24. Permission Message Rules

Use simple permission messages.

### Photo Access

```text
Potoos needs photo access so you can upload original-quality photos and videos.
```

### Save to Photos

```text
Potoos needs permission to save original-quality files to your Photos.
```

### File Access

```text
Potoos needs file access so you can choose and save files.
```

### Notifications

```text
Allow notifications so you know when new memories are added to your albums.
```

---

## 25. Development Build Order

Codex must build the app in this order.

### Step 1: Setup

Build:

* Flutter project
* Supabase connection
* App theme
* Basic routing
* Environment config

### Step 2: Authentication

Build:

* Google Login
* User profile creation
* Logout
* Session check

### Step 3: Albums Core

Build:

* Create album
* My Albums screen
* Album details screen
* Creator becomes Admin

### Step 4: Storage Proof

Build:

* Google Drive upload proof
* Upload one original photo
* Save file metadata
* Download original photo

### Step 5: Multiple Uploads

Build:

* Select multiple photos/videos
* Upload progress
* Failed upload retry
* Upload complete state

### Step 6: Gallery

Build:

* Album gallery
* Thumbnail preview
* File preview screen
* Video preview if possible

### Step 7: Invites and Members

Build:

* Members screen
* Invite by email
* Accept invite
* Decline invite
* Role management

### Step 8: Permissions and RLS

Build:

* Full role checks
* RLS policies
* Backend permission checks
* Removed member access blocking

### Step 9: Downloads

Build:

* Download Original
* Select files
* Save Selected
* Save All
* Download progress
* Retry failed downloads

### Step 10: Soft Delete

Build:

* Delete own file
* Trash screen
* Restore own file
* 30-day delete rule

### Step 11: Notifications

Build:

* Device token registration
* Upload notification
* Invite notification
* Notification screen

### Step 12: Polish and Testing

Build or improve:

* Empty states
* Error states
* Loading states
* Maroon theme
* App icon placeholder
* iOS permissions
* Android permissions
* TestFlight readiness

---

## 26. Testing Instructions

Codex must help test each feature.

### Test Authentication

Check:

* Login works
* Logout works
* User profile is created
* Session persists after reopening app

### Test Albums

Check:

* User can create album
* Album creator becomes Admin
* Album appears in My Albums
* Non-members cannot access album

### Test Upload

Check:

* Admin can upload
* Contributor can upload
* Viewer cannot upload
* Upload keeps original file
* Upload progress works
* Failed upload can retry

### Test Download

Check:

* Admin can download
* Contributor can download
* Viewer can download
* Non-member cannot download
* Downloaded file matches original quality
* Save All uses original files

### Test Invites

Check:

* Admin can invite
* Contributor cannot invite
* Viewer cannot invite
* Invite email must match login email
* Accepted invite creates membership

### Test Delete and Restore

Check:

* Uploader can delete their own file
* Uploader can restore their own deleted file
* Admin cannot restore another user’s file
* Viewer cannot delete or restore
* Deleted files disappear for everyone

### Test Notifications

Check:

* Invite notification works
* New upload notification works
* Upload complete notification works
* Notification does not expose private file name

---

## 27. Original Quality Testing

This is very important.

For every upload and download test, compare:

* Original file name
* Original file size
* Downloaded file size
* Original resolution
* Downloaded resolution
* Original video duration
* Downloaded video duration

The app should not reduce quality.

If there is any mismatch, Codex must check if the app is using:

* Compressed image picker result
* Thumbnail instead of original
* Converted file
* Resized preview
* Wrong download URL

---

## 28. What Codex Must Not Do

Codex must not:

1. Add social media features.
2. Add likes.
3. Add comments.
4. Add followers.
5. Add public profiles.
6. Add public feed.
7. Add payment system in V1.
8. Add Apple Login in V1 unless asked.
9. Add Email Login in V1 unless asked.
10. Compress original photos.
11. Compress original videos.
12. Replace original files with thumbnails.
13. Store secret keys in Flutter.
14. Expose permanent public file links.
15. Allow users to access albums where they are not members.
16. Allow Admin to restore another user’s deleted file.
17. Allow Viewer to upload.
18. Allow Contributor to invite members.
19. Build everything in one huge file.
20. Skip permission checks.

---

## 29. Coding Style Rules

Use simple, clean, maintainable code.

Rules:

1. Use clear file names.
2. Use clear class names.
3. Keep screens separate.
4. Keep services separate.
5. Keep models separate.
6. Avoid huge files.
7. Avoid duplicated logic.
8. Add comments only when helpful.
9. Use constants for repeated values.
10. Handle errors clearly.
11. Keep UI and backend logic separated.
12. Use feature folders.
13. Use environment variables.
14. Never hard-code secrets.

---

## 30. State Management

Use a clear Flutter state management approach.

Recommended options:

* Riverpod
* Bloc
* Provider

For this project, Codex should choose one and keep it consistent.

Do not mix many state management systems unless necessary.

Recommendation:

Use **Riverpod** if starting from scratch.

Reason:

* Clean structure
* Good for services
* Good for async state
* Easy to test

---

## 31. Environment Setup Rules

Use separate environments:

* Development
* Staging
* Production

Do not mix test data and production data.

Environment variables may include:

* Supabase URL
* Supabase anon key
* Google API config
* Storage provider config
* App environment name

Never expose:

* Supabase service role key
* Google service credentials
* Push notification server keys

---

## 32. App Store and TestFlight Rules

V1 should be tested through TestFlight before App Store release.

Codex should prepare code with iOS in mind.

Important iOS requirements:

* Photo permission
* Save to Photos permission
* Notification permission
* Clear permission messages
* App icon
* Privacy labels
* Privacy policy
* Terms of use later

Do not wait until the end to test iOS.

Test iOS early.

---

## 33. Future Enhancement Rules

The app should be future-ready, but not overbuilt.

Future enhancements should be planned but not fully implemented in V1.

Future enhancements:

* Apple Login
* Email Login
* Magic Link Login
* Premium plans
* Family plan
* Couple plan
* Photographer mode
* Business mode
* White label
* Storage upgrade
* ZIP download
* End-to-end encryption

Codex must mark these as future only unless the user says to start them.

---

## 34. Monetization-Ready Rule

Do not build payments in V1.

But the database and architecture should not block future monetization.

Future tables can be planned:

* `plans`
* `subscriptions`
* `billing_history`
* `storage_usage`

These can remain inactive until needed.

---

## 35. Storage Adapter Rule

The app should be designed so storage can change later.

V1 storage provider:

* Google Drive

Future providers:

* Google Cloud Storage
* Cloudflare R2
* Supabase Storage

Codex should avoid writing code that makes migration very hard.

Recommended idea:

Create a storage service interface.

Example:

* `StorageService`
* `GoogleDriveStorageService`
* Future: `R2StorageService`

This keeps the storage layer cleaner.

---

## 36. Minimum Working App Definition

The minimum working app must allow:

1. User logs in with Google.
2. User creates an album.
3. User uploads one original photo.
4. User sees the photo inside the album.
5. User downloads the original photo.
6. Downloaded file keeps original quality.

This must be completed before building advanced features.

---

## 37. MVP Definition

The MVP must include:

* Google Login
* User profiles
* Create album
* Album list
* Album details
* Upload photos
* Upload videos
* Original quality storage
* Download original file
* Save All
* Invite by email
* Accept invite
* Roles: Admin, Contributor, Viewer
* Soft delete
* Restore own file
* Basic notifications
* Mobile support
* iOS TestFlight readiness

---

## 38. Final Development Instruction

Codex must always check the documents before making major changes.

The correct priority is:

1. Product rules
2. Privacy rules
3. Original quality rules
4. Permission rules
5. Simple user experience
6. Future-ready architecture

If a feature conflicts with the main promise, do not build it.

Main promise:

**Share Memories in Original Quality.**

---

## 39. Next Recommended Document

The next recommended document is:

**Potoos API and Edge Functions Specification v1.0**

This document should define:

* API functions
* Edge Function names
* Request bodies
* Response bodies
* Error messages
* Permission checks
* Upload session flow
* Download access flow
* Invite flow
* Notification flow
