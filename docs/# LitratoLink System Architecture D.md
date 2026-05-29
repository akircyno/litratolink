# LitratoLink System Architecture Document v1.0

## 1. Document Purpose

This document explains how the LitratoLink app will be built from a technical point of view.

This document is based on the approved **LitratoLink Master Product Plan v1.0**.

The goal of this document is to explain:

* What technologies will be used.
* How the app will work.
* How users will log in.
* How albums will be created.
* How photos and videos will be uploaded.
* How original quality will be protected.
* How permissions will work.
* How downloads will work.
* How push notifications will work.
* How the app can grow in the future.

This is not yet the final code. This is the technical guide before development.

---

## 2. Product Summary

**App Name:** LitratoLink
**Tagline:** Share Memories in Original Quality
**Product Type:** Private cloud sharing app

LitratoLink is an app for sharing original-quality photos and videos with selected people.

The app is not social media.

LitratoLink has:

* No likes
* No comments
* No followers
* No public feed
* No public profiles

The app is focused on:

* Private albums
* Original quality
* Easy upload
* Easy download
* Invite-only access

---

## 3. Main Architecture Summary

LitratoLink will use this main architecture:

**Flutter App**
→ user interface for Android, iPhone, iPad, web, and PC

**Supabase**
→ authentication, database, permissions, album data, invites, and backend logic

**Google Drive / Google One-backed Storage**
→ stores original photos and videos

**Push Notification Service**
→ sends notifications when albums are shared or files are uploaded

---

## 4. Main Technology Stack

### 4.1 Frontend

**Technology:** Flutter

Flutter will be used because it can support:

* Android
* iPhone
* iPad
* Web
* Windows / PC in the future

Flutter allows us to build one app codebase for multiple platforms.

---

### 4.2 Backend

**Technology:** Supabase

Supabase will be used for:

* User accounts
* Google Login
* Database
* Album permissions
* Invites
* Realtime updates
* Edge Functions
* Security rules
* Device tokens
* Notification records

Supabase is a good fit because LitratoLink needs clear relationship data.

Example relationships:

* Users can own many albums.
* Albums can have many members.
* Members can have different roles.
* Albums can have many files.
* Files belong to uploaders.

This is easier to manage with Supabase because it uses PostgreSQL.

---

### 4.3 Database

**Technology:** Supabase Postgres

The database will store app data, not the actual original media files.

The database stores information like:

* User profiles
* Albums
* Album members
* File metadata
* Invites
* Roles
* Delete status
* Device tokens
* Notification history

The actual photos and videos will be stored in Google Drive-backed storage.

---

### 4.4 Authentication

**V1 Authentication:** Google Login only

Users will log in using their Google account.

Future login options:

* Apple Login
* Email Login
* Magic Link Login

These are future enhancements and not part of V1.

---

### 4.5 Storage

**V1 Storage:** LitratoLink-managed Google Drive / Google One-backed storage

This means:

* Users do not need to connect their own Google Drive.
* Users do not need their own Google One plan.
* Users do not need to manage Drive folders.
* LitratoLink manages the storage experience for them.

The app must store the original uploaded file.

The app must not compress, resize, or convert the original file.

---

### 4.6 Push Notifications

Push notifications will be supported.

Recommended setup:

* Supabase stores device tokens.
* Supabase Edge Functions prepare notification requests.
* A push notification delivery service sends the notification.

For mobile, the likely delivery service is:

* FCM for Android
* FCM/APNs path for iOS

Important note:

Using FCM for delivery does not mean Firebase is the main backend.

Supabase is still the main backend.

FCM is only used as a notification delivery tool.

---

## 5. High-Level System Diagram

Simple system flow:

```text
User
 ↓
Flutter App
 ↓
Supabase Auth
 ↓
Supabase Database
 ↓
Supabase Edge Functions
 ↓
Google Drive Storage
 ↓
Original Photo / Video Files
```

Notification flow:

```text
User uploads file
 ↓
Supabase stores file metadata
 ↓
Supabase Edge Function is triggered
 ↓
Notification service sends push notification
 ↓
Album members receive notification
```

