# LitratoLink Development Roadmap v1.0

## 1. Document Purpose

This document explains the development roadmap for LitratoLink.

This document is based on:

* LitratoLink Master Product Plan v1.0
* LitratoLink System Architecture Document v1.0
* LitratoLink Database Design Document v1.0
* LitratoLink UI/UX Flow Document v1.0

The goal of this document is to define:

* What to build first
* What to build later
* What features are included in MVP
* What features are not included in V1
* How to test the app
* How to prepare for TestFlight
* How to prepare for App Store
* What future enhancements can be added later

---

## 2. App Summary

**App Name:** LitratoLink
**Tagline:** Share Memories in Original Quality
**Product Type:** Private cloud sharing app

LitratoLink allows users to create private albums, invite selected people, upload original-quality photos and videos, and download files without losing quality.

LitratoLink is not social media.

The app has:

* No likes
* No comments
* No followers
* No public feed
* No public profiles

The main goal is simple:

**Upload original files. Share privately. Download original files easily.**

---

## 3. Development Strategy

LitratoLink should not be built all at once.

The app should be built in clear phases.

Each phase must have a working result.

Recommended development approach:

1. Build the core proof of concept first.
2. Build the MVP.
3. Add important V1 features.
4. Test with real users.
5. Release on TestFlight.
6. Improve based on feedback.
7. Prepare for App Store.
8. Add future features only after the core app is stable.

---

## 4. Main Build Priority

The highest priority is the original-quality sharing flow.

The first working version must prove that the app can:

1. Log in with Google.
2. Create an album.
3. Upload an original photo.
4. Store file metadata.
5. Show the file inside the album.
6. Download the original file.

If this core flow works, the rest of the app can be built around it.

---

# 5. Phase 0: Project Preparation

## 5.1 Goal

Prepare all tools, accounts, and project setup before coding the main app.

## 5.2 Tasks

### Development Setup

Set up:

* Flutter project
* Supabase project
* Google Cloud project
* Google Drive API access
* Firebase project or notification setup for FCM
* GitHub repository
* Local environment files
* Staging environment
* Production environment later

### Branding Setup

Prepare:

* App name: LitratoLink
* Tagline: Share Memories in Original Quality
* Maroon-based color palette
* Temporary app icon if final logo is not ready yet
* Logo to be added later

### Project Folder Setup

Recommended folders:

* `lib/screens`
* `lib/widgets`
* `lib/services`
* `lib/models`
* `lib/providers`
* `lib/utils`
* `lib/config`
* `lib/features/auth`
* `lib/features/albums`
* `lib/features/uploads`
* `lib/features/downloads`
* `lib/features/invites`
* `lib/features/notifications`

## 5.3 Output

At the end of Phase 0:

* Flutter app opens successfully.
* Supabase is connected.
* Google login setup is ready.
* Project structure is clean.
* Environment files are prepared.

---

# 6. Phase 1: Core Proof of Concept

## 6.1 Goal

Prove that the main idea works.

This phase should not focus on perfect UI.

It should focus on the core technical flow.

## 6.2 Features to Build

### 6.2.1 Google Login

Build:

* Continue with Google button
* Supabase authentication
* User profile creation after login
* Logout

### 6.2.2 Create Album

Build:

* Create album form
* Save album to Supabase
* Add creator as Admin
* Show album in My Albums

### 6.2.3 Upload One Photo

Build:

* Select one photo
* Upload original file
* Store file in Google Drive-backed storage
* Save file metadata in Supabase

### 6.2.4 Show Uploaded Photo

Build:

* Album details screen
* File list or simple gallery
* Show uploaded photo preview

### 6.2.5 Download Original Photo

Build:

* Download button
* Backend permission check
* Download original file
* Save to device or local downloads

## 6.3 Rules

This phase must confirm:

* Upload does not compress the file.
* Download uses the original file.
* Album access is private.
* File metadata is saved correctly.

