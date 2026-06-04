# Potoos Master Product Plan v1.0

## 1. Project Name

**App Name:** Potoos
**Tagline:** Share Memories in Original Quality

## 2. Executive Summary

Potoos is a private photo and video sharing app.

The main goal of Potoos is to help users share photos and videos with selected people without losing quality.

Many people use Messenger, Viber, WhatsApp, or other messaging apps to send photos. The problem is that these apps often compress photos and videos. The quality becomes lower. Google Drive can keep original quality, but it can feel hard to use because users need to open folders, find files, download one by one, and manage links.

Potoos solves this problem by making the process simple:

1. Create an album.
2. Invite selected people.
3. Upload original quality photos and videos.
4. Receiver opens the app.
5. Receiver can download one by one or tap **Save All**.

Potoos is not a social media app. It has no likes, no comments, no followers, and no public feed. It is a private cloud sharing app for memories.

---

## 3. Problem Statement

People want to share important photos and videos with family, friends, partners, and selected people.

But current solutions have problems:

### Messaging Apps

Examples: Messenger, Viber, WhatsApp, Telegram normal photo sending

Problems:

* Photos may be compressed.
* Videos may lose quality.
* Files are mixed with chats.
* It is hard to organize memories.
* Old photos can be hard to find.

### Google Drive

Problems:

* Original quality is possible, but the steps are not simple.
* Users may need to download files one by one.
* Folder sharing can be confusing.
* It does not feel like a photo sharing app.
* It is not designed for simple private memory sharing.

### Google Photos

Problems:

* It is good for photo backup and sharing, but some users may not fully understand original quality settings.
* It is not always clear if files are kept as original files.
* It is not focused only on private album sharing.

### Social Media

Examples: Facebook, Instagram

Problems:

* Photos and videos may be compressed.
* It is too public.
* It is not made for private original file sharing.
* It has likes, comments, and social features that are not needed.

---

## 4. Vision Statement

Potoos aims to become the simplest way to share original-quality photos and videos with the people who matter most.

---

## 5. Mission Statement

Potoos helps users share memories easily, privately, and in original quality.

---

## 6. Product Identity

Potoos is:

* A private cloud sharing app.
* An original-quality photo and video sharing app.
* An album-based sharing app.
* An invite-only memory sharing platform.

Potoos is not:

* A social media app.
* A public photo feed.
* A messaging app.
* A Google Drive clone.
* A photo editing app.

---

## 7. Target Users

### Primary Users

#### Couples

For partners who want to share original-quality memories with each other.

Example:

* Dates
* Travel photos
* Anniversaries
* Random daily memories

#### Families

For families who want to share photos and videos privately.

Example:

* Family events
* Birthdays
* Reunions
* Children’s photos
* OFW family sharing

#### Friends

For small friend groups who want to share original files.

Example:

* Trips
* Events
* Parties
* School memories

---

### Secondary Users for Future

These users are not the main focus of V1, but they may be added in the future.

#### Photographers

Photographers can create private client albums.

#### Schools and Organizations

Schools can share event photos with students or parents.

#### Small Businesses

Businesses can share event documentation or internal media.

#### Event Teams

Event teams can distribute original files to clients or members.

---

## 8. Core Value Proposition

Potoos gives users:

1. Original-quality uploads.
2. Original-quality downloads.
3. Private albums.
4. Invite-only access.
5. Easy upload and download process.
6. Cross-platform access.
7. Clean and simple experience.

Main promise:

**“Send and receive memories without losing quality.”**

---

## 9. Core Product Direction

The product direction is:

**Private Cloud Sharing**

This means:

* No public feed.
* No public profiles.
* No social discovery.
* No likes.
* No comments.
* No followers.
* No algorithm.
* No explore page.

The app should feel private, simple, and safe.

---

## 10. V1 Main Goal

The V1 goal is to build the simplest working version of Potoos.

V1 should allow users to:

1. Log in using Google.
2. Create albums.
3. Invite people to albums.
4. Upload original photos and videos.
5. View album media.
6. Download selected files.
7. Use **Save All**.
8. Receive push notifications.
9. Manage simple album roles.
10. Delete and restore their own uploaded files within 30 days.

---

## 11. V1 Priority Features

### 11.1 Google Login Only

For V1, users can log in using Google only.

Reason:

* Simple setup.
* Works across iPhone, Android, iPad, and PC.
* Less development work.
* Easy identity management.

Future login options will be listed under Future Enhancements.

---

### 11.2 Album-Based Structure

Potoos will be based on albums.

Users do not upload to one giant storage area. Users upload inside albums.

Examples:

* Me and GF
* Family
* Friends
* Travel
* Birthday
* School Event

Each album has its own:

* Name
* Members
* Roles
* Files
* Permissions

