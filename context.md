# context.md

Project context for Potoos. Companion to `AGENTS.md`.

## What It Is

A private, invite-only photo and video sharing PWA that lets people upload,
share, and download memories in **original quality** — no compression. No public
feed, no likes/comments/followers. Access is role-based per album.

- Tagline: *Original memories, safely shared.*
- Current brand: **Potoos** (mascot **Poto**).

## Problem It Solves

Messaging and social apps compress photos/videos. Potoos targets moments
where original quality matters: family albums, events, school projects, client
shoots — shared only with invited people.

## Roles

| Role | View | Download | Upload | Manage Members |
| --- | --- | --- | --- | --- |
| Admin | Yes | Yes | Yes | Yes |
| Contributor | Yes | Yes | Yes | No |
| Viewer | Yes | Yes | No | No |

The database prevents downgrading or removing the final active Admin.

## Architecture

- **Flutter Web PWA** — UI, Riverpod state management.
- **Supabase Auth** — Google sign-in. Web login sends an explicit app-root
  `redirectTo` so localhost and GitHub Pages return correctly after OAuth.
- **Supabase Postgres + RLS** — albums, members, media, profiles. Access is
  membership-based.
- **Supabase Edge Functions** — all sensitive backend work (profile/album
  creation, upload/download proxying, invite/remove member).
- **Google Drive API** — original file storage, server-side only. Flutter sends
  original bytes to an Edge Function; it never receives Google access tokens.

### Upload/Download Flow (Sprint 1)

Flutter sends original bytes to `upload-original-file` (currently base64 JSON
for reliability); the Edge Function stores them in Google Drive. Downloads are
proxied through `download-original-file`. File Preview shows a downloaded-size
vs expected-original-size check; debug logs include SHA-256 checksums.

> Note: the base64-JSON upload path is acceptable for the Sprint 1 proof but
> larger production uploads should move to resumable/chunked uploads. Do not
> start that refactor without a written plan.

## Security Summary

- Flutter contains only the client-safe Supabase URL and anon key.
- Service role and Google Drive credentials live only in Edge Function secrets.
- Viewer upload is blocked in both UI and backend.
- Upload completion re-checks Admin/Contributor permission before accepting
  bytes; downloads check active membership.

## Code Layout (`app/lib`)

- `app/` — app shell, theme, routes
- `config/` — env loading (`env.dart` reads `env.properties`)
- `core/` — services (Supabase, Edge Functions, file), widgets, errors, utils
- `features/auth` — login, profile, auth providers/repository
- `features/albums` — albums, members, media; providers/repository/screens
- `features/uploads` — upload flow
- `features/downloads` — download + Save All (ZIP)

## Current State

Sprint 1 closed; local + live QA passed. The only code fix surfaced by live QA
was the GitHub Pages dotfile config issue (now `env.properties`). Error UX was
then hardened so raw exception text never reaches the UI (`AppError.messageFor`
+ network-aware Edge Function error mapping).