## 6.4 Output

At the end of Phase 1:

A logged-in user can:

1. Create an album.
2. Upload one original photo.
3. See it in the album.
4. Download the original file.

This is the first working proof that LitratoLink is possible.

---

# 7. Phase 2: Album MVP

## 7.1 Goal

Build the first usable version of albums.

## 7.2 Features to Build

### 7.2.1 Home / My Albums

Build:

* Album list
* Album cards
* Album file count
* Album member count
* User role display

### 7.2.2 Album Details

Build:

* Album header
* Gallery grid
* Upload button
* Save All button placeholder
* Members button
* Select button

### 7.2.3 Multiple File Upload

Build:

* Select multiple photos/videos
* Show selected files before upload
* Upload progress
* Failed upload retry
* Upload complete message

### 7.2.4 Photos and Videos

Support:

* Photo upload
* Video upload
* File type detection
* MIME type saving
* File size saving
* Video duration if possible

### 7.2.5 Basic Thumbnails

Build:

* Thumbnail or preview display
* Separate thumbnail from original file
* Never use thumbnail for download

## 7.3 Output

At the end of Phase 2:

A user can:

* See all their albums.
* Open an album.
* Upload many photos and videos.
* View uploaded files in a gallery.

---

# 8. Phase 3: Invite and Role System

## 8.1 Goal

Allow users to invite selected people to albums.

## 8.2 Features to Build

### 8.2.1 Members Screen

Build:

* Show album members
* Show member role
* Show member email
* Show joined date

### 8.2.2 Invite Member

Build:

* Invite by email
* Choose role
* Create invite record
* Show invite status

### 8.2.3 Pending Invites

Build:

* Invites screen
* Accept invite
* Decline invite
* Email match validation

### 8.2.4 Role Management

Build:

* Admin can change roles
* Admin can remove members
* Always keep at least one Admin

### 8.2.5 Permission Rules

Enforce:

* Admin can invite.
* Contributor cannot invite.
* Viewer cannot invite.
* Admin and Contributor can upload.
* Viewer can only view and download.
* Removed members lose access.

## 8.3 Output

At the end of Phase 3:

Users can:

* Create private albums.
* Invite other users.
* Assign roles.
* Control who can upload and download.

---

# 9. Phase 4: Download and Save All

## 9.1 Goal

Build the most important receiver feature: easy original-quality download.

## 9.2 Features to Build

### 9.2.1 Single Download

Build:

* Download Original button
* Permission check
* Original file download
* Save to device

### 9.2.2 Select Files

Build:

* Selection mode
* Select one or many files
* Select all
* Save selected files

### 9.2.3 Save All

Build:

* Save All button
* Confirmation message
* Download progress
* Retry failed downloads
* Success message

### 9.2.4 Save Destination

Mobile:

* Save to Photos / Gallery
* Save to Files if needed

PC/Web:

* Download file
* Download selected files
* Future ZIP option

## 9.3 Save All Rules

Save All must:

* Download original files.
* Never download thumbnails.
* Show progress.
* Handle large albums safely.
* Allow retry if some downloads fail.
* Warn users about device storage.

## 9.4 Output

At the end of Phase 4:

Receivers can:

* Download one file.
* Select files and download them.
* Tap Save All to download many original files.

This phase makes LitratoLink clearly better than manual Google Drive downloading.

---

# 10. Phase 5: Soft Delete and Restore

## 10.1 Goal

Prevent accidental permanent loss.

## 10.2 Features to Build

### 10.2.1 Delete Own File

Build:

* Delete button visible only to uploader
* Delete confirmation
* File disappears from album for everyone
* File moves to Trash

### 10.2.2 Trash Screen

Build:

* Show deleted files uploaded by current user
* Show restore deadline
* Show album name
* Show deleted date

### 10.2.3 Restore Own File

Build:

* Restore button
* Restore confirmation
* File returns to original album

