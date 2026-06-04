# Potoos App Store and TestFlight Preparation Document v1.0

## 1. Document Purpose

This document explains how to prepare Potoos for iOS testing and App Store release.

This document is based on:

* Potoos Master Product Plan v1.0
* Potoos System Architecture Document v1.0
* Potoos Database Design Document v1.0
* Potoos UI/UX Flow Document v1.0
* Potoos Development Roadmap v1.0
* Potoos Codex Development Instructions v1.0
* Potoos API and Edge Functions Specification v1.0
* Potoos Supabase SQL and RLS Planning Document v1.0

The goal of this document is to prepare Potoos for:

* iPhone testing
* iPad testing
* TestFlight release
* App Store submission
* App Store review
* Privacy policy preparation
* App listing preparation

---

## 2. Release Strategy

Potoos should not go directly to the public App Store.

The recommended release order is:

1. Internal testing
2. TestFlight testing
3. Friends and family beta
4. App Store soft launch
5. Public release later

This reduces risk and gives time to fix issues.

---

## 3. iOS Release Summary

To release Potoos on iOS, the project needs:

* Apple Developer account
* App Store Connect access
* iOS app bundle ID
* App signing setup
* TestFlight build
* App icon
* App screenshots
* App privacy information
* Privacy policy URL
* App description
* Review notes
* Test account or demo instructions
* Correct iOS permission messages

---

## 4. Apple Developer Account

## 4.1 Requirement

To use TestFlight and publish on the App Store, an Apple Developer Program account is needed.

## 4.2 Cost

Apple Developer Program has a yearly membership fee.

The cost may depend on country or region.

Before paying, always check Apple’s latest official pricing.

## 4.3 Account Type

For Potoos V1, an individual Apple Developer account is enough.

If Potoos becomes a business later, the app can be moved or managed under an organization account if needed.

## 4.4 Recommendation

Start with an individual account for faster setup.

Use organization account later only if:

* Potoos becomes a real company
* Other developers need team access
* Business branding is needed
* Legal ownership must be under a company

---

## 5. App Store Connect Setup

App Store Connect is where the iOS app will be managed.

It will be used for:

* Creating the app record
* Uploading builds
* Managing TestFlight
* Adding screenshots
* Adding app description
* Adding privacy details
* Submitting for App Review
* Managing app versions

---

## 6. App Identity

## 6.1 App Name

**Potoos**

## 6.2 Tagline

**Share Memories in Original Quality**

## 6.3 App Type

Private cloud sharing app.

## 6.4 App Category

Recommended category:

**Photo & Video**

Possible secondary category:

**Utilities**

Main recommendation:

Use **Photo & Video** because the app is focused on private photo and video sharing.

---

## 7. Bundle ID

The iOS app needs a unique bundle ID.

Recommended format:

`com.potoos.app`

If using personal or developer domain later, it can be adjusted.

Examples:

* `com.potoos.app`
* `com.yourname.potoos`
* `com.potoos.mobile`

Recommended:

`com.potoos.app`

---

## 8. App Icon

Potoos needs an app icon before TestFlight and App Store release.

## 8.1 Icon Style

The icon should match the brand:

* Maroon-based
* Clean
* Simple
* Warm
* Filipino-friendly
* Memory-focused

## 8.2 Icon Requirements

The app icon should be prepared in the correct iOS sizes.

Flutter can generate app icons using a package later.

## 8.3 Temporary Icon

For early TestFlight, a temporary icon can be used.

But before App Store release, use the final logo.

---

## 9. Color and Branding

Confirmed branding:

* App name: Potoos
* Tagline: Share Memories in Original Quality
* Main color: Deep Maroon
* Secondary color: Warm Cream
* Accent color: Soft Gold
* Background: Off White
* Text: Dark Brown or Near Black

Brand feeling:

* Private
* Warm
* Simple
* Trustworthy
* Memory-focused

---

## 10. App Screenshots

App Store release needs screenshots.

TestFlight does not need final marketing screenshots, but App Store does.

## 10.1 Recommended Screenshot Scenes

Prepare screenshots for:

1. Welcome screen
2. My Albums screen
3. Album Details screen
4. Upload Original Files screen
5. Save All screen
6. Invite Member screen
7. Private Album / Members screen

## 10.2 Screenshot Text Ideas

