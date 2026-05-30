# Sprint 1 Core Flow Test

Status: pending live Supabase and Google Drive setup.

## Local Checks

- Flutter static analysis: pending latest full run.
- Flutter widget tests: pending latest full run.
- No app-side compression, resize, or conversion path found.
- Upload flow is wired as: select original file, call `create-upload-session`, PUT original bytes to Google upload URL, call `complete-upload`.
- Download flow is wired as: call `get-download-access`, download original bytes, save locally.

## Live Test Checklist

1. Open app.
2. Log in with Google.
3. Confirm `user_profiles` record is created.
4. Create album.
5. Confirm creator becomes Admin.
6. Open album.
7. Select one original photo.
8. Upload photo.
9. Confirm file exists in Google Drive.
10. Confirm `storage_objects` record exists.
11. Confirm `media_files` record exists.
12. Confirm `upload_status = completed`.
13. Open uploaded file.
14. Download original file.
15. Compare original and downloaded file size.
16. Confirm non-member access is blocked.

## Current Blocker

Supabase project, Edge Function secrets, Google OAuth, and Google Drive credentials must be configured before this test can be executed end to end.
