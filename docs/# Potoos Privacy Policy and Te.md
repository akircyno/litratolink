# Potoos Privacy Policy and Terms Planning Document v1.0

## 1. Document Purpose

This document prepares the privacy policy and terms of use content for Potoos.

This document is based on:

* Potoos Master Product Plan v1.0
* Potoos System Architecture Document v1.0
* Potoos Database Design Document v1.0
* Potoos UI/UX Flow Document v1.0
* Potoos Development Roadmap v1.0
* Potoos Codex Development Instructions v1.0
* Potoos API and Edge Functions Specification v1.0
* Potoos Supabase SQL and RLS Planning Document v1.0
* Potoos App Store and TestFlight Preparation Document v1.0

The goal of this document is to plan:

* Privacy policy sections
* Terms of use sections
* What data Potoos collects
* Why data is collected
* How albums work
* How media files are stored
* How deletion works
* How user permissions work
* What users are responsible for
* What needs to be prepared before App Store release

This is not final legal text. It is a planning guide before writing the official privacy policy and terms of use.

---

## 2. App Summary

**App Name:** Potoos
**Tagline:** Share Memories in Original Quality
**Product Type:** Private cloud sharing app

Potoos allows users to:

* Create private albums
* Invite selected people
* Upload original-quality photos and videos
* View shared albums
* Download original files
* Use Save All
* Delete and restore their own uploaded files

Potoos is not social media.

The app has:

* No public feed
* No likes
* No comments
* No followers
* No public profiles
* No public album search

---

## 3. Privacy Direction

Potoos should have a clear privacy promise.

Main privacy promise:

**Albums are private by default. Only invited members can access them.**

Privacy principles:

1. Be clear about what data is collected.
2. Do not collect data that is not needed.
3. Do not sell user memories.
4. Do not use user photos or videos for advertising.
5. Do not make albums public by default.
6. Do not expose private file names in notifications.
7. Protect files through backend permission checks.
8. Let users delete their own uploaded files.
9. Make future privacy changes clear to users.

---

## 4. Important Legal Note

This document is only a planning document.

Before public App Store release, the final Privacy Policy and Terms of Use should be reviewed carefully.

If Potoos becomes a public or paid app, it is recommended to ask a legal professional to review the final documents.

---

# PART A: PRIVACY POLICY PLANNING

---

## 5. Privacy Policy Purpose

The Privacy Policy should explain:

* What Potoos is
* What data is collected
* Why data is collected
* How data is used
* How photos and videos are stored
* Who can access albums
* How deletion works
* What third-party services are used
* How users can contact support
* How users can request account or data deletion

---

## 6. Privacy Policy Opening Statement

Suggested opening direction:

Potoos is a private photo and video sharing app. We help users create private albums, invite selected people, and share original-quality photos and videos.

We respect the privacy of your memories. Albums are private by default and can only be accessed by invited members.

---

## 7. Data Potoos May Collect

Potoos may collect the following data:

### 7.1 Account Data

Collected when users log in.

Examples:

* Name
* Email address
* Google profile photo
* User ID
* Login provider

Purpose:

* Create user account
* Identify album members
* Send invites
* Show member names in albums
* Protect private album access

---

### 7.2 Album Data

Collected when users create or join albums.

Examples:

* Album name
* Album description
* Album creator
* Album members
* Member roles
* Invite status
* Album creation date

Purpose:

* Create private albums
* Manage access
* Show albums to members
* Allow Admins to manage albums

---

### 7.3 Media Data

Collected when users upload files.

Examples:

* Photos
* Videos
* Original file name
* File type
* File size
* MIME type
* Upload date
* Uploader ID
* Storage reference
* Thumbnail or preview if created

Purpose:

* Store and share original-quality media
* Show files inside albums
* Allow downloads
* Allow Save All
* Support delete and restore

Important rule:

Uploaded photos and videos are used only to provide the sharing service.

---

### 7.4 Invite Data

Collected when users invite others.

Examples:

* Invited email address
* Album ID
* Role offered
* Invite status
* Inviter ID
* Invite creation date
* Invite expiration date