Possible screenshot captions:

### Screenshot 1

**Share memories in original quality**

### Screenshot 2

**Create private albums for the people who matter**

### Screenshot 3

**Upload photos and videos without compression**

### Screenshot 4

**Invite selected people only**

### Screenshot 5

**Save one file or save all**

### Screenshot 6

**No likes. No comments. Just private memories.**

---

## 11. App Store Description

## 11.1 Short Description

Potoos helps you share original-quality photos and videos through private albums.

## 11.2 Long Description Draft

Potoos is a private photo and video sharing app made for people who want to share memories without losing quality.

Create private albums, invite selected people, upload original-quality photos and videos, and let receivers save files easily.

Potoos is not social media.

There are no likes, no comments, no followers, and no public feed.

Main features:

* Private albums
* Invite-only access
* Original-quality photo upload
* Original-quality video upload
* Download original files
* Save All feature
* Viewer, Contributor, and Admin roles
* Soft delete and restore
* Simple and clean design

Potoos is made for couples, families, friends, and small private groups who want a better way to share memories.

---

## 12. App Store Keywords

Possible keywords:

* photo sharing
* video sharing
* private albums
* original quality
* family photos
* couple photos
* memory sharing
* album sharing
* private gallery
* photo vault

Choose keywords carefully later.

Do not use misleading keywords.

---

## 13. Privacy Policy

Potoos needs a privacy policy before App Store release.

## 13.1 Privacy Policy Must Explain

The privacy policy should explain:

* What data the app collects
* Why the data is collected
* How photos and videos are stored
* Who can access albums
* How invites work
* How files are deleted
* How long deleted files may stay in Trash
* How notifications work
* What third-party services are used
* How users can request deletion or support

## 13.2 Data Potoos May Collect

Possible data:

* Name
* Email address
* Google profile photo
* Album names
* Album members
* Uploaded photo and video files
* File metadata
* Device tokens for push notifications
* Basic activity logs
* Notifications

## 13.3 Third-Party Services

The privacy policy should mention services used by the app.

Possible services:

* Supabase
* Google Login
* Google Drive / Google One-backed storage
* Push notification service
* Apple services for iOS distribution

## 13.4 Important Privacy Promise

Potoos should clearly say:

* Albums are private by default.
* Only invited members can access albums.
* The app does not have public albums in V1.
* The app does not have a public social feed.
* The app does not sell user memories.

---

## 14. Terms of Use

Terms of Use should be prepared before public App Store release.

## 14.1 Terms Should Explain

The Terms of Use should explain:

* What Potoos is
* User responsibilities
* Upload rules
* Prohibited content
* Storage limitations
* Account rules
* Delete and restore rules
* Service availability
* Future paid features if added later
* Limitation of liability

## 14.2 Simple Rule

Users should only upload content they have the right to share.

---

## 15. iOS Permission Text

The app needs clear permission messages.

## 15.1 Photo Access Permission

Use:

**Potoos needs photo access so you can upload original-quality photos and videos.**

## 15.2 Save to Photos Permission

Use:

**Potoos needs permission to save original-quality files to your Photos.**

## 15.3 File Access Permission

Use:

**Potoos needs file access so you can choose and save files.**

## 15.4 Notification Permission

Use:

**Allow notifications so you know when new memories are added to your albums.**

---

## 16. App Privacy Details

App Store submission requires privacy details.

Potoos should prepare answers about collected data.

## 16.1 Possible Data Linked to User

Likely linked to user:

* Email address
* Name
* User ID
* Uploaded photos and videos
* Album membership
* Device token
* Activity logs

## 16.2 Possible Data Not Used for Tracking

Potoos should not use data for advertising tracking in V1.

Recommended V1 rule:

* No advertising tracking
* No third-party ad tracking
* No selling user data

## 16.3 Important Note

Before App Store submission, verify all actual data collection.

The App Store privacy answers must match the real app behavior.

Do not guess.

---

## 17. Sign In Method

## 17.1 V1 Login

V1 uses:

* Google Login only

## 17.2 Future Login

Future enhancement:

* Apple Login
* Email Login
* Magic Link Login

## 17.3 App Review Note

Because the app uses Google Login, App Review may need a way to test the app.

Prepare:

* Test Google account
* Demo album
* Demo media files
* Clear review instructions

