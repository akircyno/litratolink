# LitratoLink MVP Checklist and Testing Plan v1.0

## 1. Document Purpose

This document explains how to check and test the LitratoLink MVP before TestFlight and App Store release.

This document is based on:

* LitratoLink Master Product Plan v1.0
* LitratoLink System Architecture Document v1.0
* LitratoLink Database Design Document v1.0
* LitratoLink UI/UX Flow Document v1.0
* LitratoLink Development Roadmap v1.0
* LitratoLink Codex Development Instructions v1.0
* LitratoLink API and Edge Functions Specification v1.0
* LitratoLink Supabase SQL and RLS Planning Document v1.0
* LitratoLink App Store and TestFlight Preparation Document v1.0
* LitratoLink Privacy Policy and Terms Planning Document v1.0

The goal of this document is to make sure LitratoLink works correctly before real users use it.

This document includes:

* MVP feature checklist
* Manual testing checklist
* Role testing checklist
* Original quality testing checklist
* Upload testing checklist
* Download testing checklist
* Save All testing checklist
* iOS TestFlight checklist
* Android testing checklist
* PC/Web testing checklist
* Bug report format
* Release readiness checklist

---

## 2. MVP Definition

The MVP means the first usable version of LitratoLink.

The MVP must prove that the app can do the main promise:

**Share Memories in Original Quality**

The MVP must support:

* Google Login
* Private albums
* Invites
* Roles
* Photo upload
* Video upload
* Original-quality download
* Save All
* Soft delete
* Restore own files
* Basic notifications
* Mobile testing
* iOS TestFlight readiness

---

## 3. Main MVP Rule

The MVP is not complete unless this flow works:

1. User logs in with Google.
2. User creates an album.
3. User invites another user.
4. Invited user accepts.
5. Admin or Contributor uploads photos and videos.
6. Album members can view files.
7. Album members can download original files.
8. Album members can use Save All.
9. Uploader can delete their own file.
10. Uploader can restore their own deleted file within 30 days.

If this flow does not work, the MVP is not ready.

---

# PART A: MVP FEATURE CHECKLIST

---

## 4. Authentication Checklist

### Google Login

Status: Not Started / In Progress / Done

Checklist:

* User can tap **Continue with Google**.
* Google login opens correctly.
* User can select Google account.
* Supabase session is created.
* User profile is created after first login.
* Existing user profile is loaded after login.
* User stays logged in after app restart.
* User can log out.
* User returns to Welcome screen after logout.
* App handles login failure.
* App handles no internet during login.

Pass condition:

User can log in and log out without errors.

---

## 5. User Profile Checklist

Status: Not Started / In Progress / Done

Checklist:

* User profile is created with user ID.
* User email is saved.
* Display name is saved if available.
* Avatar URL is saved if available.
* User profile is linked to Supabase Auth user.
* User can only update their own profile.
* User cannot access private data of other users.

Pass condition:

Every logged-in user has a valid profile.

---

## 6. Album Checklist

Status: Not Started / In Progress / Done

Checklist:

* User can create an album.
* Album name is required.
* Album description is optional.
* Album creator becomes Admin.
* Album appears in My Albums.
* Album is private by default.
* User can open album details.
* User can see their role in the album.
* Non-members cannot see the album.
* Deleted albums do not appear in normal view.

Pass condition:

Users can create and open private albums correctly.

---

## 7. Album Member Checklist

Status: Not Started / In Progress / Done

Checklist:

* Album shows member list.
* Member name is shown.
* Member email is shown.
* Member role is shown.
* Admin can invite members.
* Admin can remove members.
* Admin can change roles.
* Contributor cannot invite members.
* Viewer cannot invite members.
* Removed member loses access.
* Album always has at least one Admin.

Pass condition:

Album members and roles work correctly.

---

## 8. Invite Checklist

Status: Not Started / In Progress / Done

Checklist:

* Admin can invite by email.
* Admin can choose role.
* Default invite role is Viewer.
* Invite email is validated.
* Invite is saved as pending.
* Invited user can see pending invite.
* Invited user can accept invite.
* Invited user can decline invite.
* Invite email must match logged-in email.
* Expired invite cannot be accepted.
* Cancelled invite cannot be accepted.
* User cannot accept another person’s invite.

