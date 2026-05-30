# Sprint 1 Upload Debug Runbook

Use this when upload fails.

1. Confirm selected file name, MIME type, size, and local path are logged.
2. Confirm `create-upload-session` receives `album_id`, `original_filename`, `mime_type`, `file_size_bytes`, and `file_type`.
3. Confirm user role is Admin or Contributor.
4. Confirm Google Drive root folder secret exists.
5. Confirm pending `storage_objects` and `media_files` records are created.
6. Confirm the Google resumable upload URL is returned.
7. Confirm Flutter sends original bytes with the required `Content-Type`.
8. Confirm Google Drive response includes an `id`.
9. Confirm `complete-upload` receives `provider_file_id`.
10. Confirm `media_files.upload_status` becomes `completed`.

Never mark upload complete unless Google Drive confirms the file.
