# Sprint 1 Core Flow Test

Status: passed live Supabase and Google Drive smoke test.

## Local Checks

- Flutter static analysis: passed.
- Flutter widget tests: passed.
- Flutter web release build: passed.
- No app-side compression, resize, or conversion path found.
- Upload flow is wired as: select original file, call `create-upload-session`, send original bytes to `upload-original-file`, and let the Edge Function upload to Google Drive.
- Download flow is wired as: call `download-original-file`, let the Edge Function fetch original bytes from Google Drive, then save locally/browser downloads.

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

## Live Result

- Google login created `user_profiles`.
- Album creation created `albums` and Admin membership.
- `IMG_3778.JPG` uploaded successfully as a completed media file.
- Download Original completed through the browser download flow.
- Stale pending upload test rows were removed from `media_files` and `storage_objects`.