Pass condition:

Only invited users can join albums.

---

## 9. Upload Checklist

Status: Not Started / In Progress / Done

Checklist:

* Admin can upload.
* Contributor can upload.
* Viewer cannot upload.
* User can upload photos.
* User can upload videos.
* User can upload multiple files.
* App shows selected files before upload.
* App shows upload progress.
* App shows upload success.
* App shows upload failure.
* App allows retry for failed upload.
* Upload metadata is saved.
* Upload status is saved.
* Original filename is saved.
* MIME type is saved.
* File size is saved.
* Uploader ID is saved.
* Album ID is saved.

Pass condition:

Admin and Contributor can upload original photos and videos.

---

## 10. Original Quality Upload Checklist

Status: Not Started / In Progress / Done

Checklist:

* App uploads original file.
* App does not compress photo.
* App does not compress video.
* App does not resize file.
* App does not convert file format.
* Thumbnail is separate from original file.
* Original file is stored in storage.
* Original file is linked to metadata.
* Download uses original file, not thumbnail.

Pass condition:

Uploaded file keeps original quality.

---

## 11. Gallery Checklist

Status: Not Started / In Progress / Done

Checklist:

* Album gallery shows uploaded files.
* Gallery shows photos.
* Gallery shows videos.
* Gallery uses thumbnails or previews.
* Gallery does not use original file unnecessarily for preview.
* User can open file preview.
* File preview shows download button.
* File preview shows delete button only for uploader.
* Deleted files do not show in normal gallery.
* Uploading or failed files are handled clearly.

Pass condition:

Album gallery is usable and clear.

---

## 12. Download Checklist

Status: Not Started / In Progress / Done

Checklist:

* Admin can download.
* Contributor can download.
* Viewer can download.
* Non-member cannot download.
* Removed member cannot download.
* User can download one file.
* App asks backend for download access.
* Backend checks permission.
* App downloads original file.
* App does not download thumbnail as final file.
* App saves file to device.
* App shows download success.
* App shows download failure.
* App allows retry after failed download.

Pass condition:

Album members can download original files securely.

---

## 13. Save All Checklist

Status: Not Started / In Progress / Done

Checklist:

* Save All button is visible to album members.
* Save All is available for Admin.
* Save All is available for Contributor.
* Save All is available for Viewer.
* Save All asks for confirmation.
* Save All warns about storage use.
* Save All downloads original files.
* Save All does not use thumbnails.
* Save All shows progress.
* Save All handles many files safely.
* Save All can retry failed downloads.
* Save All shows complete message.
* Save All does not crash the app.

Pass condition:

User can save many original files without downloading one by one.

---

## 14. Select Files Checklist

Status: Not Started / In Progress / Done

Checklist:

* User can enter selection mode.
* User can select one file.
* User can select many files.
* User can select all files.
* User can cancel selection.
* User can save selected files.
* App shows selected count.
* Save Selected downloads original files.
* Failed selected downloads can be retried.

Pass condition:

User can choose specific files and save them.

---

## 15. Soft Delete Checklist

Status: Not Started / In Progress / Done

Checklist:

* Only uploader can delete their own file.
* Admin cannot delete another user’s file in V1.
* Contributor cannot delete another user’s file.
* Viewer cannot delete files.
* Delete confirmation is shown.
* Deleted file disappears from album for everyone.
* Deleted file appears in uploader’s Trash.
* Deleted file has deleted date.
* Deleted file has restore deadline.
* Delete expiration is set to 30 days.

Pass condition:

Users can safely delete only their own uploaded files.

---

## 16. Restore Checklist

Status: Not Started / In Progress / Done

Checklist:

* Uploader can open Trash.
* Trash shows only files uploaded by current user.
* User can restore their own deleted file.
* Restored file returns to original album.
* Restored file becomes visible again to album members.
* Admin cannot restore another user’s file.
* Viewer cannot restore files.
* Expired deleted file cannot be restored.
* Permanently deleted file cannot be restored.

Pass condition:

Only the original uploader can restore their own deleted files within 30 days.

---

## 17. Notification Checklist

