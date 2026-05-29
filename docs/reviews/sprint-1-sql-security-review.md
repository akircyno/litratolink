# Sprint 1 SQL Security Review

Reviewed migration: `supabase/migrations/20260529150000_sprint_1_core.sql`

## Result

The Sprint 1 core migration is safe enough to proceed to Edge Function scaffolding.

## Fix Applied

- Tightened `media_files` insert and update policies so authenticated clients can only create or keep upload records in `pending`, `uploading`, or `failed` states.
- This prevents a client from directly marking a file as `completed`; completion must happen through the backend `complete-upload` flow.

## Security Notes

- `storage_objects` has no client insert or update policy. This keeps provider file IDs and download metadata under backend control.
- Album creation currently follows the Sprint 1 prompt policy: authenticated users may create albums where `owner_id = auth.uid()`.
- Admins can insert and update album members per the Sprint 1 prompt. The invite flow should later wrap this with an Edge Function for validation and notification behavior.
- No delete policies are enabled yet, which is acceptable for Sprint 1.

## Next Review Point

Review the Edge Functions before connecting the Flutter app to live Supabase, especially:

- service role usage
- album membership checks
- Google Drive upload completion
- signed or proxied download access