### 10.2.4 30-Day Rule

Build:

* Delete expiration date
* Scheduled cleanup or manual cleanup logic
* Permanent delete after 30 days

## 10.3 Rules

* Only original uploader can delete their own file.
* Only original uploader can restore their own deleted file.
* Admin cannot restore another user’s file.
* Contributor cannot restore another user’s file.
* Viewer cannot delete or restore files.
* Deleted files are hidden from everyone.
* Deleted files are recoverable for 30 days.

## 10.4 Output

At the end of Phase 5:

Users can safely delete and restore their own uploaded files.

---

# 11. Phase 6: Notifications

## 11.1 Goal

Notify users about important album activity.

## 11.2 Features to Build

### 11.2.1 Device Token Registration

Build:

* Save device token
* Save platform
* Update token when changed
* Disable token on logout

### 11.2.2 Notification Types

Build notifications for:

* New album invite
* Invite accepted
* New upload
* Upload complete

### 11.2.3 Notification Screen

Build:

* List notifications
* Mark as read
* Tap to open related album

### 11.2.4 Grouped Upload Notification

If many files are uploaded, send one notification only.

Example:

**New photos were added to your album.**

Do not send one notification per file.

## 11.3 Privacy Rules

Notifications must not expose:

* Private file names
* Sensitive details
* Private descriptions

Good:

**New memories were added to your album.**

Bad:

**IMG_1234_private.jpg was uploaded.**

## 11.4 Output

At the end of Phase 6:

Users can receive helpful and private notifications.

---

# 12. Phase 7: UI Polish and Branding

## 12.1 Goal

Make the app feel clean, warm, and ready for testing.

## 12.2 Tasks

Build or improve:

* Splash screen
* Welcome screen
* Empty states
* Loading states
* Error states
* Maroon-based theme
* App icon
* Logo placement
* Button style
* Album card style
* Upload progress design
* Save All progress design

## 12.3 Branding Rules

Use:

* LitratoLink name
* Tagline: Share Memories in Original Quality
* Maroon-based color palette
* Warm and private feeling

Avoid:

* Social media style
* Too many icons
* Cluttered layout
* Public-feed feeling

## 12.4 Output

At the end of Phase 7:

The app should feel like a real private memory sharing app, not just a test project.

---

# 13. Phase 8: Internal Testing

## 13.1 Goal

Test the app before inviting other people.

## 13.2 Test Users

Start with:

* Developer
* Girlfriend

Then:

* 1 close friend
* 1 family member

## 13.3 Test Checklist

Test:

* Google login
* Create album
* Invite user
* Accept invite
* Upload photo
* Upload video
* Download one file
* Save All
* Delete own file
* Restore own file
* Role permissions
* Removed member access
* Notifications
* iPhone upload
* iPad download
* Android upload
* PC upload
* PC download

## 13.4 Important Quality Test

Compare:

* Original file size before upload
* Downloaded file size after download
* Original resolution
* Downloaded resolution

The downloaded file should match the original as much as possible.

## 13.5 Output

At the end of Phase 8:

The app should be stable enough for TestFlight testing.

---

# 14. Phase 9: TestFlight Release

## 14.1 Goal

Allow selected iOS users to test the app.

## 14.2 Requirements

Prepare:

* Apple Developer account
* App Store Connect app record
* iOS build
* App icon
* App name
* Short description
* Privacy information
* TestFlight tester emails

## 14.3 TestFlight Testers

Start with:

* Girlfriend
* Close friends
* Family

## 14.4 TestFlight Focus

Test:

* iPhone installation
* iPad installation
* Google Login on iOS
* Photo permission
* Save to Photos permission
* Notification permission
* Upload from iPhone
* Download to iPhone
* Save All on iPhone
* Save All on iPad

## 14.5 Output

At the end of Phase 9:

Selected iOS users can install and use LitratoLink through TestFlight.

