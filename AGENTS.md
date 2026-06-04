# AGENTS.md

Operating guide for AI agents working on Potoos. Read this first, then
`docs/CLAUDE_CODE_HANDOFF.md` for the full handoff.

## Project

Potoos is a Flutter Web PWA for private, invite-only photo/video albums
with original-quality upload and download. Live beta:
`https://akircyno.github.io/potoos/`

- Current brand: **Potoos** (mascot **Poto**)
- Stack: Flutter Web PWA, Supabase (Auth + Postgres + RLS + Edge Functions),
  Google Drive (server-side storage), GitHub Pages deploy via GitHub Actions.

## Paths

- Root repo: `C:\dev\Potoos`
- Flutter app: `C:\dev\Potoos\app`
- UI source of truth: `docs/ui-reference/potoos_mobile_ui.html`
- Web runtime config: `app/env.properties` (NOT `.env` — see Hosted Config)

## Hard Rules

- Do **not** redesign the UI. Match the HTML mockup.
- Do **not** reintroduce old predecessor naming or URLs.
- Never commit secrets: service role keys, Google client secrets, refresh
  tokens, or real env files. Flutter may only use the client-safe Supabase URL
  and anon/publishable key.
- Do not stage local tooling: `.claude/`, `.agents/skills/`, `skills-lock.json`,
  `awesome-codex-skills/`, `supabase/.temp/`.
- Commit only meaningful, verified progress. Commit from the root repo, never
  from `app/`. Pushing to `main` triggers the production deploy — get explicit
  authorization before pushing.

## Build & Verify

Run from `C:\dev\Potoos\app`:

```powershell
flutter test
flutter analyze
flutter build web --release
```

Local preview:

```powershell
flutter build web --release
py -m http.server 8080 --directory build\web   # http://localhost:8080
```

## Git Workflow

```powershell
cd C:\dev\Potoos
git status --short
git add <specific files only>
git commit -m "<message>"
git push origin main   # only when authorized; triggers deploy
```

## Hosted Config (Critical Gotcha)

GitHub Pages does NOT serve files whose names begin with a dot. The web runtime
config therefore ships as the non-hidden asset `app/env.properties`:

- `app/pubspec.yaml` lists `env.properties` as an asset.
- `app/lib/config/env.dart` loads `fileName: 'env.properties'`.
- `.github/workflows/pwa-beta.yml` writes it from repo secrets.

If the hosted app shows "Add Supabase URL and anon key before signing in," the
config asset is 404ing. Verify a deploy:
`https://akircyno.github.io/potoos/assets/env.properties` must return 200
with non-empty `SUPABASE_URL` and `SUPABASE_ANON_KEY`. Never reintroduce a
dot-prefixed config asset for the hosted build.

## Current State

Sprint 1 is closed: local + live PWA QA passed (hosted Google login, second
account Viewer/Contributor roles, member remove/re-add, Save All with multiple
files). See `docs/SPRINT1_FINAL_REVIEW.md`. The next major track is undecided.

## Key Docs

- `docs/CLAUDE_CODE_HANDOFF.md` — main handoff
- `docs/CODEX_PROJECT_WORKFLOW.md` — working agreement
- `docs/SPRINT1_FINAL_REVIEW.md` — Sprint 1 status (QA closed)
- `docs/SPRINT1_TEST_CHECKLIST.md` — manual QA checklist
- `docs/PWA_BETA_ACCESS.md` — hosting/deploy notes
- `docs/APP_REVIEWER_BRIEF.md` — product summary
- `context.md`, `memory.md`, `skills.md` — see siblings of this file
