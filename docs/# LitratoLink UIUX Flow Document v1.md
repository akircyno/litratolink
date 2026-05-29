# LitratoLink UI/UX Flow Document v1.0

## 1. Document Purpose

This document explains the user interface and user experience flow for LitratoLink.

This document is based on:

* LitratoLink Master Product Plan v1.0
* LitratoLink System Architecture Document v1.0
* LitratoLink Database Design Document v1.0

The goal of this document is to define:

* Main screens
* User flows
* Button behavior
* Upload flow
* Download flow
* Save All flow
* Invite flow
* Trash flow
* Permission messages
* Error messages
* Mobile experience
* PC/Web experience

This document should guide the app design and development.

---

## 2. Product UI Goal

LitratoLink should feel:

* Simple
* Private
* Clean
* Warm
* Easy to understand
* Not like social media
* Not like a complicated file manager

The app must focus on one main promise:

**Share Memories in Original Quality**

Users should understand the app without long instructions.

---

## 3. Main UX Principle

The app should follow this simple rule:

**Upload should be easy. Download should be easier.**

Main user flow:

Sender:

1. Open app.
2. Choose album.
3. Tap Upload.
4. Select photos or videos.
5. Upload.
6. Done.

Receiver:

1. Open app.
2. Open album.
3. View files.
4. Tap Save All or select files.
5. Save original files.
6. Done.

---

## 4. App Personality

LitratoLink should not feel cold like a file storage app.

It should feel like a private memory-sharing app.

Recommended style:

* Warm maroon colors
* Soft background
* Clear buttons
* Rounded cards
* Simple icons
* Minimal text
* No clutter

---

## 5. Branding

### App Name

LitratoLink

### Tagline

Share Memories in Original Quality

### Color Direction

Main palette:

* Deep Maroon
* Warm Cream
* Soft Gold
* Off White
* Dark Brown or Near Black

### Logo

Logo will be added later.

---

## 6. Main Navigation

Recommended bottom navigation for mobile:

1. **Albums**
2. **Invites**
3. **Notifications**
4. **Profile**

Optional for later:

5. **Settings**

For V1, Settings can be inside Profile.

---

## 7. Main Screens List

V1 screens:

1. Splash Screen
2. Welcome Screen
3. Login Screen
4. Home / My Albums Screen
5. Create Album Screen
6. Album Details Screen
7. Upload Screen
8. Upload Progress Screen
9. File Preview Screen
10. Save / Download Screen
11. Members Screen
12. Invite Member Screen
13. Pending Invites Screen
14. Notifications Screen
15. Trash Screen
16. Profile Screen
17. Settings Screen
18. Error / Empty State Screens

---

# 8. Splash Screen

## 8.1 Purpose

The Splash Screen appears when the app opens.

## 8.2 Content

Show:

* LitratoLink logo
* App name
* Tagline

Text:

**LitratoLink**
Share Memories in Original Quality

## 8.3 Behavior

The app checks:

* Is the user logged in?
* Is the session valid?

If logged in:

* Go to Home / My Albums.

If not logged in:

* Go to Welcome / Login.

---

# 9. Welcome Screen

## 9.1 Purpose

The Welcome Screen explains what the app does.

## 9.2 Content

Main title:

**Share memories without losing quality.**

Subtitle:

**Create private albums, invite selected people, and share original-quality photos and videos.**

Button:

**Continue with Google**

Small text:

**Private albums. Original quality. No social feed.**

## 9.3 Behavior

When user taps **Continue with Google**:

* Open Google Login.
* After successful login, go to Home.

---

# 10. Login Screen

## 10.1 Login Method

V1 will use Google Login only.

Button:

**Continue with Google**

## 10.2 Login Rules

* User must log in before using the app.
* User cannot view albums without login.
* User cannot accept invites without login.

## 10.3 Login Error Message

If login fails:

**Login failed. Please try again.**

If internet is unavailable:

**No internet connection. Please check your connection and try again.**

---

# 11. Home / My Albums Screen

## 11.1 Purpose

This is the main screen after login.

It shows all albums where the user is an active member.

## 11.2 Content

