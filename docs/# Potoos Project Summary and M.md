# Potoos Project Summary and Master Index v1.0

## 1. Document Purpose

This document is the master index for the Potoos project.

It summarizes all planning documents created so far.

The purpose of this document is to help organize the project before development starts.

This document should help the developer, Codex, or any AI coding assistant understand:

* What Potoos is
* What documents exist
* What each document is for
* What decisions are already confirmed
* What is included in V1
* What is future only
* What should be done next

---

## 2. Project Name

**Potoos**

## 3. Tagline

**Share Memories in Original Quality**

---

## 4. Product Summary

Potoos is a private photo and video sharing app.

It allows users to:

* Create private albums
* Invite selected people
* Upload original-quality photos and videos
* View shared albums
* Download original files
* Use Save All
* Delete and restore their own uploaded files

Potoos is designed to be simple.

The app is not social media.

Potoos has:

* No public feed
* No likes
* No comments
* No followers
* No public profiles
* No public album search

The main idea is:

**Private albums. Original quality. Easy sharing.**

---

## 5. Main Problem Potoos Solves

Many people send photos and videos using chat apps.

The problem is:

* Photos may be compressed.
* Videos may lose quality.
* Files are mixed with messages.
* Old files are hard to find.
* Downloading from Google Drive can feel slow or manual.
* Sharing with selected people can be confusing.

Potoos solves this by giving users a simple private album system where original-quality files can be shared and saved easily.

---

## 6. Main Product Promise

The main promise of Potoos is:

**Share memories in original quality with selected people only.**

Every feature must support this promise.

If a feature makes the app harder to use, less private, or lowers file quality, it should not be added to V1.

---

# PART A: MASTER DOCUMENT INDEX

---

## 7. Document 1: Master Product Plan

### Document Name

**Potoos Master Product Plan v1.0**

### Purpose

This is the main source-of-truth product document.

It explains:

* What Potoos is
* What problem it solves
* Who it is for
* What features are included in V1
* What is not included in V1
* Product vision
* Product direction
* Target users
* Future enhancements
* Monetization ideas

### When to Use This Document

Use this document when making product decisions.

If there is confusion about whether a feature belongs in V1, check the Master Product Plan first.

---

## 8. Document 2: System Architecture Document

### Document Name

**Potoos System Architecture Document v1.0**

### Purpose

This document explains the technical structure of the app.

It explains:

* Flutter frontend
* Supabase backend
* Supabase database
* Google Drive / Google One-backed storage
* Push notifications
* Authentication
* Upload flow
* Download flow
* Save All flow
* Soft delete flow
* Security rules
* Privacy rules
* Future storage adapter idea

### When to Use This Document

Use this document before building the technical structure.

It helps explain how the app parts connect.

---

## 9. Document 3: Database Design Document

### Document Name

**Potoos Database Design Document v1.0**

### Purpose

This document explains the planned database design.

It includes:

* Tables
* Columns
* Relationships
* User roles
* Album permissions
* File metadata
* Invite rules
* Notification tables
* Soft delete rules
* Future monetization tables

### When to Use This Document

Use this before creating Supabase tables.

It helps define what data the app needs.

---

## 10. Document 4: UI/UX Flow Document

### Document Name

**Potoos UI/UX Flow Document v1.0**

### Purpose

This document explains what users see and how users move through the app.

It includes:

* Main screens
* Login flow
* Album flow
* Upload flow
* Download flow
* Save All flow
* Invite flow
* Trash flow
* Permission messages
* Error messages
* Mobile rules
* PC/Web rules

### When to Use This Document

Use this before designing or coding the app interface.

It helps make sure the app stays simple and easy to use.

---

## 11. Document 5: Development Roadmap

### Document Name

**Potoos Development Roadmap v1.0**

### Purpose

This document explains the build order.

It includes:

* Project preparation
* Proof of concept
* MVP development
* Invite system
* Save All
* Soft delete
* Notifications
* UI polish
* TestFlight
* App Store release
* Future enhancements

### When to Use This Document

Use this to decide what to build first, next, and later.

It prevents building too many features too early.

---

## 12. Document 6: Codex Development Instructions

### Document Name

**Potoos Codex Development Instructions v1.0**