---

### 11.3 Users Can Create Their Own Albums

Every user can create their own albums.

Example:

User A can create:

* Family
* Travel
* Friends

User B can create:

* School
* Work
* Best Friends

When a user creates an album, that user becomes the **Album Admin**.

---

### 11.4 Private Albums by Default

All albums are private by default.

An album cannot be seen by other users unless they are invited.

There will be no public album search.

There will be no public album listing.

---

### 11.5 Invite System

Album admins can invite people by email.

Invite flow:

1. Admin creates an album.
2. Admin enters the email of the person to invite.
3. The invited person receives an invite.
4. The person logs in.
5. The person joins the album.
6. The person can only see albums where they are a member.

---

## 12. User Roles

Each album has roles.

A user can have a different role in different albums.

Example:

* User can be Admin in their own album.
* Same user can be Viewer in another person’s album.

---

### 12.1 Admin

The Admin controls the album.

Admin can:

* View files.
* Download files.
* Upload files.
* Invite members.
* Remove members.
* Change member roles.
* Rename album.
* Delete album.
* Manage album settings.

Important rule:

The Admin is not always the app owner or developer.

The Admin means the person who created the album or someone promoted as Admin.

---

### 12.2 Contributor

Contributor can:

* View files.
* Download files.
* Upload files.
* Delete their own uploaded files.
* Restore their own deleted files within 30 days.

Contributor cannot:

* Invite members.
* Remove members.
* Change roles.
* Delete album.
* Restore files uploaded by other users.

---

### 12.3 Viewer

Viewer can:

* View files.
* Download files.
* Use Save All.

Viewer cannot:

* Upload files.
* Invite members.
* Remove members.
* Delete files.
* Restore files.

---

## 13. Upload Rules

Users can upload:

* Photos
* Videos

V1 will support original quality only.

This means:

* The app must upload the original file.
* The app must not compress the file.
* The app must not resize the file.
* The app must not convert the file.
* The app must preserve the original file as much as possible.

The app may create a smaller thumbnail or preview for faster viewing, but the original file must remain unchanged.

---

## 14. Download Rules

Users can download:

* One file at a time.
* Selected files.
* All files in an album using **Save All**.

Download must use the original file.

The downloaded file must not use the thumbnail or preview file.

---

## 15. Save All Feature

The **Save All** feature is one of the most important features of Potoos.

Purpose:

To avoid downloading files one by one.

Save All should allow a user to save all album files or selected files.

For mobile:

* Save to phone gallery if allowed by device permission.
* Save to Files if needed.

For PC:

* Download as files.
* Future option: download as ZIP.

V1 must prioritize simple and reliable downloading.

---

## 16. Storage Plan for V1

V1 will use a Potoos-managed Google Drive / Google One-backed storage setup.

This means:

* Users do not need to connect their own Google Drive.
* Users do not need their own Google One subscription.
* Users do not need to manage storage folders.
* Users only use the Potoos app.

Reason:

If every user needs their own Google Drive storage, the app becomes harder to use.

Problems with user-owned storage:

* Some users only have free Google storage.
* Some users may have full storage.
* Some users may not understand Google Drive permissions.
* Uploads may fail because of storage limits.
* It removes the simple “upload and done” experience.

For V1, Potoos should manage the storage layer.

Future storage upgrade options can be added later.

---

## 17. Storage Rules

### 17.1 Original File Must Be Preserved

Every uploaded photo or video must be stored as the original file.

### 17.2 Thumbnail Is Separate

If the app creates a thumbnail, the thumbnail must be stored separately.

The thumbnail must never replace the original file.

### 17.3 File Metadata Must Be Saved

The app should store metadata such as:

* File name
* File type
* File size
* Album ID
* Uploader ID
* Upload date
* Original storage path
* Thumbnail path if available

### 17.4 No App-Level File Size Limit for V1

V1 will not set an app-level file size limit.

Real limits will depend on:

* Storage quota
* Google Drive API rules
* Device capability
* Internet connection

---

## 18. Soft Delete Policy

Potoos will use soft delete.

This means deleted files are not permanently deleted immediately.

### 18.1 Delete Rule

Only the original uploader can delete their own uploaded file.

When the uploader deletes a file:

* The file disappears from the album for everyone.
* The file goes to Trash.
* The file stays in Trash for 30 days.

### 18.2 Restore Rule

Only the original uploader can restore the file.

Album Admin cannot restore files uploaded by other users.

Contributor cannot restore files uploaded by other users.

Viewer cannot restore files.

### 18.3 Permanent Delete Rule

After 30 days, the file may be permanently deleted.

Once permanently deleted, it cannot be restored.

### 18.4 Restore Behavior

When a file is restored:

* It returns to the original album.
* It becomes visible again to album members.
* The original upload date and uploader info should remain.