Show:

* Greeting
* List of albums
* Create Album button
* Pending invite indicator if any

Example greeting:

**Your Albums**

Album card should show:

* Album name
* Album cover
* Number of files
* Number of members
* Last updated date
* User role in album

Example album card:

**Me and GF**
245 files · 2 members
Updated today
Role: Admin

## 11.3 Buttons

Main button:

**Create Album**

Album card tap:

* Opens Album Details.

## 11.4 Empty State

If user has no albums:

Title:

**No albums yet**

Message:

**Create your first private album and start sharing original-quality memories.**

Button:

**Create Album**

## 11.5 Rules

* Show only albums where user is an active member.
* Do not show deleted albums in normal view.
* Do not show albums where user was removed.
* Do not show public albums because V1 has no public albums.

---

# 12. Create Album Screen

## 12.1 Purpose

This screen allows a user to create a new private album.

## 12.2 Fields

Required:

* Album name

Optional:

* Description

## 12.3 Button

**Create Album**

## 12.4 Behavior

When user taps **Create Album**:

1. Validate album name.
2. Create album record.
3. Add creator as Admin.
4. Open the new album.

## 12.5 Rules

* Every user can create albums.
* Created albums are private by default.
* Creator becomes Admin automatically.

## 12.6 Error Messages

If album name is empty:

**Please enter an album name.**

If creation fails:

**Album could not be created. Please try again.**

---

# 13. Album Details Screen

## 13.1 Purpose

This screen shows the photos and videos inside an album.

## 13.2 Content

Show:

* Album name
* Album cover
* Member count
* File count
* User role
* Upload button if allowed
* Save All button
* Gallery grid
* Members button
* Trash button if user has deleted files

## 13.3 Main Buttons

Buttons:

* **Upload**
* **Save All**
* **Members**
* **Select**
* **Trash**

## 13.4 Button Visibility Rules

### Upload Button

Show only if user role is:

* Admin
* Contributor

Hide if user role is:

* Viewer

### Members Button

Show to all members, but actions inside depend on role.

### Invite Button

Show only to Admin.

### Save All Button

Show to:

* Admin
* Contributor
* Viewer

### Trash Button

Show if user has deleted files that they uploaded.

## 13.5 Gallery Behavior

The album gallery should show:

* Photos
* Videos
* Upload date
* Optional uploader name
* Video duration if file is video

Gallery should use thumbnails for preview.

When user downloads, the app must use the original file, not the thumbnail.

## 13.6 Empty Album State

If album has no files:

Title:

**No memories yet**

Message:

**Upload photos or videos to start this album.**

If user can upload:

Button:

**Upload Files**

If user is Viewer:

Message:

**No files have been added yet.**

---

# 14. Upload Flow

## 14.1 Purpose

The upload flow allows Admin and Contributor users to upload original-quality photos and videos.

## 14.2 Upload Entry Point

User taps:

**Upload**

from Album Details.

## 14.3 Upload Source Options

Mobile:

* Choose from Photos / Gallery
* Choose from Files

PC/Web:

* Choose files from computer
* Drag and drop if supported later

## 14.4 Upload Selection Screen

Show selected files before upload.

Content:

* File thumbnails
* File names
* File count
* Total size if possible

Button:

**Upload Original Files**

Small note:

**Files will be uploaded in original quality.**

## 14.5 Upload Rules

The app must:

* Upload the original file.
* Not compress the file.
* Not resize the file.
* Not convert the file.
* Preserve original file as much as possible.

## 14.6 Upload Progress Screen

Show:

* Number of files uploaded
* Current file name or count
* Progress bar
* Upload status

Example:

**Uploading 12 of 45**
Please keep the app open until upload is complete.

## 14.7 Upload Complete Screen

Message:

**Upload complete**

Subtext:

**Your original-quality files were added to the album.**

Button:

**Back to Album**

## 14.8 Upload Failure

If one file fails:

Message:

**Some files failed to upload.**

Options:

* Retry Failed
* Continue

If all files fail:

Message:

**Upload failed. Please check your connection and try again.**

## 14.9 Upload Permission Error