### Purpose

This document gives clear instructions for Codex or any AI coding assistant.

It includes:

* Product rules
* Coding rules
* Folder structure
* What Codex must do
* What Codex must not do
* Original quality rules
* Privacy rules
* Role rules
* Development order
* Testing instructions

### When to Use This Document

Use this when asking Codex or an AI coding assistant to create or edit code.

This document should be included in the development prompt.

---

## 13. Document 7: API and Edge Functions Specification

### Document Name

**Potoos API and Edge Functions Specification v1.0**

### Purpose

This document explains backend functions.

It includes:

* Edge Function names
* Request bodies
* Response bodies
* Error codes
* Permission checks
* Upload session flow
* Complete upload flow
* Download access flow
* Invite flow
* Delete and restore flow
* Notification flow

### When to Use This Document

Use this when creating Supabase Edge Functions and backend logic.

---

## 14. Document 8: Supabase SQL and RLS Planning Document

### Document Name

**Potoos Supabase SQL and RLS Planning Document v1.0**

### Purpose

This document prepares the Supabase implementation.

It includes:

* Table creation plan
* Enum values
* Helper functions
* RLS policy plan
* Indexes
* Triggers
* Cleanup jobs
* Seed data
* Implementation order

### When to Use This Document

Use this before writing actual SQL.

It helps make sure the database is secure and organized.

---

## 15. Document 9: App Store and TestFlight Preparation Document

### Document Name

**Potoos App Store and TestFlight Preparation Document v1.0**

### Purpose

This document explains how to prepare for iOS testing and App Store release.

It includes:

* Apple Developer account needs
* App Store Connect setup
* TestFlight plan
* App Store listing draft
* Screenshots
* App icon
* Privacy policy needs
* Terms of use needs
* App review notes
* iOS permission text
* Release checklist

### When to Use This Document

Use this before TestFlight and App Store submission.

---

## 16. Document 10: Privacy Policy and Terms Planning Document

### Document Name

**Potoos Privacy Policy and Terms Planning Document v1.0**

### Purpose

This document prepares privacy and terms content.

It includes:

* Data collected
* Why data is collected
* How albums work
* How photos and videos are stored
* Third-party services
* Delete and restore policy
* User responsibilities
* Prohibited use
* App Store privacy planning
* Google OAuth privacy planning

### When to Use This Document

Use this before creating the final public Privacy Policy and Terms of Use.

---

## 17. Document 11: MVP Checklist and Testing Plan

### Document Name

**Potoos MVP Checklist and Testing Plan v1.0**

### Purpose

This document explains how to test the app before release.

It includes:

* MVP feature checklist
* Authentication testing
* Album testing
* Invite testing
* Role testing
* Upload testing
* Download testing
* Save All testing
* Original quality testing
* Device testing
* Bug report format
* TestFlight readiness checklist
* App Store readiness checklist

### When to Use This Document

Use this during testing and before TestFlight release.

---

# PART B: CONFIRMED PRODUCT DECISIONS

---

## 18. Confirmed App Identity

* App name: Potoos
* Tagline: Share Memories in Original Quality
* App type: Private cloud sharing app
* Main color direction: Maroon-based palette
* Logo: To be provided later

---

## 19. Confirmed Product Direction

Potoos is:

* Private
* Album-based
* Invite-only
* Original-quality focused
* Simple and clean

Potoos is not:

* Social media
* Messaging app
* Google Drive clone
* Photo editing app
* Public content platform

---

## 20. Confirmed V1 Features

V1 should include:

* Google Login only
* User profiles
* Create albums
* Private albums by default
* Invite members by email
* Roles: Admin, Contributor, Viewer
* Upload photos
* Upload videos
* Original-quality storage
* Gallery view
* Download Original
* Save All
* Select files
* Soft delete
* Restore own deleted files within 30 days
* Basic push notifications
* iPhone support
* iPad support
* Android support
* PC/Web support if possible
* TestFlight first
* App Store later

---

## 21. Confirmed Non-Goals for V1

V1 must not include:

* Likes
* Comments
* Followers
* Public profiles
* Public albums
* Public feed
* Explore page
* Chat
* Photo editing
* AI editing
* Payment system
* Premium plans
* Photographer mode
* Business dashboard
* White label system