Download flow:

```text
User taps Download or Save All
 ↓
Flutter App requests file access
 ↓
Supabase checks permission
 ↓
Backend provides secure download access
 ↓
App downloads original file
 ↓
File is saved to gallery or device storage
```

---

## 6. System Components

## 6.1 Flutter App

The Flutter app is the user-facing application.

It handles:

* Login screen
* Home screen
* Album list
* Album details
* Upload screen
* File picker
* Gallery view
* Download screen
* Save All
* Member management
* Invite screen
* Settings
* Notifications permission
* Photo and file permissions

The Flutter app must be simple and clean.

The app must not expose private keys or secret tokens.

The app must not directly bypass backend permission rules.

---

## 6.2 Supabase Auth

Supabase Auth manages user login.

V1 uses:

* Google Login only

When a user logs in:

1. User taps **Continue with Google**.
2. Google login opens.
3. User chooses Google account.
4. Supabase receives login result.
5. Supabase creates or finds the user account.
6. App loads the user profile.
7. User can access their albums.

---

## 6.3 Supabase Database

Supabase database stores structured app data.

Main database responsibilities:

* Store users
* Store albums
* Store album members
* Store roles
* Store file records
* Store invite records
* Store delete status
* Store notification records
* Store device tokens

The database does not store full original media files.

---

## 6.4 Supabase Row Level Security

Row Level Security, or RLS, is very important.

RLS makes sure users can only access data they are allowed to access.

Example:

A user can only see an album if they are a member of that album.

A user can only upload to an album if they are Admin or Contributor.

A user can only restore a deleted file if they are the original uploader.

Important rule:

Security must be enforced in the backend, not only in the app UI.

The app UI can hide buttons, but the database must still block unauthorized actions.

---

## 6.5 Supabase Edge Functions

Supabase Edge Functions will handle backend actions that should not happen directly in the app.

Possible Edge Function responsibilities:

* Create Google Drive upload session
* Validate album permissions
* Create file metadata
* Generate secure download access
* Send push notifications
* Handle invite acceptance
* Handle soft delete
* Handle restore
* Handle cleanup for expired deleted files
* Protect storage credentials

Edge Functions are important because sensitive storage keys should not be placed inside the Flutter app.

---

## 6.6 Google Drive / Google One-backed Storage

Google Drive-backed storage will store original photos and videos.

Storage responsibilities:

* Store original files
* Store file folders or paths
* Store file IDs
* Allow backend-controlled upload
* Allow backend-controlled download
* Keep files unchanged

The app should not expose raw permanent public links.

The backend should manage access.

---

## 6.7 Push Notification Service

Push notifications will alert users when something important happens.

Examples:

* New album invite
* New files uploaded
* Upload complete
* Member added
* Album shared

Notification content must be private.

Good notification:

> New photos were added to your album.

Bad notification:

> Your girlfriend uploaded private_photo_001.jpg.

The notification should not expose sensitive file names or private content.

---

## 7. User Authentication Architecture

## 7.1 V1 Login Method

V1 will use Google Login only.

Reason:

* Simple
* Fast to build
* Works on many platforms
* Easy for most users
* Fits current plan

---

## 7.2 Login Flow

```text
User opens app
 ↓
User taps Continue with Google
 ↓
Google login opens
 ↓
User selects Google account
 ↓
Supabase confirms login
 ↓
App checks if profile exists
 ↓
If no profile, create profile
 ↓
User enters app home
```

---

## 7.3 User Profile Creation

After first login, the app creates a user profile.

Profile may include:

* User ID
* Email
* Display name
* Profile photo
* Created date
* Last active date

The user profile is used for:

* Invites
* Album membership
* Upload tracking
* Notifications

---

## 7.4 Future Login Options

Not part of V1.

Future options:

* Apple Login
* Email Login
* Magic Link Login

These should be listed as future enhancement only.

---

## 8. Album Architecture

## 8.1 Album Concept

An album is a private container for photos and videos.

Each album has:

* Album ID
* Album name
* Album owner
* Album members
* Album roles
* Album files
* Created date
* Updated date
* Delete status

---

## 8.2 Album Creation Flow

```text
User taps Create Album
 ↓
User enters album name
 ↓
App sends request to Supabase
 ↓
Supabase creates album record
 ↓
Creator is added as Admin
 ↓
Album appears in user's album list
```

---

## 8.3 Album Privacy

All albums are private by default.

Rules:

* No public albums in V1.
* No public album search.
* No public profile page.
* Only invited members can access an album.
* Users cannot see albums where they are not members.

---

## 8.4 Album Roles

Each album member has one role.

Roles:

1. Admin
2. Contributor
3. Viewer

A user can be Admin in one album and Viewer in another album.

---

## 8.5 Admin Role

Admin can:

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

* Restore deleted files uploaded by another user
* Permanently access files after permission rules block them
* Bypass backend security

Important rule:

Admin means Album Admin, not app developer.

---

## 8.6 Contributor Role

Contributor can:

* View files
* Download files
* Upload files
* Delete their own uploaded files
* Restore their own uploaded files within 30 days

Contributor cannot:

* Invite members
* Remove members
* Change roles
* Delete album
* Restore files uploaded by other users

---

## 8.7 Viewer Role

Viewer can:

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

## 9. Invite Architecture

## 9.1 Invite by Email

Album Admin can invite users by email.

Invite flow:

```text
Admin opens album
 ↓
Admin taps Invite Member
 ↓
Admin enters email
 ↓
Admin chooses role
 ↓
Supabase creates invite record
 ↓
Invited user receives notification or email
 ↓
Invited user logs in
 ↓
User accepts invite
 ↓
User becomes album member
```

---

## 9.2 Invite Status

Invite may have statuses:

* Pending
* Accepted
* Expired
* Cancelled

---

## 9.3 Invite Rules

Rules:

* Only Admin can invite.
* Invite must be linked to one album.
* Invite must include a target email.
* Invite must include a role.
* Invite can be cancelled by Admin.
* Invite should not give access until accepted.
* User email must match invite email.

---

## 10. Upload Architecture

## 10.1 Upload Goal

The upload system must upload photos and videos in original quality.

The app must not compress the file.

The app must not resize the file.

The app must not convert the file.

---

## 10.2 Upload Flow

```text
User opens album
 ↓
App checks user role
 ↓
If Admin or Contributor, show Upload button
 ↓
User selects photos/videos
 ↓
App prepares file metadata
 ↓
App requests upload permission from backend
 ↓
Backend validates album access
 ↓
Backend prepares Google Drive upload
 ↓
App uploads original file
 ↓
Backend or app confirms upload success
 ↓
File metadata is saved in Supabase
 ↓
Album members receive notification
```

---

## 10.3 Upload Permission Rules

Upload is allowed only if:

* User is logged in.
* User is a member of the album.
* User role is Admin or Contributor.
* Album is active.
* User account is active.

Upload is not allowed if:

* User is Viewer only.
* User is not a member.
* Album is deleted.
* User is blocked or removed.
* Storage is unavailable.

---

## 10.4 Original Quality Rule

The original file must be uploaded exactly as selected.

Rules:

* No compression.
* No resizing.
* No forced format conversion.
* No replacing original with preview.
* Original file must remain downloadable.

The app can create thumbnails, but thumbnails are separate.

---

## 10.5 Thumbnail Rule

Thumbnails are optional but recommended.

Reason:

* Faster gallery loading
* Less mobile data usage
* Better user experience

Thumbnail rules:

* Thumbnail must be separate from original.
* Thumbnail must never replace the original file.
* Download button must use original file.
* Save All must use original file.

---

## 10.6 Upload Progress

The app should show upload progress.

Example:

* Uploading 3 of 25
* 45% uploaded
* Upload complete

If upload fails:

* Show failed status.
* Allow retry.
* Do not create a completed file record unless upload succeeds.

---

## 11. File Metadata Architecture

The app needs file metadata in Supabase.