Purpose:

* Send and manage album invites
* Make sure only invited users can join
* Match invite email with logged-in email

---

### 7.5 Device and Notification Data

Collected if users allow notifications.

Examples:

* Device token
* Platform type
* Device name if available
* Notification status
* Notification read status

Purpose:

* Send push notifications
* Notify users about album invites
* Notify users about new uploads
* Notify users when uploads are complete

Notification privacy rule:

Notifications should not show private file names or sensitive content.

---

### 7.6 Activity and Security Data

Collected for app safety and debugging.

Examples:

* Album created
* Member invited
* File uploaded
* File deleted
* File restored
* Login activity
* Error logs
* Time of action

Purpose:

* Debug app issues
* Protect album access
* Prevent unauthorized actions
* Maintain app reliability

Activity logs should not store private file contents.

---

### 7.7 Support Data

Collected when users contact support.

Examples:

* Email address
* Message content
* Issue details
* Screenshots if user provides them

Purpose:

* Help users
* Fix account or app issues
* Respond to support requests

---

## 8. Data Potoos Should Not Collect in V1

For V1, Potoos should not collect:

* Advertising ID
* Precise location
* Contacts list
* Health data
* Payment data
* Social media profile data
* Chat messages
* Public follower data
* Like or comment data

Reason:

These are not needed for the app’s purpose.

---

## 9. How Potoos Uses Data

Potoos uses data to:

1. Create and manage user accounts.
2. Let users log in.
3. Create private albums.
4. Invite selected people.
5. Upload original-quality photos and videos.
6. Show media inside albums.
7. Allow users to download original files.
8. Allow Save All.
9. Manage album roles.
10. Send notifications.
11. Support delete and restore.
12. Improve app reliability.
13. Provide support.

Potoos should not use user photos or videos for advertising.

---

## 10. How Albums Work

The Privacy Policy should explain:

* Albums are private by default.
* Users can create albums.
* Album creators become Admins.
* Admins can invite members.
* Only invited members can access albums.
* Members can only access albums where they are active members.
* Removed members lose access.
* There are no public albums in V1.

---

## 11. Album Roles and Privacy

Explain the roles:

### Admin

Admin can:

* Manage album settings
* Invite members
* Remove members
* Change roles
* Upload files
* Download files

### Contributor

Contributor can:

* Upload files
* View files
* Download files
* Delete and restore their own uploaded files

### Viewer

Viewer can:

* View files
* Download files
* Use Save All

Privacy rule:

Users cannot access albums where they are not members.

---

## 12. How Photos and Videos Are Stored

For V1, Potoos uses Potoos-managed Google Drive / Google One-backed storage.

The Privacy Policy should explain this in simple words:

* Photos and videos are stored so they can be shared through private albums.
* File metadata is stored in the app database.
* Original files are stored in a managed storage system.
* Thumbnails or previews may be created for faster viewing.
* Thumbnails do not replace original files.

Important wording:

Original-quality files are stored for the purpose of sharing them with invited album members.

---

## 13. Third-Party Services

Potoos may use third-party services.

### 13.1 Supabase

Used for:

* Authentication support
* Database
* Album data
* User profiles
* Permissions
* Notifications data
* Backend functions

### 13.2 Google Services

Used for:

* Google Login
* Google Drive / Google One-backed storage
* Google APIs

### 13.3 Apple Services

Used for:

* iOS app distribution
* TestFlight
* App Store
* Apple device permissions

### 13.4 Push Notification Services

Used for:

* Sending push notifications
* Delivering invite and upload alerts

The final Privacy Policy must match the real services used in the app.

---

## 14. Google API and OAuth Privacy Planning

Because Potoos uses Google Login and Google APIs, the Privacy Policy should clearly explain:

* What Google data is accessed
* Why it is accessed
* How it is used
* How it is stored
* Whether it is shared
* How users can request deletion

For V1, Google Login should request only the basic information needed:

* Email
* Name
* Profile photo if needed

Avoid requesting Google API scopes that are not needed.