---

## 19. Album Delete Policy

Only Album Admin can delete an album.

When an album is deleted:

* Album access is removed.
* Album files should be moved to album trash or marked as deleted.
* Final deletion rules should be reviewed during technical planning.

V1 should handle album deletion carefully to avoid accidental loss.

Recommended V1 approach:

* Ask for confirmation before deleting an album.
* Use soft delete for albums.
* Keep deleted albums recoverable for a limited time.

---

## 20. Push Notifications

Potoos should support push notifications.

Example notifications:

* “A new album was shared with you.”
* “New photos were added to Family.”
* “New videos were added to Me and GF.”
* “You were invited to an album.”
* “Your upload is complete.”

Recommended notification system:

* Supabase stores user devices and notification preferences.
* FCM can be used to deliver push notifications.
* Supabase Edge Functions can trigger notification sending.

Push notifications should not reveal private file content.

Bad notification:

* “Your girlfriend uploaded private_photo.jpg”

Better notification:

* “New photos were added to your album.”

---

## 21. Privacy Rules

Privacy is one of the most important parts of Potoos.

Rules:

1. Albums are private by default.
2. Only invited members can access an album.
3. Users can only see albums where they are members.
4. Users cannot search public albums.
5. Users cannot access files from albums they are not part of.
6. File download must check permission first.
7. Album roles must be enforced in the backend.
8. The app should not rely only on frontend hiding.
9. Supabase Row Level Security should be used.
10. Private files should not be exposed through public links without protection.

---

## 22. Security Rules

Basic security rules:

1. Every user must log in.
2. Every album request must check membership.
3. Every file request must check album access.
4. Every upload must check role permission.
5. Every delete request must check uploader ownership.
6. Every restore request must check uploader ownership.
7. Admin actions must check Admin role.
8. Sensitive keys must not be stored in the app frontend.
9. Storage actions should be handled securely.
10. Logs should not expose private file data.

---

## 23. Platform Support

Potoos should support:

### V1 Priority

* Android
* iPhone
* iPad
* Web or PC access if possible

### Main Framework

* Flutter

Reason:
Flutter can support:

* Android
* iOS
* iPadOS
* Web
* Desktop

V1 should prioritize mobile first.

---

## 24. iOS Access Plan

For iOS, the app can be tested first through TestFlight.

Release order:

1. Internal testing
2. TestFlight testing
3. Friends and family testing
4. App Store release

iOS will need permission for:

* Photo access
* Saving to Photos
* Notifications

Permission messages should be simple and clear.

Example:

“Potoos needs photo access so you can upload and save original-quality memories.”

---

## 25. Branding Direction

### App Name

Potoos

### Tagline

Share Memories in Original Quality

### Brand Feel

The app should feel:

* Private
* Warm
* Simple
* Clean
* Trustworthy
* Filipino-friendly
* Memory-focused

### Color Direction

Maroon-based palette.

Suggested style:

* Primary color: Deep Maroon
* Secondary color: Warm Cream
* Accent color: Soft Gold
* Background: Off White
* Text: Dark Brown or Near Black

The logo will be provided later.

---

## 26. UI/UX Direction

The app should be very simple.

Main tabs or screens:

1. Login
2. Home / My Albums
3. Album Details
4. Upload
5. Select Files
6. Save All
7. Members
8. Settings

The app should avoid clutter.

The main user flow must be:

### Sender Flow

1. Open app.
2. Select album.
3. Tap upload.
4. Select photos/videos.
5. Upload.
6. Done.

### Receiver Flow

1. Open app.
2. See new upload.
3. Open album.
4. View files.
5. Tap Save All or select files.
6. Done.

---

## 27. V1 Non-Goals

These will not be built in V1:

* Likes
* Comments
* Followers
* Public profiles
* Public albums
* Social feed
* Explore page
* Messaging
* Photo editing
* AI editing
* Filters
* Marketplace
* Payment system
* Premium subscriptions
* Photographer dashboard
* White-label system

These may be considered later, but they are not part of V1.

---

## 28. Future Enhancements

These are not part of V1. They are only planned for future consideration.

### 28.1 Login Enhancements

Future options:

* Apple Login
* Email Login
* Magic Link Login

### 28.2 Monetization

Future options:

* Premium plan
* Family plan
* Couple plan
* Lifetime plan
* Storage add-ons
* Business plan

### 28.3 Couple Features

Future options:

* Couple timeline
* Anniversary memories
* Private couple vault
* Shared calendar memories

### 28.4 Family Features

Future options:

* Family albums
* Family timeline
* Grandparent-friendly view
* Family plan

### 28.5 Photographer Mode

Future options:

* Client albums
* Password protected albums
* Download tracking
* Watermark preview
* Expiring album links