Possible file metadata:

* File ID
* Album ID
* Uploader ID
* Original filename
* File type
* MIME type
* File size
* Google Drive file ID
* Storage path
* Thumbnail path
* Upload status
* Created date
* Updated date
* Deleted status
* Deleted date
* Restored date

The metadata is used to show files in the app.

The actual file is stored in Google Drive-backed storage.

---

## 12. Download Architecture

## 12.1 Download Goal

The download system must allow users to download original-quality files.

Download must not use thumbnails.

Download must not use compressed files.

---

## 12.2 Single Download Flow

```text
User opens album
 ↓
User taps file
 ↓
User taps Download
 ↓
App asks backend for download access
 ↓
Backend checks album membership
 ↓
Backend checks file status
 ↓
Backend returns secure download access
 ↓
App downloads original file
 ↓
App saves file to device
```

---

## 12.3 Save All Flow

```text
User opens album
 ↓
User taps Save All
 ↓
App checks selected files
 ↓
App asks backend for access
 ↓
Backend validates user access
 ↓
App downloads original files one by one
 ↓
App shows progress
 ↓
Files are saved to device
```

---

## 12.4 Selected Download Flow

```text
User opens album
 ↓
User selects files
 ↓
User taps Save Selected
 ↓
App downloads selected original files
 ↓
App saves files to device
```

---

## 12.5 Download Permission Rules

Download is allowed if:

* User is logged in.
* User is a member of the album.
* User has Viewer, Contributor, or Admin role.
* File is not deleted.
* Album is not deleted.

Download is not allowed if:

* User is not a member.
* File is deleted.
* Album is deleted.
* User was removed from album.
* User is blocked.

---

## 12.6 Mobile Saving Rules

For mobile:

The app may save to:

* Photos / Gallery
* Files app
* Device downloads folder

iOS and Android may require permissions.

The app must ask permission clearly.

Example message:

> LitratoLink needs access so you can save original-quality photos and videos to your device.

---

## 12.7 PC Saving Rules

For PC or web:

The app should allow:

* Download single file
* Download selected files
* Download all files

Future option:

* Download as ZIP

ZIP download is useful but can be added later if it is complex.

---

## 13. Soft Delete Architecture

## 13.1 Soft Delete Goal

Soft delete prevents accidental permanent loss.

Deleted files should not disappear forever immediately.

---

## 13.2 Delete Rule

Only the original uploader can delete their own file.

When a file is deleted:

* It is hidden from the album.
* It is marked as deleted in Supabase.
* It is moved to Trash status.
* It can be restored by the original uploader within 30 days.

---

## 13.3 Restore Rule

Only the original uploader can restore their own deleted file.

Admin cannot restore files uploaded by other users.

Contributor cannot restore files uploaded by other users.

Viewer cannot restore files.

---

## 13.4 Permanent Delete Rule

After 30 days, deleted files can be permanently deleted.

This may be handled by a scheduled backend job.

Permanent delete means:

* File is removed from storage.
* File record is marked permanently deleted.
* File can no longer be restored.

---

## 13.5 Soft Delete Flow

```text
Uploader taps Delete
 ↓
App asks for confirmation
 ↓
Backend checks uploader ownership
 ↓
File is marked as deleted
 ↓
File disappears from album
 ↓
File remains recoverable for 30 days
```

---

## 13.6 Restore Flow

```text
Uploader opens Trash
 ↓
Uploader taps Restore
 ↓
Backend checks uploader ownership
 ↓
File is marked active again
 ↓
File returns to original album
```

---

## 14. Album Delete Architecture

Album deletion should be handled carefully.

V1 recommendation:

* Use soft delete for albums.
* Do not permanently delete album immediately.
* Ask for confirmation.
* Hide deleted album from normal view.
* Keep album recoverable for a limited time.

Rules:

* Only Admin can delete album.
* Album delete affects the whole album.
* Album members lose access when album is deleted.
* Final deletion behavior should be reviewed during database design.

---

## 15. Notification Architecture

## 15.1 Notification Types

