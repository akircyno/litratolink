# Sprint 1 Download Debug Runbook

Use this when download fails.

1. Confirm `media_file_id` belongs to a completed media file.
2. Confirm file is not deleted or permanently deleted.
3. Confirm album is not deleted.
4. Confirm the user is an active album member.
5. Confirm `storage_objects.provider_file_id` is present.
6. Confirm `download-original-file` is deployed.
7. Confirm the Edge Function returns the original bytes with file metadata headers.
8. Confirm saved file path is logged.
9. Compare downloaded size with expected original size.
10. If sizes differ, inspect for partial download or wrong Drive file ID.

Never use a thumbnail or public permanent link for Sprint 1 download proof.