If Apple requires Apple Login later due to rules or review feedback, add Apple Login as a future update.

---

## 18. Test Account for App Review

For App Review, prepare a test account.

## 18.1 Test Account Purpose

Apple reviewers need to enter the app and test features.

## 18.2 Test Account Should Have

Prepare:

* Login method
* Test email
* Test password if needed
* Demo album
* Demo files
* Admin role
* Viewer role if possible

## 18.3 Review Notes Example

Use simple App Review notes:

**Potoos is a private album sharing app. Please log in using the provided test account. A demo album is already available. You can test upload, download, Save All, invite, and member roles.**

---

## 19. TestFlight Plan

## 19.1 Purpose

TestFlight allows selected users to test the iOS app before public App Store release.

## 19.2 TestFlight Users

Start with:

* Developer
* Girlfriend
* 1 close friend
* 1 family member

Then expand to:

* 10 to 30 testers
* 30 to 50 testers if stable

## 19.3 TestFlight Testing Goals

Test:

* Install app
* Google Login
* Create album
* Upload photos
* Upload videos
* Download original files
* Save All
* Invite users
* Accept invite
* Viewer role
* Contributor role
* Admin role
* Soft delete
* Restore own file
* Push notifications
* iPhone permissions
* iPad layout

## 19.4 TestFlight Build Expiration

TestFlight builds expire after a limited time.

If testing continues, upload a new build before or after expiration.

## 19.5 TestFlight Feedback

Ask testers to report:

* Login problems
* Upload problems
* Download problems
* Save All issues
* iOS permission issues
* Slow loading
* Confusing screens
* App crashes
* Quality loss
* Wrong role access

---

## 20. iPhone and iPad Testing Checklist

## 20.1 iPhone Testing

Test:

* Login
* Upload from Photos
* Upload from Files
* Save to Photos
* Save to Files
* Notification permission
* Save All
* Delete and Restore

## 20.2 iPad Testing

Test:

* Layout on bigger screen
* Album grid
* Save All
* Upload
* Download
* Split screen behavior if possible
* Text size

## 20.3 Quality Testing

For iOS, compare:

* Original file size
* Downloaded file size
* Original resolution
* Downloaded resolution
* Original video duration
* Downloaded video duration

The app must not reduce quality.

---

## 21. Android Testing Before App Store

Even though this document is for iOS, Android testing should continue.

Reason:

Potoos is cross-platform.

Test:

* Android upload
* iPhone download
* iPhone upload
* Android download
* PC upload
* iPad download

The app should work across devices.

---

## 22. PC/Web Testing Before App Store

Since one goal is upload from PC, web or desktop should be tested.

Test:

* Login on PC
* Create album
* Upload photo
* Upload video
* Download file
* Save All if available
* Invite member

If PC/Web is not ready for first iOS TestFlight, mark it clearly as future or beta.

---

## 23. App Store Review Preparation

Before submitting:

Check:

* App opens without crash
* Login works
* Demo account works
* Upload works
* Download works
* Save All works
* Permissions are clear
* Privacy policy URL works
* App description is accurate
* Screenshots match the app
* No unfinished buttons
* No broken links
* No placeholder text
* No test-only debug UI
* No misleading claims

---

## 24. App Review Notes

App Review notes should explain the app clearly.

Recommended notes:

**Potoos is a private photo and video sharing app. Users create private albums, invite selected people, upload original-quality files, and download them. The app has no public feed, no likes, no comments, and no followers.**

Add:

* Test login details
* Steps to test upload
* Steps to test Save All
* Any special setup needed

---

## 25. Required Public Links

Before App Store submission, prepare:

1. Privacy Policy URL
2. Terms of Use URL
3. Support URL or email
4. Landing page if possible

## 25.1 Simple Landing Page Content

A simple website can include:

* App name
* Tagline
* Short explanation
* Features
* Privacy Policy link
* Terms link
* Support contact

## 25.2 Support Email

Create a support email.

Example:

`support@potoos.app`

If no custom domain yet, use a temporary Gmail, but a custom domain looks more professional.

---

## 26. App Store Listing Draft

## 26.1 App Name

Potoos

## 26.2 Subtitle

Private albums in original quality

## 26.3 Promotional Text

Share photos and videos privately without losing quality.

## 26.4 Description