Possible notification types:

* Album invite
* Invite accepted
* New upload
* Upload complete
* Member added
* Member removed
* Role changed

---

## 15.2 Notification Flow

```text
Action happens
 ↓
Supabase database record is created or updated
 ↓
Edge Function prepares notification
 ↓
Notification is sent to target users
 ↓
User receives notification on device
```

---

## 15.3 Notification Privacy Rules

Notifications must be private and safe.

Avoid showing:

* Exact file names
* Private personal words
* Sensitive album details if possible

Use simple messages:

* New photos were added to your album.
* You were invited to an album.
* Your upload is complete.

---

## 15.4 Device Token Storage

The app must store device tokens for push notifications.

Device token table may include:

* User ID
* Device token
* Platform
* Device name
* Created date
* Last active date
* Is active

If user logs out, the device token should be disabled or removed.

---

## 16. Realtime Updates

Supabase Realtime can be used to update the app without manual refresh.

Examples:

* New file appears in album
* Invite appears
* Member role changes
* File is deleted
* File is restored

Realtime is useful, but it should not replace security rules.

Every realtime update must still follow database permissions.

---

## 17. Security Architecture

## 17.1 Main Security Rule

The backend must always check permissions.

The Flutter app must not be trusted alone.

Bad approach:

* Hide button in app only.

Good approach:

* Hide button in app.
* Also block action in backend if user is not allowed.

---

## 17.2 Access Checks

Every action must check:

* Is the user logged in?
* Is the user active?
* Is the user a member of this album?
* What is the user role?
* Is the album active?
* Is the file active?
* Is the user the uploader when needed?

---

## 17.3 Sensitive Keys

Sensitive keys must not be placed in the Flutter app.

Examples of sensitive keys:

* Google storage credentials
* Server keys
* Push notification server keys
* Admin service keys

These should stay in backend environment variables.

---

## 17.4 File Access Security

Original files must not be exposed using permanent public links.

Recommended approach:

* Store file IDs privately.
* App asks backend for access.
* Backend checks permission.
* Backend provides temporary or controlled download access.

---

## 17.5 Database Security

Supabase Row Level Security should protect:

* Albums
* Album members
* Files
* Invites
* Notifications
* Device tokens

Users must not be able to read or change records they do not own or do not have access to.

---

## 18. Privacy Architecture

LitratoLink must protect private memories.

Privacy rules:

* Albums are private by default.
* Users only see albums they belong to.
* Files are only visible to album members.
* Invite-only access.
* No public search.
* No public feed.
* No public profile.
* No social graph.

Important limitation for V1:

Because V1 uses LitratoLink-managed storage, the platform storage owner may technically control the storage location.

This is acceptable for V1 personal and small use, but if the app grows publicly, privacy and storage design should be reviewed.

Future privacy upgrades may include:

* User-owned storage
* Business storage separation
* End-to-end encryption
* Cloud object storage migration
* Stronger audit logs

These are future enhancements, not V1 requirements.

---

## 19. Platform Architecture

## 19.1 Android

Android app should support:

* Google Login
* Upload from gallery/files
* Save to gallery/files
* Push notifications
* Background upload if possible

---

## 19.2 iPhone and iPad

iOS app should support:

* Google Login
* Upload from Photos app
* Save to Photos or Files
* Push notifications
* TestFlight testing
* App Store release later

iOS permission messages must be clear.

---

## 19.3 Web / PC

Web or PC support should allow:

* Login
* Create album
* Upload files
* View album
* Download files
* Save selected
* Save all

PC support is important because the owner may upload from PC.

---

## 20. iOS Distribution Architecture

## 20.1 TestFlight First

Before public App Store release, use TestFlight.

TestFlight will allow selected users to install and test the app.

Test users may include:

* Developer
* Girlfriend
* Close friends
* Family

---

## 20.2 App Store Later

When stable, publish to App Store.

App Store release will need:

* Apple Developer account
* App Store listing
* App icon
* Screenshots
* Privacy policy
* Terms of use
* Correct permissions
* App review compliance