If user is no longer allowed to upload:

**You no longer have permission to upload to this album.**

---

# 15. File Preview Screen

## 15.1 Purpose

This screen shows one photo or video.

## 15.2 Content

Show:

* Photo or video preview
* Upload date
* Uploader name
* File type
* Download button
* Delete button if user is uploader
* More options button

## 15.3 Buttons

Buttons:

* **Download Original**
* **Delete**
* **Back**

## 15.4 Delete Button Visibility

Show Delete only if:

* Logged-in user is the original uploader.
* File is not deleted.

Do not show Delete for other users’ files.

## 15.5 Download Rule

Download button must download the original file.

It must not download the thumbnail.

---

# 16. Download Flow

## 16.1 Purpose

Users can download original-quality files from albums they can access.

## 16.2 Single Download

Flow:

1. User opens file.
2. User taps **Download Original**.
3. App asks for permission if needed.
4. App downloads original file.
5. App saves to device.

## 16.3 Download Options

Mobile:

* Save to Photos / Gallery
* Save to Files

PC/Web:

* Download file
* Future option: choose folder if supported

## 16.4 Download Success Message

**Saved successfully.**

## 16.5 Download Error Messages

If no permission:

**You do not have permission to download this file.**

If file is deleted:

**This file is no longer available.**

If internet error:

**Download failed. Please check your connection and try again.**

---

# 17. Save All Flow

## 17.1 Purpose

Save All is a core feature of LitratoLink.

It allows users to download many original files without downloading one by one.

## 17.2 Entry Point

Button:

**Save All**

Location:

* Album Details screen

## 17.3 Save All Options

When user taps Save All, show options:

* Save all files
* Save only photos
* Save only videos
* Select files manually

For V1, it can start simpler:

* Save All
* Select Files

## 17.4 Save All Confirmation

Before starting:

Title:

**Save all original files?**

Message:

**This will download all available photos and videos in original quality. Large albums may take time and use storage on your device.**

Buttons:

* **Start Saving**
* **Cancel**

## 17.5 Save All Progress

Show:

* Files saved count
* Total files
* Current progress
* Failed count if any

Example:

**Saving 25 of 120**

## 17.6 Save All Behavior

The app should:

* Download files one by one or in safe batches.
* Save the original files.
* Show progress.
* Allow retry for failed files.
* Avoid crashing on large albums.

## 17.7 Save All Complete

Message:

**Save All complete**

Subtext:

**Original-quality files were saved to your device.**

If some failed:

**Some files were not saved. You can retry them.**

Buttons:

* Retry Failed
* Done

---

# 18. Select Files Flow

## 18.1 Purpose

Users may choose only some files to download.

## 18.2 Entry Point

User taps:

**Select**

from Album Details.

## 18.3 Behavior

After tapping Select:

* Gallery changes to selection mode.
* User can tap files to select.
* Bottom action bar appears.

Bottom actions:

* Save Selected
* Cancel
* Select All

## 18.4 Save Selected Flow

1. User selects files.
2. User taps **Save Selected**.
3. App downloads original files.
4. App saves files to device.
5. App shows complete message.

---

# 19. Members Screen

## 19.1 Purpose

This screen shows album members.

## 19.2 Content

Show:

* Member name
* Email
* Role
* Join date
* Invite status if pending

## 19.3 Admin View

If user is Admin, show:

* Invite Member button
* Change role option
* Remove member option

## 19.4 Contributor and Viewer View

If user is Contributor or Viewer:

* They can view member list.
* They cannot invite.
* They cannot change roles.
* They cannot remove members.

## 19.5 Role Change Rules

Only Admin can change roles.

Roles:

* Admin
* Contributor
* Viewer

Important rule:

There must always be at least one Admin in an album.

## 19.6 Remove Member Rules

Only Admin can remove members.

If a member is removed:

* They lose access to the album.
* They stop receiving notifications.
* They can no longer download files from that album.

---

# 20. Invite Member Screen

## 20.1 Purpose

Admin can invite another user to an album.

## 20.2 Fields

Required:

* Email address
* Role

Default role:

* Viewer or Contributor