These are not part of the first version.

---

## 22. Confirmed Technology Stack

### Frontend

Flutter

### Backend

Supabase

### Database

Supabase Postgres

### Authentication

Google Login only for V1

### Storage

Potoos-managed Google Drive / Google One-backed storage for V1

### Notifications

Supabase for records and device tokens
FCM/APNs delivery if needed

### Security

Supabase Row Level Security

---

## 23. Confirmed User Roles

### Admin

Can:

* View album
* View files
* Download files
* Upload files
* Invite members
* Remove members
* Change roles
* Rename album
* Delete album
* Delete own uploaded files
* Restore own deleted files

Cannot:

* Restore files uploaded by other users
* Delete files uploaded by other users in V1

---

### Contributor

Can:

* View album
* View files
* Download files
* Upload files
* Delete own uploaded files
* Restore own deleted files

Cannot:

* Invite members
* Remove members
* Change roles
* Rename album
* Delete album
* Delete other users’ files
* Restore other users’ files

---

### Viewer

Can:

* View album
* View files
* Download files
* Use Save All

Cannot:

* Upload files
* Invite members
* Remove members
* Change roles
* Rename album
* Delete album
* Delete files
* Restore files

---

## 24. Confirmed Delete and Restore Rule

Potoos uses soft delete.

Rules:

* Only the original uploader can delete their own uploaded file.
* Deleted file disappears from the album for everyone.
* Deleted file goes to uploader’s Trash.
* Only original uploader can restore it.
* Restore period is 30 days.
* After 30 days, file may be permanently deleted.
* Admin cannot restore another user’s file.
* Viewer cannot delete or restore files.

---

## 25. Confirmed Storage Rule

For V1:

* Potoos manages storage.
* Users do not need their own Google One subscription.
* Users do not need to connect their own Google Drive.
* Users only use the app.

Important:

The app must not compress, resize, or convert original files.

The app may create thumbnails, but thumbnails must be separate.

Download and Save All must use original files.

---

## 26. Confirmed Release Plan

Release order:

1. Internal testing
2. TestFlight testing
3. Friends and family beta
4. App Store soft launch
5. Wider release later if stable

---

# PART C: FUTURE ENHANCEMENTS

---

## 27. Future Login Enhancements

Not part of V1.

Possible future login options:

* Apple Login
* Email Login
* Magic Link Login

---

## 28. Future Monetization

Not part of V1.

Possible future income sources:

* Premium plan
* Family plan
* Couple plan
* Lifetime plan
* Storage add-ons
* Photographer plan
* Business plan
* White label plan

The system should be designed so these can be added later without rebuilding everything.

---

## 29. Future Business Features

Not part of V1.

Possible future features:

* Photographer mode
* Client albums
* Download tracking
* Watermark previews
* Expiring album links
* Business dashboard
* Organization albums
* White-label branding
* Custom domain

---

## 30. Future Storage Enhancements

Not part of V1.

Possible future storage options:

* Google Cloud Storage
* Cloudflare R2
* Supabase Storage
* Hybrid storage provider

Important:

V1 should use a storage adapter idea so future migration is easier.

---

## 31. Future Privacy Enhancements

Not part of V1.

Possible future features:

* Stronger audit logs
* User-owned storage option
* Business storage separation
* End-to-end encryption
* Advanced account deletion
* Report and abuse handling tools

---

# PART D: MASTER DEVELOPMENT ORDER

---

## 32. Recommended Build Order

Build in this order:

1. Project setup
2. Flutter app structure
3. Supabase setup
4. Google Login
5. User profile creation
6. Create album
7. My Albums screen
8. Album Details screen
9. Google Drive storage proof
10. Upload one original photo
11. Download one original photo
12. Multiple uploads
13. Gallery and thumbnails
14. Invite system
15. Role and permission system
16. Save All
17. Soft delete and restore
18. Push notifications
19. UI polish
20. Internal testing
21. TestFlight
22. Friends and family beta
23. App Store preparation
24. App Store release

---

## 33. Minimum Working App

The minimum working app must allow:

1. User logs in with Google.
2. User creates an album.
3. User uploads one original photo.
4. User sees the photo in the album.
5. User downloads the original photo.
6. Downloaded file keeps original quality.

This must work before building advanced features.

---

## 34. MVP Completion Rule

The MVP is complete only when:

* Login works.
* Albums work.
* Invites work.
* Roles work.
* Upload works.
* Download works.
* Save All works.
* Soft delete works.
* Restore works.
* Original quality is preserved.
* Private album access is enforced.
* iOS testing passes.
* Android testing passes.
* No critical privacy bugs remain.

---

# PART E: MAIN RISKS

---

## 35. Google Drive API Risk

Risk:

Google Drive API setup may be complex.

Solution:

Build a storage proof of concept early.

Do not wait until the full app is built.

---

## 36. Original Quality Risk

Risk:

The app may accidentally use compressed picker files or thumbnails.

Solution:

Always test:

* File size
* Resolution
* MIME type
* Video duration
* Original vs downloaded file

---

## 37. Privacy Risk

Risk:

Non-members may access private album data if RLS is wrong.

Solution:

Test RLS and backend permissions carefully.

Never rely only on hidden UI buttons.

---

## 38. Save All Risk

Risk:

Save All may fail for large albums.

Solution:

Download files one by one or in safe batches.

Show progress.

Allow retry.

---

## 39. iOS Permission Risk

Risk:

iOS permissions may block upload or save.

Solution:

Test early on real iPhone and iPad.

Use clear permission messages.

---

## 40. Scope Creep Risk

Risk:

The app may become too big too early.

Solution:

Do not build social features, payment features, or business features in V1.

---

# PART F: IMPORTANT RULES FOR DEVELOPMENT

---

## 41. Main Product Rule

Always protect this rule:

**Share Memories in Original Quality.**

---

## 42. Privacy Rule

Only invited album members can access album files.

---

## 43. Backend Security Rule

The backend and database must enforce permissions.

The frontend UI is not enough.

---

## 44. Original Quality Rule

Do not compress, resize, convert, or replace original files.

---

## 45. Thumbnail Rule

Thumbnails are only for preview.

They must never replace original files.

---

## 46. Save All Rule

Save All must download original files.

It must not use thumbnails.

---

## 47. Soft Delete Rule

Only the original uploader can restore their own deleted file.

---

## 48. No Social Media Rule

Do not add:

* Likes
* Comments
* Followers
* Public feed
* Public profiles

---

## 49. Future-Ready Rule

Prepare for future monetization and storage migration, but do not fully implement them in V1.

---

# PART G: NEXT STEPS

---

## 50. Documents Completed

Completed planning documents:

1. Potoos Master Product Plan v1.0
2. Potoos System Architecture Document v1.0
3. Potoos Database Design Document v1.0
4. Potoos UI/UX Flow Document v1.0
5. Potoos Development Roadmap v1.0
6. Potoos Codex Development Instructions v1.0
7. Potoos API and Edge Functions Specification v1.0
8. Potoos Supabase SQL and RLS Planning Document v1.0
9. Potoos App Store and TestFlight Preparation Document v1.0
10. Potoos Privacy Policy and Terms Planning Document v1.0
11. Potoos MVP Checklist and Testing Plan v1.0
12. Potoos Project Summary and Master Index v1.0

---

## 51. Recommended Next Document

The next recommended document is:

**Potoos Implementation Starter Pack v1.0**

This document should prepare the project for actual coding.

It should include:

* Project setup checklist
* Required accounts
* Required tools
* Environment variables
* Flutter packages to consider
* Supabase setup checklist
* Google Cloud setup checklist
* iOS setup checklist
* Android setup checklist
* First Codex prompt
* First development milestone

---

## 52. Final Summary

Potoos is now clearly planned.

The project has:

* Product direction
* Technical architecture
* Database plan
* UI/UX flow
* Development roadmap
* Backend API plan
* Supabase RLS plan
* App Store preparation plan
* Privacy and terms plan
* Testing plan
* Master index

The next step is to prepare the actual development setup.

The project should start with a small proof of concept:

1. Google Login
2. Create album
3. Upload one original photo
4. Download one original photo
5. Confirm original quality

After that, the full MVP can be built step by step.