---

## 21. Original Quality Protection

This is a core architecture rule.

The app must protect original quality at every step.

Rules:

1. Upload original file.
2. Store original file.
3. Keep original file unchanged.
4. Use thumbnail only for preview.
5. Download original file.
6. Save All downloads original files.
7. Never use preview file as final download.

Quality must never be reduced silently.

If the app creates a smaller preview, it must be for display only.

---

## 22. Error Handling Architecture

The app should handle common errors clearly.

Possible errors:

* No internet
* Upload failed
* Download failed
* Storage full
* Permission denied
* User removed from album
* File no longer exists
* Invite expired
* Login failed
* Notification permission denied

Error messages should be simple.

Example:

Bad:

> Error 403 token invalid.

Better:

> You do not have access to this album.

---

## 23. Storage Full Behavior

Because V1 uses LitratoLink-managed storage, storage may become full.

If storage is full:

* Upload should fail safely.
* User should see a clear message.
* App should not lose selected files.
* App should allow retry later.
* Admin/developer should be notified if possible.

Example message:

> Upload failed because storage is currently full. Please try again later.

Future plan:

* Add storage usage tracking.
* Add premium storage plans.
* Move to scalable storage if needed.

---

## 24. Development Environment

Recommended environments:

### Local Development

Used by developer for building and testing.

### Staging

Used for testing before release.

### Production

Used by real users.

Recommended separation:

* Separate Supabase project for staging and production
* Separate storage folders or storage accounts for staging and production
* Separate app builds for testing and production

This prevents test data from mixing with real user data.

---

## 25. Environment Variables

Sensitive configuration should be stored as environment variables.

Possible environment variables:

* Supabase URL
* Supabase anon key
* Supabase service role key
* Google API credentials
* Push notification server key
* Storage folder ID
* App environment name

Service role keys must never be used in the Flutter app.

---

## 26. Basic Data Flow Examples

## 26.1 Create Album

```text
Flutter App
 ↓
Supabase Auth confirms user
 ↓
Supabase creates album
 ↓
Supabase creates album_member record
 ↓
Creator becomes Admin
```

---

## 26.2 Invite Member

```text
Admin enters email
 ↓
Supabase checks Admin role
 ↓
Invite record is created
 ↓
Notification/email is sent
 ↓
Invited user accepts
 ↓
album_member record is created
```

---

## 26.3 Upload File

```text
Uploader selects file
 ↓
App requests upload approval
 ↓
Backend checks album role
 ↓
File uploads to Google Drive storage
 ↓
File metadata saved in Supabase
 ↓
Album members are notified
```

---

## 26.4 Download File

```text
User taps Download
 ↓
Backend checks album membership
 ↓
Backend checks file status
 ↓
App receives download access
 ↓
Original file downloads
 ↓
File saves to device
```

---

## 26.5 Delete File

```text
Uploader taps Delete
 ↓
Backend checks uploader ownership
 ↓
File is marked deleted
 ↓
File is hidden from album
 ↓
File stays recoverable for 30 days
```

---

## 26.6 Restore File

```text
Uploader opens Trash
 ↓
Uploader taps Restore
 ↓
Backend checks uploader ownership
 ↓
File is marked active
 ↓
File returns to album
```

---

## 27. Future-Proofing Rules

Even if V1 is simple, the app should be designed so it can grow.

Important future-proofing rules:

1. Use clear database tables.
2. Keep storage logic separate.
3. Do not hard-code only Google Drive forever.
4. Use a storage adapter pattern if possible.
5. Keep monetization tables planned but inactive.
6. Keep roles flexible.
7. Keep album permissions strict.
8. Keep future login options possible.
9. Keep business use possible.
10. Avoid building social media features into the core.

---

## 28. Storage Adapter Concept

This is important for future growth.

The app should not be built in a way that only works with Google Drive.

Instead, storage should be treated as a storage provider.

V1 provider:

* Google Drive

Future providers:

* Google Cloud Storage
* Cloudflare R2
* Supabase Storage
* Other S3-compatible storage