Status: Not Started / In Progress / Done

Checklist:

* App can request notification permission.
* Device token is saved.
* Device token is linked to user.
* Device token is removed or disabled on logout.
* User receives album invite notification.
* User receives new upload notification.
* User receives upload complete notification.
* Notification opens related screen if possible.
* Notification does not show private file names.
* Many uploads create one grouped notification.
* Removed members stop receiving album notifications.

Pass condition:

Notifications work and protect privacy.

---

# PART B: ROLE TESTING CHECKLIST

---

## 18. Admin Testing

Test with user role: Admin

Admin should be able to:

* View album.
* View files.
* Download files.
* Use Save All.
* Upload photos.
* Upload videos.
* Invite members.
* Remove members.
* Change roles.
* Rename album.
* Delete album.
* Delete own uploaded files.
* Restore own deleted files.

Admin should not be able to:

* Restore files uploaded by other users.
* Delete files uploaded by other users in V1.
* Bypass backend rules.

Pass condition:

Admin has full album management access but cannot control other users’ deleted files.

---

## 19. Contributor Testing

Test with user role: Contributor

Contributor should be able to:

* View album.
* View files.
* Download files.
* Use Save All.
* Upload photos.
* Upload videos.
* Delete own uploaded files.
* Restore own deleted files.

Contributor should not be able to:

* Invite members.
* Remove members.
* Change roles.
* Rename album.
* Delete album.
* Delete other users’ files.
* Restore other users’ files.

Pass condition:

Contributor can contribute files but cannot manage the album.

---

## 20. Viewer Testing

Test with user role: Viewer

Viewer should be able to:

* View album.
* View files.
* Download files.
* Use Save All.

Viewer should not be able to:

* Upload files.
* Invite members.
* Remove members.
* Change roles.
* Rename album.
* Delete album.
* Delete files.
* Restore files.

Pass condition:

Viewer can only view and download.

---

## 21. Removed Member Testing

Test with removed member.

Removed member should not be able to:

* See album.
* See files.
* Download files.
* Upload files.
* Receive new notifications.
* Use old download access.
* Access album through old link or saved route.

Pass condition:

Removed member loses access completely.

---

# PART C: ORIGINAL QUALITY TESTING

---

## 22. Photo Quality Test

Use at least 5 photos from different devices.

Test files:

* iPhone photo
* Android photo
* Screenshot
* High-resolution photo
* Edited photo saved from another app

For each file, compare:

* Original file name
* Original file size
* Downloaded file size
* Original width
* Original height
* Downloaded width
* Downloaded height
* File type
* MIME type

Pass condition:

Downloaded file should match the original as much as possible.

---

## 23. Video Quality Test

Use at least 5 videos.

Test files:

* Short iPhone video
* Short Android video
* Long video
* High-resolution video
* Large file size video

For each video, compare:

* Original file name
* Original file size
* Downloaded file size
* Original resolution
* Downloaded resolution
* Original duration
* Downloaded duration
* File type
* MIME type

Pass condition:

Downloaded video should match original quality.

---

## 24. Thumbnail Safety Test

Checklist:

* Thumbnail is created only for preview.
* Thumbnail has separate storage object.
* Thumbnail is not used for Download Original.
* Thumbnail is not used for Save All.
* Thumbnail does not replace original file.
* Deleting original file also handles thumbnail properly later.

Pass condition:

Thumbnail never becomes the final downloadable file.

---

# PART D: DEVICE TESTING CHECKLIST

---

## 25. iPhone Testing Checklist

Test on real iPhone.

Checklist:

* App installs.
* App opens.
* Google Login works.
* User can create album.
* User can accept invite.
* User can upload from Photos.
* User can upload from Files.
* User can upload video.
* User can download file.
* User can Save All.
* User can save to Photos.
* User can save to Files.
* Notification permission works.
* Push notification appears.
* App does not crash during upload.
* App does not crash during Save All.

Pass condition:

iPhone user can use the full main flow.

---

## 26. iPad Testing Checklist

Test on real iPad.

Checklist:

* App installs.
* App layout works on iPad screen.
* Google Login works.
* Album list is readable.
* Gallery grid looks good.
* Upload works.
* Download works.
* Save All works.
* Save to Photos works.
* Notification permission works.
* App does not look stretched or broken.

