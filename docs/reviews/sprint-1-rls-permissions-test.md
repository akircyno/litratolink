# Sprint 1 RLS and Permissions Test

Status: pending live Supabase project.

## Expected Protection

- Non-members cannot read private albums.
- Non-members cannot read media metadata.
- Non-members cannot upload to another user's album.
- Non-members cannot download another user's file.
- Viewers cannot upload.
- Admins and Contributors can upload.

## Policies Reviewed

- Album reads require active membership.
- Media file reads require active album membership and completed active files.
- Client storage object insert/update is not allowed.
- Upload completion is backend-controlled through `complete-upload`.
- Client-side media status update cannot mark records completed.

## Live Test Matrix

1. User A creates album.
2. User A uploads file.
3. User B remains non-member.
4. User B attempts album read.
5. User B attempts media read.
6. User B attempts upload session.
7. User B attempts download access.
8. Manually add User B as Viewer and confirm upload is blocked.
9. Manually set User B as Contributor and confirm upload is allowed.
10. Manually set User B as Admin and confirm upload is allowed.

## Current Risk To Revisit

The Sprint 1 SQL keeps direct album insert allowed for authenticated users where `owner_id = auth.uid()`, matching the prompt. The production path should still prefer the `create-album` Edge Function so owner membership is created atomically.