Storage API access should be handled carefully and only for the Potoos-managed storage setup.

---

## 15. App Store Privacy Label Planning

Before App Store release, App Store Connect will ask what data the app collects.

Expected data categories may include:

### Contact Info

Possible:

* Email address
* Name

Reason:

* Account login
* Invites
* Album membership

### User Content

Possible:

* Photos
* Videos
* Uploaded media
* Album names

Reason:

* Private album sharing

### Identifiers

Possible:

* User ID
* Device token

Reason:

* Account system
* Notifications

### Usage Data

Possible:

* App activity logs

Reason:

* App functionality
* Security
* Debugging

### Diagnostics

Possible:

* Crash logs
* Performance data

Reason:

* App improvement and debugging

Important:

The final App Store privacy answers must match the real app behavior.

---

## 16. Data Linked to User

Some data may be linked to the user account.

Examples:

* Email address
* Name
* Albums
* Uploaded files
* Album roles
* Device tokens
* Activity logs

This should be declared honestly in App Store privacy details.

---

## 17. Data Not Used for Tracking

For V1, recommended rule:

Potoos should not use data for tracking users across apps or websites.

Recommended statement:

Potoos does not use your photos, videos, or account data for advertising tracking.

---

## 18. Data Sharing

Potoos may share data only as needed to operate the app.

Examples:

* Album files are shared with invited album members.
* Third-party services process data to provide app features.
* Legal requests may require disclosure if applicable.

The policy should say:

We do not sell your personal photos or videos.

We do not make your albums public.

---

## 19. User Control

The Privacy Policy should explain what users can control.

Users can:

* Create albums
* Invite members
* Remove members if Admin
* Upload files
* Delete their own uploaded files
* Restore their own deleted files within 30 days
* Leave albums if feature is added
* Log out
* Contact support for account or data deletion

---

## 20. Delete and Restore Policy

Explain clearly:

* Only the original uploader can delete their own uploaded file.
* When deleted, the file disappears from the album for everyone.
* Deleted files go to Trash.
* Deleted files may be restored by the original uploader within 30 days.
* After 30 days, deleted files may be permanently deleted.
* Once permanently deleted, files cannot be restored.

---

## 21. Account Deletion Planning

Before public release, decide how users can delete their account.

Recommended:

Add a support-based account deletion process first.

Example:

Users can contact support to request account deletion.

Future enhancement:

Add in-app account deletion.

Important:

If public App Store release is planned, account deletion requirements should be reviewed before submission.

---

## 22. Data Retention Planning

Suggested retention rules:

### Active account data

Kept while the account is active.

### Active album data

Kept while the album exists.

### Uploaded files

Kept while active, unless deleted by uploader or album policy.

### Deleted files

Recoverable for 30 days, then may be permanently deleted.

### Activity logs

May be kept for security and debugging.

### Notifications

May be kept until deleted or cleaned up later.

---

## 23. Security Planning

Privacy Policy should explain basic security:

* User accounts require login.
* Albums are invite-only.
* Backend checks permissions.
* Files are not meant to be publicly accessible.
* Access is controlled by album membership and roles.

Avoid overclaiming.

Do not claim:

* “100% secure”
* “Impossible to hack”
* “Fully encrypted end-to-end”

Unless actually implemented.

---

## 24. Children and Age Planning

Potoos should not target children in V1.

Suggested statement:

Potoos is not designed for children under the age required by local law.

If Potoos later targets schools or families with children, privacy requirements must be reviewed carefully.

---

## 25. International Users

Potoos may be used by users in different countries.

The Privacy Policy should use simple language.

If the app becomes public in many countries, future legal review may be needed for privacy laws.

---

## 26. Privacy Policy Contact

Prepare a support contact.

Recommended:

* [support@potoos.app](mailto:support@potoos.app)

Temporary:

* A dedicated Gmail address

The Privacy Policy must include a way to contact the app owner.

---

# PART B: TERMS OF USE PLANNING

---

## 27. Terms of Use Purpose

The Terms of Use should explain:

* What users can do
* What users cannot do
* User responsibility for uploaded content
* Album sharing rules
* Storage limitations
* Service limitations
* Account rules
* Delete and restore rules
* Future paid features
* Support process

---

## 28. Terms Opening Statement

Suggested opening direction:

By using Potoos, you agree to use the app responsibly. Potoos is a private photo and video sharing app that helps users share original-quality media through invite-only albums.

---

## 29. User Responsibilities

Users are responsible for:

1. The photos and videos they upload.
2. Making sure they have the right to share uploaded content.
3. Inviting only people they trust.
4. Not using the app for harmful or illegal content.
5. Keeping their account secure.
6. Respecting other users’ privacy.

---

## 30. Allowed Use

Users may use Potoos to:

* Create private albums
* Upload photos and videos
* Invite selected people
* Download shared files
* Share family, couple, friend, or event memories
* Manage their own uploaded files

---

## 31. Prohibited Use

Users must not use Potoos to:

* Upload illegal content
* Upload harmful content
* Harass other users
* Share private content without permission
* Violate copyright
* Attempt to access private albums without permission
* Abuse the invite system
* Attack or disrupt the service
* Reverse engineer the app
* Use the app for spam

---

## 32. User Content Ownership

Suggested rule:

Users keep ownership of the photos and videos they upload.

Potoos only needs permission to store, process, display, and share the content inside the app according to the user’s album settings.

Simple explanation:

You own your content. Potoos stores and shares it only to provide the app service.

---

## 33. Content License to Potoos

The Terms should include a limited license.

Suggested meaning:

When users upload files, they allow Potoos to:

* Store the files
* Display previews
* Share files with invited album members
* Enable downloads
* Create thumbnails if needed
* Process files for app functionality

This license should be limited to operating the app.

Do not use broad or scary wording.

---

## 34. Album Access Terms

Explain:

* Albums are private by default.
* Admins control invites.
* Members can access albums based on their role.
* Removed members lose access.
* Users should only invite people they trust.
* Potoos cannot control what invited members do after downloading files.

Important point:

If a member downloads a file, they may keep a copy outside Potoos.

Users should understand this.

---

## 35. Original Quality Terms

Explain:

Potoos is designed to preserve original quality.

But the Terms should avoid overpromising.

Suggested wording:

Potoos is built to upload and download original files without intentional compression. However, file handling may depend on device, operating system, storage provider, connection, and selected file source.

This protects the app from unrealistic claims.

---

## 36. Delete and Restore Terms

Terms should explain:

* Only uploader can delete their own file.
* Deleted files are removed from the album view for everyone.
* Deleted files may be restored by uploader within 30 days.
* After 30 days, deleted files may be permanently deleted.
* Permanent deletion cannot be reversed.

---

## 37. Storage Limitation Terms

Explain:

* Storage may have limits.
* Uploads may fail if storage is full.
* Large files may take time.
* Internet connection affects uploads and downloads.
* Potoos may change storage systems in the future.

For V1:

Storage is managed by Potoos.

Users do not need their own Google One subscription.

---

## 38. Service Availability Terms

Explain:

Potoos may not always be available.

Reasons:

* Maintenance
* Server problems
* Storage provider issues
* Internet problems
* Third-party service outage

Do not promise 100% uptime.

---

## 39. Account Suspension or Removal

Terms should allow Potoos to remove or restrict users if needed.

Reasons:

* Abuse
* Illegal content
* Harmful activity
* Security risk
* Violation of terms

For V1 personal testing, this may be simple.

For public release, it should be clearer.

---

## 40. Future Paid Features

Since monetization is future-only, include a simple future note.

Suggested wording:

Potoos may offer paid features in the future. If paid features are added, pricing, billing, and cancellation terms will be explained clearly before users purchase.

Do not add billing terms until payment is implemented.

---

## 41. Changes to the App or Terms

Terms should say that Potoos may update:

* Features
* Terms
* Privacy policy
* Storage provider
* App rules

Users should be notified of important changes.

---

## 42. Limitation of Liability

Terms should include simple limitation language.