Example concept:

```text
App requests upload
 ↓
Storage Service chooses provider
 ↓
Provider uploads file
 ↓
Provider returns file ID/path
 ↓
Supabase saves metadata
```

This makes future migration easier.

---

## 29. Monetization-Ready Architecture

Monetization is not part of V1.

But the architecture should not block it.

Future monetization may include:

* Premium plan
* Family plan
* Couple plan
* Photographer plan
* Business plan
* White label plan

Database can prepare future tables such as:

* plans
* subscriptions
* billing_history
* storage_usage

These can exist later or be planned in database design.

They should not be fully implemented in V1.

---

## 30. Main Risks

## 30.1 Google Drive API Complexity

Risk:

Google Drive API permissions and upload flow may be complex.

Solution:

* Keep storage logic in backend.
* Test upload and download early.
* Build a small proof of concept before full app.

---

## 30.2 iOS Permission Issues

Risk:

iOS may require clear permission handling for photos, files, and notifications.

Solution:

* Use proper permission messages.
* Test early on real iPhone/iPad.
* Use TestFlight before App Store.

---

## 30.3 Save All Reliability

Risk:

Downloading many files at once may fail if internet is slow.

Solution:

* Show progress.
* Download one by one.
* Allow retry.
* Allow selected download.
* Do not force all downloads at once.

---

## 30.4 Storage Cost and Limit

Risk:

Storage may become full or expensive.

Solution:

* Track storage usage.
* Start with small personal use.
* Prepare future migration to scalable storage.
* Add monetization later if app grows.

---

## 30.5 Privacy Expectations

Risk:

If app becomes public, users may expect stronger privacy.

Solution:

* Be clear in privacy policy.
* Use strong access controls.
* Avoid public links.
* Consider future encryption or storage separation.

---

## 31. Recommended Build Order

The recommended technical build order:

### Step 1: Proof of Concept

Build only:

* Google Login
* Create album
* Upload one original photo
* Save file metadata
* Download original photo

Purpose:
Check if the core idea works.

---

### Step 2: Album MVP

Build:

* Album list
* Album details
* Invite member
* Roles
* Upload multiple files
* View files

---

### Step 3: Download MVP

Build:

* Download one file
* Select files
* Save selected
* Save All
* Download progress

---

### Step 4: Soft Delete

Build:

* Delete own file
* Trash
* Restore own file
* 30-day delete rule

---

### Step 5: Notifications

Build:

* Store device tokens
* New invite notification
* New upload notification

---

### Step 6: Testing

Test with:

* Developer
* Girlfriend
* Close users

---

### Step 7: iOS TestFlight

Prepare:

* iOS permissions
* TestFlight build
* Invite testers

---

## 32. Architecture Decision Summary

Confirmed decisions:

* Frontend: Flutter
* Backend: Supabase
* Database: Supabase Postgres
* Authentication: Google Login only for V1
* Storage: LitratoLink-managed Google Drive / Google One-backed storage
* Push notifications: FCM/APNs delivery with Supabase backend control
* App type: Private cloud sharing
* Media: Photos and videos
* Quality: Original quality only
* Structure: Album-based
* Access: Invite-only
* Roles: Admin, Contributor, Viewer
* Delete: Soft delete for 30 days
* Restore: Original uploader only
* Release: TestFlight first, App Store later
* Future: Apple Login, Email Login, monetization, photographer mode, business mode, storage migration

---

## 33. Main Architecture Rule

The main architecture rule is:

**LitratoLink must always protect original quality and private album access.**

Every technical decision must support:

* Original file upload
* Original file download
* Private albums
* Simple user experience
* Clear permissions
* Future growth

If a technical choice makes the app harder to use, less private, or lowers quality, it should not be used in V1.

---

## 34. Next Recommended Document

The next recommended document is:

**LitratoLink Database Design Document v1.0**

This next document should define:

* Tables
* Columns
* Relationships
* Role rules
* RLS policies
* Delete rules
* Invite rules
* File metadata structure
* Notification tables
* Future monetization-ready tables