Recommended default:

**Viewer**

because it is safer.

## 20.3 Button

**Send Invite**

## 20.4 Flow

1. Admin enters email.
2. Admin chooses role.
3. Admin taps Send Invite.
4. Invite is created.
5. Invited user receives notification or email if possible.

## 20.5 Invite Message

Success:

**Invite sent.**

Error:

**Invite could not be sent. Please try again.**

If email is invalid:

**Please enter a valid email address.**

If user is already a member:

**This user is already a member of this album.**

---

# 21. Pending Invites Screen

## 21.1 Purpose

This screen shows album invites for the logged-in user.

## 21.2 Content

Show:

* Album name
* Invited by
* Role offered
* Date invited

Buttons:

* Accept
* Decline

## 21.3 Accept Invite Flow

1. User taps Accept.
2. App checks email match.
3. User becomes album member.
4. Album appears in My Albums.

Success message:

**You joined the album.**

## 21.4 Decline Invite Flow

1. User taps Decline.
2. Invite is marked declined or cancelled.
3. Album does not appear.

Message:

**Invite declined.**

## 21.5 Empty State

Title:

**No pending invites**

Message:

**Album invites will appear here.**

---

# 22. Notifications Screen

## 22.1 Purpose

This screen shows app notifications.

## 22.2 Notification Examples

Examples:

* New photos were added to your album.
* You were invited to an album.
* Your upload is complete.
* A member joined your album.

## 22.3 Notification Privacy Rule

Do not expose private file names in notifications.

Good:

**New photos were added to your album.**

Bad:

**IMG_9292_private.jpg was uploaded.**

## 22.4 Notification Actions

User can:

* Tap notification to open related album.
* Mark notification as read.
* Clear notification if supported later.

---

# 23. Trash Screen

## 23.1 Purpose

Trash shows deleted files that the current user uploaded.

Only the original uploader can restore their deleted files.

## 23.2 Entry Point

From Album Details:

* Tap Trash

or from Profile:

* My Deleted Files

## 23.3 Content

Show:

* Deleted files uploaded by current user
* Album name
* Deleted date
* Restore deadline

Example:

**Deleted 5 days ago**
**Restore available for 25 more days**

## 23.4 Restore Button

Button:

**Restore**

Visible only for files uploaded by the current user.

## 23.5 Restore Flow

1. User opens Trash.
2. User selects deleted file.
3. User taps Restore.
4. File returns to original album.
5. Album members can see it again.

## 23.6 Permanent Delete Warning

Show:

**Files in Trash may be permanently deleted after 30 days.**

## 23.7 Important Rule

Admin cannot restore files uploaded by other users.

Only original uploader can restore.

---

# 24. Delete File Flow

## 24.1 Purpose

Uploader can delete their own uploaded file.

## 24.2 Delete Button

Visible only if:

* User is the original uploader.
* File is not deleted.

## 24.3 Confirmation Dialog

Title:

**Delete this file?**

Message:

**This file will be removed from the album for everyone. You can restore it within 30 days.**

Buttons:

* Delete
* Cancel

## 24.4 Delete Result

After delete:

* File disappears from album for everyone.
* File appears in uploader’s Trash.
* File can be restored by uploader within 30 days.

---

# 25. Album Settings Screen

## 25.1 Purpose

Admin can manage album settings.

## 25.2 Admin Options

Admin can:

* Rename album
* Edit description
* Change cover
* Manage members
* Delete album

## 25.3 Non-Admin View

Contributor and Viewer should not see admin-only settings.

They may only see basic album info.

---

# 26. Profile Screen

## 26.1 Purpose

Shows user account information and app settings.

## 26.2 Content

Show:

* Profile photo
* Name
* Email
* App settings
* Notification settings
* Logout button

## 26.3 Buttons

* Notification Settings
* Privacy
* Help
* Logout

## 26.4 Logout Flow

When user taps Logout:

Dialog:

**Log out of LitratoLink?**

Buttons:

* Log out
* Cancel

After logout:

* User returns to Welcome screen.
* Device token should be disabled or removed.

---

# 27. Settings Screen