Potoos is a private photo and video sharing app for people who want to keep memories in original quality.

Create albums, invite selected people, upload photos and videos, and let receivers save original files easily.

No public feed.
No likes.
No comments.
Just private memories shared in original quality.

## 26.5 Keywords

photo sharing, private album, original quality, family photos, video sharing, memory sharing, photo vault

---

## 27. App Store Screenshot Plan

Recommended screenshot order:

1. Welcome screen
2. My Albums screen
3. Album Details screen
4. Upload screen
5. Save All screen
6. Invite Member screen
7. Privacy / Members screen

## 27.1 Screenshot Captions

Use short captions:

* Share memories in original quality
* Create private albums
* Invite selected people only
* Upload photos and videos
* Save all original files
* No likes, no comments, no public feed

---

## 28. Release Checklist for TestFlight

Before TestFlight:

* Apple Developer account ready
* App Store Connect app created
* Bundle ID created
* iOS signing configured
* App builds on iOS
* Login works
* Upload works
* Download works
* Save All works
* Permissions are configured
* App icon added
* Version number set
* Build number set
* Internal test passed

---

## 29. Release Checklist for App Store

Before App Store:

* Final app icon
* Final screenshots
* App description
* Keywords
* Privacy policy URL
* Terms of Use URL
* Support URL or email
* App privacy details completed
* App Review notes completed
* Demo account ready
* No debug buttons
* No placeholder screens
* No broken links
* No unfinished features shown
* TestFlight feedback reviewed
* Main bugs fixed

---

## 30. Versioning Plan

Use simple versioning.

Example:

### Test Builds

* `0.1.0`
* `0.2.0`
* `0.3.0`

### First App Store Release

* `1.0.0`

## 30.1 Build Numbers

Each upload should have a new build number.

Example:

* Version: `0.1.0`
* Build: `1`

Next upload:

* Version: `0.1.0`
* Build: `2`

---

## 31. Soft Launch Plan

After App Store approval, do not market widely right away.

Start with:

* Friends
* Family
* Close users
* Small Filipino user group

Observe:

* Upload success
* Download success
* Storage use
* User confusion
* Crashes
* App Store feedback

Then improve before wider release.

---

## 32. Main App Store Risks

## 32.1 Login Review Risk

Risk:

Apple reviewer cannot access the app.

Solution:

Provide demo account and clear review notes.

## 32.2 Privacy Information Risk

Risk:

Privacy details do not match real app behavior.

Solution:

Review actual data collection before submission.

## 32.3 Permission Text Risk

Risk:

Permission messages are unclear.

Solution:

Use clear and honest permission messages.

## 32.4 Incomplete App Risk

Risk:

App has placeholder or broken features.

Solution:

Hide unfinished features before submission.

## 32.5 File Sharing Risk

Risk:

App Review may ask how user content is handled.

Solution:

Provide clear privacy policy and moderation/support process if public release grows.

---

## 33. Content Safety and User Reports

For V1 personal use, this may be simple.

For public release, prepare:

* Support email
* Report problem option
* User removal from album
* Account support process

Future public version may need stronger tools:

* Report album
* Report user
* Block user
* Abuse handling policy

This is not a main V1 feature, but should be considered before large public release.

---

## 34. What Not to Submit

Do not submit to App Store if:

* Login is broken
* Upload is broken
* Download is broken
* Save All is broken
* App crashes often
* Privacy policy is missing
* App has placeholder text
* App uses debug screens
* App has misleading descriptions
* App claims features not yet built

---

## 35. Final App Store Preparation Summary

Before TestFlight, Potoos needs:

* Apple Developer account
* iOS build
* App Store Connect app record
* App icon
* Working login
* Working upload
* Working download
* Working Save All
* iOS permissions
* Basic internal testing

Before App Store release, Potoos needs:

* Final app icon
* Screenshots
* App description
* Privacy policy
* Terms of use
* Support contact
* App privacy details
* Demo account
* App Review notes
* TestFlight feedback fixes

---

## 36. Next Recommended Document

The next recommended document is:

**Potoos Privacy Policy and Terms Planning Document v1.0**

This document should prepare the privacy and legal content needed for App Store release.

It should include:

* What data is collected
* Why data is collected
* How albums work
* How files are stored
* How deletion works
* User responsibilities
* Support contact
* Future monetization note
