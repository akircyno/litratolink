# Potoos Sprint 1 Rules Review

Last updated: 2026-06-01

## Result

Sprint 1 is in a working proof-flow state for private original-quality albums.

## Pass / Watch List

| Rule | Status | Notes |
| --- | --- | --- |
| Preserve original quality | Pass | Upload sends selected bytes to Edge Function; download compares expected size and debug SHA-256 logs are available. |
| No compression, resizing, or conversion | Pass | No image/video processing code is used in Flutter or Edge Functions. |
| Thumbnails separate or deferred | Pass | Gallery uses visual placeholders; original files remain the protected source. |
| Secrets kept out of Flutter | Pass | Service role and Google credentials stay in Supabase Edge Function secrets. |
| Protected actions use Edge Functions | Pass | Profile creation, album creation, upload session, original upload, original download, invite, and remove member use Edge Functions. |
| Google login works | Pass | Live browser testing confirmed Google OAuth sign-in and profile creation. |
| Albums private by default | Pass | Album reads require active membership through RLS. |
| RLS protects private data | Pass | Album, member, media, storage object, and profile reads are scoped to membership. |
| Non-members blocked | Needs manual re-test | Policies and download function block non-members; still worth re-testing with User A/User B after latest migrations. |
| Feature organization | Pass | Code remains grouped by auth, albums, uploads, downloads, and shared core services. |
| `main.dart` stays lean | Pass | App setup and routing remain outside `main.dart`. |
| Friendly errors | Pass | Common upload, download, invite, and permission failures map to user-friendly messages. |
| No social feed behavior | Pass | Invites/activity are private album workflow surfaces, not public social features. |
| Future features avoided | Pass | Trash/thumbnails/notifications remain outside Sprint 1 backend scope. |

## Recent Hardening

- Album timestamps are touched after successful upload and member changes.
- Upload completion re-checks current Admin/Contributor access.
- Direct pending media row updates require current Admin/Contributor access.
- Database trigger prevents downgrading or removing the final active album Admin.
- Album Details uses freshly loaded member data for the current role controls.

## Manual QA Still Recommended

1. User A creates an album and uploads two files.
2. User A invites User B as Viewer.
3. User B confirms view/download works and upload is hidden/blocked.
4. User A updates User B to Contributor.
5. User B confirms upload works.
6. User A removes User B.
7. User B refreshes/signs in again and confirms album access disappears.
8. User A re-adds User B and confirms access returns.
9. Save selected files and Save All, then open the ZIP and compare original sizes.
10. Use debug logs to compare SHA-256 values for upload/download where possible.