Meaning:

Potoos will try to provide a reliable service, but it is not responsible for all possible losses, such as:

* User internet problems
* Device problems
* User sharing files with wrong people
* Third-party service issues
* Accidental downloads by invited members
* Lost access caused by account issues

Final wording should be reviewed before public release.

---

## 43. Support Contact

Terms should include support contact.

Recommended:

* [support@potoos.app](mailto:support@potoos.app)

---

# PART C: APP STORE PRIVACY PREPARATION

---

## 44. App Store Privacy Details Checklist

Before App Store submission, confirm whether Potoos collects:

### Contact Info

* Name
* Email address

### User Content

* Photos
* Videos
* Album names
* Uploaded files

### Identifiers

* User ID
* Device token

### Usage Data

* Activity logs
* App actions

### Diagnostics

* Crash logs
* Performance data

### Data Not Collected

Likely not collected in V1:

* Precise location
* Contacts
* Health data
* Financial information
* Advertising ID

---

## 45. Privacy Label Consistency Rule

The Privacy Policy and App Store privacy label must match.

If the app says it collects photos and videos in the policy, the App Store privacy details should not say “no user content collected.”

If the app uses analytics later, update the Privacy Policy and App Store privacy details.

---

## 46. Google OAuth Consent Screen Planning

Because Google Login is used, prepare:

* App name
* App logo
* Privacy policy URL
* Terms of use URL
* Authorized domains
* Support email
* Requested scopes
* App explanation

Recommended scopes for login:

* Basic profile
* Email

Avoid unnecessary scopes.

---

## 47. Public Policy Pages Needed

Before App Store release, create public pages:

1. Privacy Policy
2. Terms of Use
3. Support Page

Recommended domain later:

* potoos.app

Temporary option:

* Public Notion page
* GitHub Pages
* Simple website
* Carrd
* Google Sites

Better long-term:

* Own domain and simple landing page

---

# PART D: FINAL DOCUMENTS TO CREATE LATER

---

## 48. Final Privacy Policy Document

Later, create:

**Potoos Privacy Policy v1.0**

It should be written in final public-facing language.

It should include:

* Effective date
* App name
* Contact email
* Data collected
* How data is used
* How data is shared
* Third-party services
* User rights
* Delete policy
* Security
* Children’s privacy
* Changes to policy

---

## 49. Final Terms of Use Document

Later, create:

**Potoos Terms of Use v1.0**

It should include:

* Effective date
* Acceptance of terms
* User responsibilities
* Allowed use
* Prohibited use
* User content ownership
* Limited content license
* Album access
* Delete and restore rules
* Service availability
* Future paid features
* Account suspension
* Changes to terms
* Contact

---

## 50. Final Support Page

Later, create:

**Potoos Support Page**

It should include:

* What Potoos does
* How to contact support
* How to request data deletion
* How to report a problem
* How to ask for account help

---

# 51. Final Privacy and Terms Planning Summary

Confirmed privacy and terms planning decisions:

* Potoos is a private album sharing app.
* Albums are private by default.
* Only invited members can access albums.
* Users log in with Google in V1.
* Potoos may collect name, email, profile photo, album data, media data, metadata, device tokens, and activity logs.
* Photos and videos are stored only to provide the sharing service.
* Potoos should not use user content for advertising.
* Potoos should not sell user photos or videos.
* Deleted files are restorable by the uploader for 30 days.
* Only original uploader can restore their own file.
* Users keep ownership of their uploaded content.
* Potoos needs limited permission to store and share content inside the app.
* App Store privacy details must match real app behavior.
* Google OAuth setup will need Privacy Policy and Terms URLs.
* Final public legal documents should be reviewed before public release.

---

## 52. Next Recommended Document

The next recommended document is:

**Potoos MVP Checklist and Testing Plan v1.0**

This document should define:

* MVP completion checklist
* Manual testing checklist
* Device testing checklist
* Original quality testing checklist
* Role testing checklist
* iOS TestFlight testing checklist
* Bug reporting format
* Release readiness checklist
