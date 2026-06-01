# LitratoLink Reviewer Brief

Last updated: 2026-06-01

This file is the short answer sheet for reviewers, classmates, testers, or anyone asking what the app is and why it exists.

## One-Sentence Answer

LitratoLink is a private, invite-only photo and video sharing app that lets people upload, share, and download memories in original quality.

## Future Brand Note

The planned international brand is **Potoos**, with mascot **Poto** and tagline:

```text
Original memories, safely shared.
```

The current working app and codebase still use **LitratoLink** until the rename is done in one clean migration.

## Problem It Solves

Many messaging and social apps compress photos and videos. LitratoLink is designed for moments where original quality matters, such as family albums, events, school projects, client shoots, and shared memories that should not be reduced by compression.

## What Makes It Different

- Private albums only
- Invited people only
- Original-quality upload and download
- No public feed
- No likes, comments, or follower system
- Role-based access for album members
- Save All download for collecting album originals

## Main Users

- Album owner/Admin
- Family or friends invited to an album
- Contributors who can upload memories
- Viewers who can only view and download originals

## Core Roles

| Role | Can View | Can Download | Can Upload | Can Manage Members |
| --- | --- | --- | --- | --- |
| Admin | Yes | Yes | Yes | Yes |
| Contributor | Yes | Yes | Yes | No |
| Viewer | Yes | Yes | No | No |

## Current Sprint 1 User Flow

1. User signs in with Google.
2. App creates or refreshes the user's profile.
3. User creates a private album.
4. Creator becomes the album Admin.
5. Admin uploads original photos through the app.
6. Files are stored through server-side Google Drive handling.
7. Album members can view files.
8. Members can download original files.
9. Admin can invite an existing signed-in user by email.
10. Admin can update or remove another member.
11. Save All downloads album originals as one ZIP file.

## Current Technical Stack

- Flutter Web PWA for the app UI
- Supabase Auth for Google sign-in
- Supabase Postgres for albums, members, media, and profiles
- Supabase Row Level Security for membership-based access
- Supabase Edge Functions for sensitive backend work
- Google Drive API for original file storage
- GitHub Pages for the PWA beta deployment

## Security And Privacy Summary

- Users must sign in with Google.
- Albums are private by default.
- Album access is based on active membership.
- Flutter does not contain the Supabase service role key.
- Google Drive credentials stay in Supabase Edge Function secrets.
- Flutter uploads original file bytes to an Edge Function.
- Downloads are proxied through an Edge Function.
- Viewers are blocked from upload in both UI and backend checks.
- The database prevents removing or downgrading the final active album Admin.

## Current Beta Link

```text
https://akircyno.github.io/litratolink/
```

## Current Testing Status

Already verified:

- Google login works locally.
- User profile creation works.
- Album creation works.
- Original upload works.
- Original download works.
- Uploaded/downloaded test file size matched the original.
- Invite form handles unregistered emails with a friendly message.
- Admin can manage member roles in the app.
- Save All creates a browser-friendly ZIP flow in the app.

Still important to test:

- Live PWA login after Supabase redirect URLs are added.
- Second registered account as Viewer.
- Viewer can view/download but cannot upload.
- Contributor can upload.
- Removed member loses access after refresh/sign-in.
- Save All with two or more completed files on the live PWA.

## Safe Short Pitch

LitratoLink is for sharing private albums without losing the real file quality. Instead of posting memories publicly or sending compressed copies through chat apps, users create an invite-only album where trusted people can upload, view, and download the originals.

## What Not To Claim Yet

Do not claim these until they are implemented and verified:

- Mobile App Store release
- TestFlight release
- public production launch
- video upload production readiness
- unlimited large-file support
- payment or subscription support
- full Potoos rebrand in the live app
