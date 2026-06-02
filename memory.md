# memory.md

Durable lessons and state for LitratoLink that are not obvious from the code.
Keep entries short; update when they change.

## Lessons Learned

### GitHub Pages drops dotfiles (cost a long debug session)

The hosted PWA loads runtime config from a bundled Flutter asset via
`flutter_dotenv`. GitHub Pages does not serve files whose names begin with a
dot, so a bundled `.env` returned 404 at `assets/.env` even though Flutter
listed it in the AssetManifest. The app then loaded empty config and showed
"Add Supabase URL and anon key before signing in."

- It looks like a secrets/anon-key problem but is purely a hosting quirk; the
  local build and GitHub secrets were always correct.
- Fix: ship config as the non-hidden asset `app/env.properties` (pubspec asset,
  dotenv `fileName`, and CI workflow all updated).
- Verify any deploy: `https://akircyno.github.io/litratolink/assets/env.properties`
  must be 200 with non-empty values. This will matter again during the future
  Potoos repo/URL migration.

### Anon key format

Use the legacy JWT anon key (`eyJ...`, decodes to `"role":"anon"`), not the new
`sb_publishable_...` key, with `supabase_flutter ^2.12.4`. The service-role key
must never appear in the Flutter app config.

## Project State (as of 2026-06-02)

- Sprint 1 closed: local + live PWA QA all passed.
- Live beta: `https://akircyno.github.io/litratolink/`.
- Verified live: hosted Google login, second-account Viewer/Contributor roles,
  member remove/re-add, Save All with multiple files.
- Error UX hardened: `AppError.messageFor` + network-aware Edge Function error
  mapping so raw exception text never reaches the UI.

## Deferred / Do Not Start Without Direction

- Potoos rename/rebrand (do not start until explicitly asked).
- Production upload refactor (resumable/chunked) — needs a written plan first.
- TestFlight / native packaging.
- Any UI redesign.

## Deployed Edge Functions

`create-user-profile`, `create-album`, `test-google-drive-connection`,
`create-upload-session`, `complete-upload`, `upload-original-file`,
`download-original-file`, `invite-album-member`, `remove-album-member`.