## 27.1 Purpose

Settings controls general app behavior.

V1 settings:

* Notification preferences
* Download preference if possible
* Privacy info
* Logout

Future settings:

* Theme
* Storage usage
* Premium plan
* Account deletion
* Linked accounts

---

# 28. Permission Messages

## 28.1 Photo Access Permission

Message:

**LitratoLink needs photo access so you can upload original-quality photos and videos.**

## 28.2 Save to Photos Permission

Message:

**LitratoLink needs permission to save original-quality files to your Photos.**

## 28.3 File Access Permission

Message:

**LitratoLink needs file access so you can choose and save files.**

## 28.4 Notification Permission

Message:

**Allow notifications so you know when new memories are added to your albums.**

---

# 29. Error Message Guidelines

Error messages should be:

* Simple
* Human
* Clear
* Not too technical

Bad:

**Error 403 forbidden exception**

Good:

**You do not have access to this album.**

---

## 29.1 Common Error Messages

### No Internet

**No internet connection. Please check your connection and try again.**

### Upload Failed

**Upload failed. Please try again.**

### Download Failed

**Download failed. Please try again.**

### Permission Denied

**You do not have permission to do this.**

### Album Not Found

**This album is no longer available.**

### File Not Found

**This file is no longer available.**

### Storage Full

**Upload failed because storage is currently full. Please try again later.**

### Invite Expired

**This invite has expired. Please ask for a new invite.**

---

# 30. Empty State Messages

## 30.1 No Albums

**No albums yet**
Create your first private album and start sharing original-quality memories.

## 30.2 No Files

**No memories yet**
Upload photos or videos to start this album.

## 30.3 No Invites

**No pending invites**
Album invites will appear here.

## 30.4 No Notifications

**No notifications yet**
Updates from your albums will appear here.

## 30.5 No Trash

**Trash is empty**
Deleted files you can restore will appear here.

---

# 31. Mobile UX Rules

## 31.1 Mobile Priority

V1 should prioritize mobile experience.

Important mobile actions:

* Upload from gallery
* Upload from files
* Save to Photos
* Save to Files
* Receive notifications
* View albums easily

## 31.2 iOS Rules

iOS needs clear permissions for:

* Photo access
* Save to Photos
* Notifications

The app should support:

* iPhone
* iPad

## 31.3 Android Rules

Android needs permissions for:

* Gallery access
* File access
* Save to storage
* Notifications

The app should work on common Android phones.

---

# 32. PC/Web UX Rules

PC/Web should be useful for upload and download.

Important PC/Web actions:

* Login
* Create album
* Upload files
* Drag and drop later
* View album
* Download files
* Save selected
* Save all

Future PC/Web improvement:

* Download as ZIP

---

# 33. Upload UX Rules

The upload experience should be clear.

Rules:

1. Show selected files before upload.
2. Show total file count.
3. Show upload progress.
4. Show failed files.
5. Allow retry.
6. Do not say upload complete until files are actually uploaded.
7. Do not compress files silently.
8. Tell users files are uploaded in original quality.

---

# 34. Download UX Rules

The download experience should be reliable.

Rules:

1. Show download progress.
2. Allow retry if download fails.
3. Use original files.
4. Never download thumbnail as final file.
5. Warn users when saving many files.
6. Save All should not crash on large albums.
7. If permission is denied, explain what is needed.

---

# 35. Privacy UX Rules

The app must make privacy clear.

Show simple messages like:

* This album is private.
* Only invited members can access this album.
* Members can only see albums where they are invited.

Avoid confusing users with technical storage details.

---

# 36. Role UX Rules

Users should understand their role.

In album details, show:

**Your role: Admin**

or

**Your role: Contributor**

or

**Your role: Viewer**

Button behavior should match the role.

Example:

Viewer should not see Upload button.

Contributor should not see Invite button.

Admin should see Invite and Manage Members.

---

# 37. Notification UX Rules

Notifications should be useful but not annoying.

Recommended notifications:

* Album invite
* New upload
* Upload complete
* Invite accepted

Avoid too many notifications.

If 50 photos are uploaded at once, do not send 50 notifications.