Pass condition:

iPad user can use the app comfortably.

---

## 27. Android Testing Checklist

Test on Android phone.

Checklist:

* App installs.
* Google Login works.
* Upload from Gallery works.
* Upload from Files works.
* Video upload works.
* Download works.
* Save to Gallery works.
* Save to Files or Downloads works.
* Notifications work.
* Back button behavior works.
* App does not crash during upload or download.

Pass condition:

Android user can use the full main flow.

---

## 28. PC/Web Testing Checklist

Test on PC or web version if available.

Checklist:

* User can open app on browser or desktop.
* Google Login works.
* User can create album.
* User can upload files.
* User can upload photos.
* User can upload videos.
* User can view album files.
* User can download files.
* User can use Save All or selected download if supported.
* Large upload does not crash.
* UI works on desktop screen.

Pass condition:

PC user can upload and download files easily.

---

# PART E: USER FLOW TESTING

---

## 29. First-Time User Flow

Test steps:

1. Open app.
2. See Welcome screen.
3. Tap Continue with Google.
4. Log in.
5. Land on My Albums.
6. See empty state.
7. Create first album.

Pass condition:

New user can start using the app without confusion.

---

## 30. Couple Sharing Flow

Test with two users.

User A:

1. Create album called “Me and GF”.
2. Invite User B as Contributor.
3. Upload photos and videos.

User B:

1. Log in.
2. Accept invite.
3. Open album.
4. View files.
5. Upload files.
6. Save All.

Pass condition:

Both users can upload and receive original-quality files.

---

## 31. Family Album Flow

Test with three users.

User A:

1. Create “Family” album.
2. Invite User B as Contributor.
3. Invite User C as Viewer.

Expected:

* User B can upload and download.
* User C can only view and download.
* User C cannot upload.
* User C cannot invite.

Pass condition:

Roles work correctly in a group album.

---

## 32. Delete and Restore Flow

Test steps:

1. User uploads file.
2. User deletes own file.
3. File disappears from album.
4. Other users cannot see file.
5. Uploader opens Trash.
6. Uploader restores file.
7. File returns to album.

Pass condition:

Soft delete and restore work exactly as planned.

---

## 33. Removed Member Flow

Test steps:

1. Admin invites Viewer.
2. Viewer accepts invite.
3. Viewer downloads a file.
4. Admin removes Viewer.
5. Viewer tries to open album.
6. Viewer tries old file download.

Pass condition:

Removed Viewer cannot access album anymore.

---

# PART F: ERROR TESTING

---

## 34. No Internet Test

Test:

* Login with no internet.
* Upload with no internet.
* Download with no internet.
* Save All with no internet.

Expected messages:

* No internet connection. Please check your connection and try again.
* Upload failed. Please try again.
* Download failed. Please try again.

Pass condition:

App shows clear errors and does not crash.

---

## 35. Upload Failure Test

Test:

* Stop internet during upload.
* Upload large video.
* Upload unsupported file if blocked.
* Upload when storage is full if possible.

Expected:

* Upload failure is shown.
* Failed file can retry.
* App does not mark failed file as completed.
* App does not lose all selected files immediately.

Pass condition:

Upload failure is safe and understandable.

---

## 36. Download Failure Test

Test:

* Stop internet during download.
* Stop internet during Save All.
* Try to download deleted file.
* Try to download as removed member.

Expected:

* Download failure is shown.
* Failed files can retry.
* Deleted file shows unavailable message.
* Removed member gets permission error.

Pass condition:

Download errors do not break the app.

---

## 37. Permission Error Test

Test:

* Viewer tries upload.
* Contributor tries invite.
* Non-member tries album access.
* User tries another user’s Trash.
* User tries restoring another user’s file.

Expected message:

**You do not have permission to do this.**

Pass condition:

Backend blocks unauthorized actions.

---

# PART G: TESTFLIGHT READINESS CHECKLIST

---

## 38. Before TestFlight Checklist

LitratoLink is ready for TestFlight only if:

* App builds on iOS.
* App opens on iPhone.
* App opens on iPad.
* Google Login works.
* Create album works.
* Invite works.
* Upload works.
* Download works.
* Save All works.
* Soft delete works.
* Restore works.
* Basic notifications work.
* iOS permission messages are clear.
* App icon is added.
* App does not show debug screens.
* App does not have broken buttons.
* Test users are prepared.

Pass condition:

App can be used by girlfriend, friends, and family for real testing.

---

## 39. TestFlight Tester Instructions

Give testers simple instructions:

1. Install TestFlight.
2. Open the LitratoLink invite.
3. Install LitratoLink.
4. Log in with Google.
5. Accept album invite or create album.
6. Upload photos or videos.
7. Try Save All.
8. Report any problem.

---

## 40. TestFlight Feedback Questions

Ask testers:

1. Was login easy?
2. Was creating an album easy?
3. Was accepting invite easy?
4. Was upload easy?
5. Was download easy?
6. Did Save All work?
7. Did the app feel private?
8. Did anything confuse you?
9. Did any file lose quality?
10. Did the app crash?

---

# PART H: BUG REPORT FORMAT

---

## 41. Bug Report Template

Use this format for every bug:

### Bug Title

Short description of the issue.

### Device

Example:

iPhone 13, iOS 18

### App Version

Example:

0.1.0 build 4

### User Role

Admin / Contributor / Viewer

### Screen

Example:

Album Details

### Steps to Reproduce

1. Step one
2. Step two
3. Step three

### Expected Result

What should happen.

### Actual Result

What happened instead.

### Screenshot or Video

Attach if available.

### Severity

Low / Medium / High / Critical

---

## 42. Bug Severity Guide

### Critical

App cannot be used.

Examples:

* Login does not work.
* Upload always fails.
* Download always fails.
* Private album is visible to non-member.

### High

Important feature is broken.

Examples:

* Save All fails.
* Invite does not work.
* Viewer can upload.
* Deleted file still visible.

### Medium

Feature works but has issues.

Examples:

* Upload progress is wrong.
* Notification opens wrong screen.
* UI layout problem.

### Low

Small issue.

Examples:

* Typo.
* Spacing issue.
* Icon alignment.

---

# PART I: RELEASE READINESS CHECKLIST

---

## 43. MVP Ready Checklist

The MVP is ready when:

* Google Login works.
* User profiles work.
* Album creation works.
* Private album access works.
* Invites work.
* Roles work.
* Photo upload works.
* Video upload works.
* Original quality is preserved.
* Download Original works.
* Save All works.
* Soft delete works.
* Restore works.
* Notifications work.
* iPhone testing passed.
* iPad testing passed.
* Android testing passed.
* PC/Web testing passed if included.
* No critical bugs remain.
* No high privacy bugs remain.

---

## 44. App Store Ready Checklist

LitratoLink is App Store ready when:

* TestFlight feedback is good.
* Main bugs are fixed.
* App icon is final.
* Logo is final.
* Screenshots are ready.
* App description is ready.
* Privacy Policy is published.
* Terms of Use is published.
* Support email is ready.
* App privacy details are completed.
* Demo account is ready.
* App Review notes are ready.
* No debug UI remains.
* No unfinished features are visible.

---

## 45. Do Not Release If

Do not release if:

* Login is broken.
* Upload is broken.
* Download is broken.
* Save All is broken.
* Users can access private albums without permission.
* Viewer can upload.
* Contributor can invite.
* Admin can restore another user’s file.
* Downloaded files lose quality.
* App crashes during normal use.
* Privacy policy is missing.
* App has placeholder screens.

---

## 46. Final Testing Summary

Before TestFlight:

Test the main flow with:

* 1 Admin
* 1 Contributor
* 1 Viewer

Test on:

* iPhone
* iPad
* Android
* PC/Web if available

Test files:

* Photos
* Videos
* Large files
* Many files

Main things to verify:

* Private access
* Original quality
* Save All
* Role permissions
* Delete and restore
* App stability

---

## 47. Next Recommended Document

The next recommended document is:

**LitratoLink Project Summary and Master Index v1.0**

This document should summarize all created documents and explain what each document is for.

It should help keep the project organized before actual development starts.