---

# 15. Phase 10: Friends and Family Beta

## 15.1 Goal

Test with a small real group.

## 15.2 User Range

Recommended:

* 10 to 30 users first

Then:

* 30 to 50 users if stable

## 15.3 What to Observe

Observe:

* Do users understand the app?
* Can users create albums without help?
* Can users invite others?
* Can users upload easily?
* Can users Save All easily?
* Do users understand original quality?
* Are there upload failures?
* Are there download failures?
* Is storage usage growing too fast?
* Are notifications useful or annoying?

## 15.4 Output

At the end of Phase 10:

The app should be ready for App Store preparation if feedback is good.

---

# 16. Phase 11: App Store Preparation

## 16.1 Goal

Prepare LitratoLink for public App Store release.

## 16.2 Required Items

Prepare:

* Final app icon
* Final logo
* App screenshots
* App preview text
* App description
* Privacy policy
* Terms of use
* Support email
* Website or simple landing page
* App Store category
* Permission descriptions
* Data safety information

## 16.3 App Store Description Draft Direction

Simple description:

**LitratoLink helps you create private albums and share original-quality photos and videos with selected people. No social feed. No likes. No comments. Just private memories in original quality.**

## 16.4 Privacy Policy Must Explain

Privacy policy should explain:

* Users log in with Google.
* Albums are private.
* Only invited members can access albums.
* Photos and videos are stored for sharing.
* App may store file metadata.
* App may send push notifications.
* Users can delete their own uploaded files.
* Deleted files may be recoverable for 30 days.

## 16.5 Output

At the end of Phase 11:

LitratoLink is ready for App Store submission.

---

# 17. Phase 12: App Store Release

## 17.1 Goal

Release LitratoLink publicly or semi-publicly.

## 17.2 Release Strategy

Recommended:

### Soft Launch

Release to a small audience first.

Examples:

* Friends
* Family
* Small Filipino user group
* Small photography group

Do not immediately market it widely.

## 17.3 Monitor After Release

Monitor:

* Login errors
* Upload errors
* Download errors
* Storage usage
* Crash reports
* User feedback
* App Store review feedback

## 17.4 Output

At the end of Phase 12:

LitratoLink is live and usable by real users.

---

# 18. MVP Feature List

## 18.1 MVP Must Have

The MVP must include:

* Google Login
* User profile creation
* Create album
* Album list
* Album details
* Upload photos
* Upload videos
* Original quality storage
* File metadata
* Download original file
* Save All
* Invite by email
* Accept invite
* Roles: Admin, Contributor, Viewer
* Soft delete
* Restore own file
* Basic notifications
* iPhone/iPad support
* Android support
* Basic PC/Web support if possible

---

## 18.2 MVP Should Have

Nice but not required at the earliest MVP:

* Thumbnails
* Upload retry
* Download retry
* Notification screen
* Album cover
* Member role change
* Remove member
* Trash screen
* Better loading states

---

## 18.3 MVP Not Needed

Do not build in MVP:

* Likes
* Comments
* Followers
* Public profiles
* Public albums
* Social feed
* Chat
* AI tools
* Photo editing
* Premium plans
* Payment system
* Photographer mode
* Business dashboard
* White label

---

# 19. Suggested Sprint Plan

This sprint plan assumes each sprint focuses on one main goal.

Actual speed depends on developer time and testing.

---

## Sprint 1: Setup and Login

Build:

* Flutter project
* Supabase connection
* Google Login
* User profile creation
* Logout
* Basic navigation

Done when:

* User can log in and log out.

---

## Sprint 2: Albums Core

Build:

* Create album
* My Albums screen
* Album details screen
* Add creator as Admin
* Basic role display

Done when:

* User can create and open albums.

---

## Sprint 3: Storage Proof

Build:

* Google Drive storage connection
* Upload one original photo
* Save storage object record
* Save media file record
* Download original photo