### 28.6 Business / Organization Mode

Future options:

* Team albums
* Company event albums
* Department-based access
* Admin dashboard

### 28.7 White Label

Future options:

* Custom branding
* Custom domain
* Studio-branded app or portal
* Business client dashboard

### 28.8 Storage Upgrade

Future storage options:

* Google Cloud Storage
* Cloudflare R2
* Supabase Storage
* Hybrid storage system

V1 will continue with Google One-backed storage unless technical limits require a change.

---

## 29. Monetization Ideas for the Future

Monetization should not be implemented in V1.

But the database and architecture should be designed so monetization can be added later without rebuilding the app.

Possible income sources:

### 29.1 Premium Subscription

Users can pay for more features.

Example premium features:

* More albums
* More members
* More storage
* Priority upload
* Advanced privacy settings

### 29.2 Family Plan

A paid plan for families.

Example:

* More members
* Shared family space
* More storage
* Family archive

### 29.3 Couple Plan

A paid plan for couples.

Example:

* Couple vault
* Anniversary timeline
* Relationship memories

### 29.4 Photographer Plan

A paid plan for photographers.

Example:

* Client albums
* Download tracking
* Watermark preview
* Branded album pages

### 29.5 White Label

Businesses can use Potoos under their own brand.

Example:

* Wedding studio
* School
* Event company
* Photography business

This can become a strong business model in the future.

---

## 30. Suggested Database Concepts

This is not the final database design yet.

Possible tables:

### users

Stores user profile information.

### albums

Stores album information.

### album_members

Stores who can access each album and what role they have.

### files

Stores uploaded file records.

### deleted_files

Stores soft deleted file records or delete status.

### invites

Stores album invitations.

### devices

Stores user device tokens for push notifications.

### notifications

Stores notification history.

### future_subscriptions

Reserved for future monetization.

### future_plans

Reserved for future monetization.

---

## 31. Suggested Technical Stack

### Frontend

Flutter

### Backend

Supabase

### Database

Supabase Postgres

### Authentication

Google Login through Supabase Auth

### Storage

Google Drive / Google One-backed storage for V1

### Push Notifications

FCM with Supabase Edge Functions

### Security

Supabase Row Level Security

---

## 32. Development Phases

### Phase 1: Product Planning

Create:

* Master Product Plan
* System Architecture Document
* Database Design
* UI/UX Flow
* Development Roadmap

### Phase 2: MVP Development

Build:

* Login
* Album creation
* Invite system
* Upload
* View album
* Download one by one
* Basic permissions

### Phase 3: Core Completion

Build:

* Save All
* Push notifications
* Soft delete
* Restore
* Member management
* Better album settings

### Phase 4: Testing

Test with:

* Developer
* Girlfriend
* Close friends
* Family

### Phase 5: iOS TestFlight

Release app through TestFlight.

### Phase 6: App Store Preparation

Prepare:

* App Store listing
* Privacy policy
* App icons
* Screenshots
* Terms of use
* App review requirements

### Phase 7: Public Release

Release when stable.

---

## 33. Success Metrics

Potoos is successful if:

1. Users can upload original quality photos and videos.
2. Receivers can download original files easily.
3. Albums stay private.
4. Invites work correctly.
5. Save All works reliably.
6. Users do not need to manage Google Drive manually.
7. The app feels easier than Google Drive.
8. The app does not feel like social media.
9. Users understand how to use it without long instructions.
10. The system can grow later without rebuilding everything.

---

## 34. Main Product Rule

Potoos must always protect the main promise:

**Share memories in original quality with selected people only.**

Every future feature must follow this rule.

If a feature makes the app:

* harder to use,
* less private,
* more like social media,
* or risks lowering quality,

then it should not be added to V1.

---

## 35. Final V1 Decision Summary

Confirmed V1 decisions:

* App name: Potoos
* Tagline: Share Memories in Original Quality
* Product type: Private cloud sharing app
* No social feed
* No likes
* No comments
* No followers
* Album-based structure
* Users can create their own albums
* Private albums by default
* Google Login only for V1
* Future Apple Login and Email Login
* Photos and videos supported
* Original quality only
* No app-level file size limit
* Potoos-managed Google One-backed storage for V1
* Supabase backend
* Flutter frontend
* Push notifications supported
* Viewer, Contributor, and Admin roles
* Soft delete for 30 days
* Only original uploader can restore deleted files
* TestFlight first
* App Store later
* Monetization only as future enhancement

---

## 36. Current Project Status

The product vision is clear.

The next recommended document is:

**Potoos System Architecture Document v1.0**

After that:

1. Database Design Document
2. UI/UX Flow Document
3. Development Roadmap
4. Codex Development Instructions
5. API and Technical Documentation