Send one grouped notification:

**New photos were added to your album.**

---

# 38. Accessibility Rules

The app should be easy to use.

Basic accessibility rules:

* Text should be readable.
* Buttons should be large enough.
* Color contrast should be clear.
* Important actions should have labels.
* Do not rely on color only.
* Use clear icons with text when possible.

---

# 39. Confirmation Dialogs

Use confirmation dialogs for important actions.

## 39.1 Delete File

**Delete this file?**
This file will be removed from the album for everyone. You can restore it within 30 days.

Buttons:

* Delete
* Cancel

## 39.2 Delete Album

**Delete this album?**
This album will be removed for all members. This action can affect all files inside the album.

Buttons:

* Delete Album
* Cancel

## 39.3 Remove Member

**Remove this member?**
This person will lose access to this album.

Buttons:

* Remove
* Cancel

## 39.4 Change Role

**Change member role?**
This will update what this person can do in the album.

Buttons:

* Change Role
* Cancel

---

# 40. V1 Screen Priority

## Must Build for MVP

1. Welcome / Login
2. Home / My Albums
3. Create Album
4. Album Details
5. Upload
6. Upload Progress
7. File Preview
8. Download Original
9. Save All
10. Members
11. Invite Member
12. Pending Invites
13. Trash
14. Profile

## Can Be Simple in V1

1. Notifications Screen
2. Settings Screen
3. Album Settings
4. Activity logs

## Future Screens

1. Premium Plans
2. Photographer Mode
3. Business Dashboard
4. White Label Settings
5. Storage Usage
6. Account Deletion

---

# 41. UX Non-Goals for V1

Do not add these in V1:

* Likes
* Comments
* Followers
* Public profiles
* Public albums
* Social feed
* Chat
* Photo filters
* Photo editing
* AI tools
* Marketplace
* Payment screen

These features can distract from the main goal.

---

# 42. Main User Flow Summary

## 42.1 First-Time User Flow

```text
Open app
 ↓
Welcome screen
 ↓
Continue with Google
 ↓
Profile created
 ↓
Home / My Albums
 ↓
Create album or accept invite
```

## 42.2 Create Album Flow

```text
Home
 ↓
Create Album
 ↓
Enter album name
 ↓
Create
 ↓
Album Details
```

## 42.3 Invite Flow

```text
Album Details
 ↓
Members
 ↓
Invite Member
 ↓
Enter email
 ↓
Choose role
 ↓
Send Invite
```

## 42.4 Upload Flow

```text
Album Details
 ↓
Upload
 ↓
Select photos/videos
 ↓
Upload Original Files
 ↓
Upload Progress
 ↓
Upload Complete
```

## 42.5 Receiver Flow

```text
Open app
 ↓
Open album
 ↓
View files
 ↓
Save All or select files
 ↓
Save original files
```

## 42.6 Delete and Restore Flow

```text
Open file
 ↓
Delete
 ↓
File moves to Trash
 ↓
Uploader opens Trash
 ↓
Restore within 30 days
```

---

# 43. Final UI/UX Decision Summary

Confirmed UI/UX decisions:

* App name is LitratoLink.
* Tagline is Share Memories in Original Quality.
* Design should be maroon-based.
* App should feel private, warm, and simple.
* Main structure is album-based.
* Home screen shows user albums.
* Albums are private by default.
* Users can create their own albums.
* Google Login only for V1.
* Users can upload photos and videos.
* Upload must keep original quality.
* Users can download original files.
* Save All is a core feature.
* Users can select files manually.
* Roles are Admin, Contributor, Viewer.
* Only Admin can invite and manage members.
* Only original uploader can delete and restore their own file.
* Deleted files stay restorable for 30 days.
* No social feed.
* No likes.
* No comments.
* No followers.
* TestFlight first.
* App Store later.

---

# 44. Next Recommended Document

The next recommended document is:

**LitratoLink Development Roadmap v1.0**

This document should define:

* Development phases
* MVP build order
* Sprint plan
* Feature priorities
* Testing plan
* TestFlight plan
* App Store preparation
* Future enhancement timeline