Done when:

* Original upload and download works.

---

## Sprint 4: Multiple Uploads

Build:

* Select multiple files
* Upload progress
* Upload photos and videos
* Failed upload handling

Done when:

* User can upload many original files.

---

## Sprint 5: Gallery and Preview

Build:

* Album gallery grid
* Photo preview
* Video preview
* Basic thumbnail support

Done when:

* Album feels like a media album.

---

## Sprint 6: Invites and Members

Build:

* Members screen
* Invite by email
* Pending invites
* Accept invite
* Member roles

Done when:

* Users can share private albums.

---

## Sprint 7: Permissions and RLS

Build:

* Role permission checks
* Supabase RLS policies
* Upload permission
* Download permission
* Admin-only actions

Done when:

* Users cannot access unauthorized albums or files.

---

## Sprint 8: Download and Save All

Build:

* Download Original
* Select files
* Save Selected
* Save All
* Download progress
* Retry failed downloads

Done when:

* Receiver can easily save original files.

---

## Sprint 9: Delete and Restore

Build:

* Delete own file
* Trash screen
* Restore own file
* 30-day delete rule

Done when:

* Soft delete works correctly.

---

## Sprint 10: Notifications

Build:

* Device token registration
* New invite notification
* New upload notification
* Upload complete notification
* Notification screen

Done when:

* Users receive useful notifications.

---

## Sprint 11: UI Polish

Build:

* Final theme
* Maroon palette
* Empty states
* Error states
* Loading states
* App icon placeholder
* Logo placement

Done when:

* App feels ready for testing.

---

## Sprint 12: Testing and Bug Fixing

Build/Fix:

* iOS permission issues
* Android permission issues
* Upload bugs
* Download bugs
* Save All bugs
* Invite bugs
* Role bugs
* Storage problems

Done when:

* App is ready for TestFlight.

---

# 20. Testing Plan

## 20.1 Functional Testing

Test every main feature:

* Login
* Logout
* Create album
* Invite member
* Accept invite
* Upload
* Download
* Save All
* Delete
* Restore
* Change role
* Remove member
* Notifications

---

## 20.2 Permission Testing

Test each role.

### Admin

Should be able to:

* Upload
* Download
* Invite
* Manage members
* Rename album
* Delete album

### Contributor

Should be able to:

* Upload
* Download
* Delete own file
* Restore own file

Should not be able to:

* Invite
* Change roles
* Remove members
* Delete album

### Viewer

Should be able to:

* View
* Download
* Save All

Should not be able to:

* Upload
* Delete
* Restore
* Invite
* Manage members

---

## 20.3 Privacy Testing

Test:

* Non-member cannot see album.
* Removed member cannot see album.
* User cannot access private file link directly.
* User cannot see another user’s Trash.
* User cannot restore another user’s file.
* User cannot read another user’s notifications.

---

## 20.4 Original Quality Testing

For each uploaded file, compare:

* Original filename
* Original file size
* Original resolution
* Downloaded file size
* Downloaded resolution
* Video quality
* Video duration

The app should not silently reduce quality.

---

## 20.5 Device Testing

Test on:

* iPhone
* iPad
* Android phone
* PC browser or desktop
* Different internet speeds

---

## 20.6 Stress Testing

Test:

* Upload 50 files
* Upload 100 files
* Upload 300 files
* Save All with 50 files
* Save All with 100 files
* Large video upload
* Slow internet upload
* Interrupted download

---

# 21. Release Criteria

LitratoLink should not be released to TestFlight until:

* Google Login works.
* Create album works.
* Invite works.
* Upload original files works.
* Download original files works.
* Save All works.
* Basic permissions work.
* Soft delete works.
* Main iOS permissions work.
* App does not crash during normal use.

LitratoLink should not be released to App Store until:

* TestFlight feedback is good.
* Main bugs are fixed.
* Privacy policy is ready.
* App Store screenshots are ready.
* App icon is ready.
* Terms of use are ready.
* App review requirements are checked.

---

# 22. Future Enhancements

These are not part of V1.

They are only planned for future consideration.

## 22.1 Login Enhancements

Future:

* Apple Login
* Email Login
* Magic Link Login

Priority:

* Low for V1
* Medium after App Store release

---

## 22.2 Monetization

Future:

* Premium plan
* Family plan
* Couple plan
* Lifetime plan
* Storage add-ons
* Business plan

Priority:

* Not for V1
* Consider only after real user demand

---

## 22.3 Photographer Mode

Future:

* Client albums
* Download tracking
* Watermark previews
* Expiring album links
* Client delivery page

Priority:

* Not for V1
* Good future business feature

---

## 22.4 Business Mode

Future:

* Team albums
* Department albums
* Company event sharing
* Admin dashboard

Priority:

* Not for V1

---

## 22.5 White Label

Future:

* Custom branding
* Custom domain
* Studio-branded portal
* Organization-branded sharing

Priority:

* Long-term only

---

## 22.6 Storage Upgrade

Future:

* Google Cloud Storage
* Cloudflare R2
* Supabase Storage
* Hybrid storage provider

Priority:

* Only if Google One-backed setup becomes limiting

---

## 22.7 ZIP Download

Future:

* Download selected as ZIP
* Download album as ZIP

Priority:

* Medium for PC/Web
* Not required for first MVP

---

# 23. Main Risks and Mitigation

## 23.1 Google Drive API Risk

Risk:

Google Drive API setup may be complex.

Solution:

Build storage proof of concept early in Sprint 3.

---

## 23.2 iOS Permission Risk

Risk:

iOS may block or limit photo saving if permissions are not handled well.

Solution:

Test on iPhone and iPad early.

---

## 23.3 Save All Risk

Risk:

Save All may fail for large albums.

Solution:

Download in safe batches, show progress, and allow retry.

---

## 23.4 Storage Full Risk

Risk:

LitratoLink-managed Google storage may become full.

Solution:

Track storage usage and prepare future storage upgrade.

---

## 23.5 Privacy Risk

Risk:

Users may expect stronger privacy if the app becomes public.

Solution:

Keep clear privacy policy and strong album permissions.

---

## 23.6 Scope Creep Risk

Risk:

The app may become too big too early.

Solution:

Do not build social features, payment features, or business features in V1.

---

# 24. Development Rules

These rules must be followed during development.

## 24.1 Original Quality Rule

Never compress, resize, or convert the original uploaded file.

## 24.2 Private Album Rule

Only invited album members can access album files.

## 24.3 Backend Permission Rule

Never rely only on frontend UI for security.

## 24.4 Simple UX Rule

The app must stay easy to use.

## 24.5 No Social Media Rule

Do not add likes, comments, followers, or public feeds.

## 24.6 Storage Adapter Rule

Do not hard-code the app in a way that makes future storage migration impossible.

## 24.7 Future-Ready Rule

Prepare for monetization and storage upgrade later, but do not fully implement them in V1.

---

# 25. Final Roadmap Summary

Recommended order:

1. Project setup
2. Google Login
3. Album creation
4. Google Drive storage proof
5. Original upload and download
6. Album gallery
7. Invite system
8. Roles and permissions
9. Save All
10. Soft delete and restore
11. Push notifications
12. UI polish
13. Internal testing
14. TestFlight
15. Friends and family beta
16. App Store preparation
17. App Store release
18. Future enhancements later

---

# 26. Current Project Status

The project now has:

* Master Product Plan
* System Architecture Document
* Database Design Document
* UI/UX Flow Document
* Development Roadmap

The next recommended document is:

**LitratoLink Codex Development Instructions v1.0**

This next document should explain how Codex or an AI coding assistant should build the project step by step, including rules, coding style, folder structure, and what not to change.
