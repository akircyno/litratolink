# Potoos — Codex Handoff Document

**Last updated:** 2026-06-04  
**Repo:** `https://github.com/akircyno/potoos` (main branch)  
**Deployed PWA:** `https://akircyno.github.io/potoos/`  
**Owner:** akircyno (prcmarketingteam@gmail.com)

---

## 1. What This App Is

Potoos is a **private, invite-only photo and video sharing app** built with Flutter (web/iOS/Android). Key concepts:

- Users sign in with Google OAuth
- They create "spaces" (albums) and invite people by email
- Every file uploads at original quality to Google Drive (no compression)
- Only invited members can see a space — no public feeds
- Files can be downloaded back at full original quality as a ZIP
- The mascot is "Poto" — a cute owl — shown throughout the app

**Primary platform right now:** PWA deployed to GitHub Pages (web)  
**Native targets:** iOS (`com.potoos.app`) and Android (`com.potoos.app`) — not yet submitted to stores

---

## 2. Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter 3.x (Dart SDK >=3.4.0) |
| State management | Riverpod 3.x |
| Backend / DB | Supabase (PostgreSQL + RLS) |
| Auth | Supabase Auth + Google OAuth |
| File storage | Google Drive API (via Edge Functions) |
| Edge Functions | Supabase Edge Functions (Deno/TypeScript) |
| Email | Resend API (invite emails) |
| CI/CD | GitHub Actions → GitHub Pages |
| Crash reporting | Sentry (code wired, DSN not yet set) |

---

## 3. Repository Structure

```
c:/dev/LitratoLink/
├── app/                          ← Flutter app
│   ├── lib/
│   │   ├── app/                  ← theme, routes, app.dart, main.dart
│   │   ├── config/               ← env.dart (reads env.properties)
│   │   ├── core/
│   │   │   ├── errors/           ← AppError
│   │   │   ├── services/         ← supabase, edge functions, file, PWA install
│   │   │   └── widgets/          ← AppButton, AppCard, PotoMascot, AppToast, etc.
│   │   └── features/
│   │       ├── albums/           ← Home, AlbumDetails, Create, Members screens
│   │       ├── auth/             ← Splash, Login, Onboarding screens
│   │       ├── downloads/        ← FilePreview, SaveAll screens
│   │       └── uploads/          ← Upload, UploadProgress screens
│   ├── assets/
│   │   ├── mascot/               ← poto_idle/happy/working/waiting/error.webp
│   │   │                           poto_wave_01–12.webp (login animation frames)
│   │   ├── logo/                 ← potoos_logo.webp (app icon source), google_g.svg
│   │   ├── fonts/                ← GeneralSans, Inter
│   │   └── branding/             ← character sheet, expression sheet
│   ├── web/
│   │   ├── index.html            ← PWA manifest, beforeinstallprompt capture
│   │   ├── manifest.json         ← PWA manifest (name: Potoos, theme: #21070D)
│   │   ├── privacy.html          ← Live privacy policy
│   │   └── terms.html            ← Live terms of use
│   ├── test/                     ← 24 tests, all passing
│   └── env.properties            ← LOCAL ONLY (gitignored) — Supabase keys, etc.
├── supabase/
│   └── functions/                ← All deployed Edge Functions
│       ├── _shared/              ← auth, supabaseAdmin, googleDrive, email, etc.
│       ├── archive-album/        ← archive OR unarchive (archive: bool param)
│       ├── complete-upload/      ← marks upload done + stores thumbnail_url
│       ├── create-album/
│       ├── create-upload-session/
│       ├── create-user-profile/
│       ├── delete-account/       ← wipes Drive folder + all DB records + auth user
│       ├── delete-album/         ← wipes Drive folder + all DB records
│       ├── download-original-file/
│       ├── invite-album-member/  ← also sends Resend invite email
│       ├── leave-album/
│       ├── remove-album-member/
│       ├── test-google-drive-connection/
│       └── upload-original-file/
└── docs/
    ├── CODEX_HANDOFF.md          ← this file
    ├── POTOOS_BUILD_ROADMAP.md   ← phase-by-phase checklist
    └── POTOOS_V2_ROADMAP.md      ← V2 features (Transfer Admin, Sprite Sheets, etc.)
```

---

## 4. Environment / Secrets

### Local dev (`app/env.properties` — gitignored)
```
APP_ENV=development
SUPABASE_URL=https://srquwfxaknsoiuvmlrxy.supabase.co
SUPABASE_ANON_KEY=<anon key>
GOOGLE_WEB_CLIENT_ID=<oauth client id>
GOOGLE_IOS_CLIENT_ID=<ios oauth client id>
SENTRY_DSN=                        ← empty = Sentry inactive (V2)
```

### GitHub Actions secrets (for CI deploy)
Same keys as above, set in repo Settings → Secrets → Actions.

### Supabase Edge Function secrets
- `GOOGLE_DRIVE_CLIENT_ID`
- `GOOGLE_DRIVE_CLIENT_SECRET`
- `GOOGLE_DRIVE_REFRESH_TOKEN` — for `potoos.storage@gmail.com`
- `GOOGLE_DRIVE_ROOT_FOLDER_ID`
- `RESEND_API_KEY` — **already set**, invite emails are active

### Supabase Auth redirect URLs (configured)
- `https://akircyno.github.io/potoos/`
- `http://localhost:3000/`
- `http://localhost:5000/`
- `http://localhost:8080/`
- `io.supabase.flutter://callback`

---

## 5. Running the App Locally

```bash
cd c:/dev/LitratoLink/app

# Install deps
flutter pub get

# Run on web (pick a port that matches your Supabase redirect URLs)
flutter run -d chrome --web-port 5000

# Hot restart (R) after structural changes
# flutter analyze lib/   ← should always be zero issues
# flutter test           ← 24 tests, all should pass
```

### Deploying Edge Functions
```bash
cd c:/dev/LitratoLink
npx supabase functions deploy <function-name>
# Example: npx supabase functions deploy invite-album-member
```

---

## 6. Design System

All design tokens live in `app/lib/app/theme.dart`.

### Key colors
```dart
AppColors.midnightBurgundy  // #21070D — dark gradient top
AppColors.deepMaroon        // #4A1220 — headers
AppColors.velvetMaroon      // #6B1C2E — primary buttons, accents
AppColors.brightGold        // #F1C85B — CTA gold, icons, toasts
AppColors.warmCream         // #FAF6F0 — screen background
AppColors.pearlCream        // #FFF8E8 — text on dark
AppColors.featherTaupe      // #B9A58A — muted text
AppColors.charcoalInk       // #24191B — body text
```

### Spacing (`AppSpacing`)
`xs=4, sm=8, md=16, lg=24, xl=40, xxl=56`  
Radii: `radiusSm=8, radiusMd=12, radiusLg=18, radiusXl=24, radiusPill=999`

### Shadows (`AppShadows`)
`.card`, `.float`, `.header`, `.primaryButton`, `.goldButton`

### Gradients (`AppGradients`)
`.header` — `midnightBurgundy → deepMaroon` (used on all screen headers)  
`.splash` — same, full screen

### Key shared widgets
| Widget | File | Purpose |
|---|---|---|
| `AppButton` | `core/widgets/app_button.dart` | Primary / Gold / Ghost variants |
| `AppCard` | `core/widgets/app_card.dart` | White card with shadow |
| `PotoMascot` | `core/widgets/poto_mascot.dart` | Animated Poto with idle float |
| `PotoWave` | `core/widgets/poto_mascot.dart` | 12-frame waving animation (login/splash) |
| `AppToast` | `core/widgets/app_toast.dart` | `showAppToast(context, message:)` |
| `AppDivider` | `core/widgets/app_divider.dart` | Thin creamLine divider |
| `RoleChip` | `core/widgets/role_chip.dart` | Admin / Contributor / Viewer badge |
| `PwaInstallBanner` | `core/widgets/pwa_install_banner.dart` | 10s delayed install prompt |

### Page transitions (defined in `app/lib/app/routes.dart`)
- `splash / login / onboarding` → **fade** 280ms
- `upload / saveAll / createAlbum` → **slide up** 320ms  
- Everything else → **slide right** (iOS push style) 300ms

---

## 7. Feature Map — What's Built

### Auth flow
- Splash → checks session + onboarding seen flag
- First visit (no session, no flag) → **Onboarding** (3 pages: Meet Poto, Privacy, Quality) → Login
- Returning (no session, flag set) → **Login**
- Has session → **Home**
- Login uses standard Google button (`flutter_svg` Google G logo)

### Home screen (4 tabs)
1. **Albums** — list of active albums, stat cards, quality promise card
   - Empty state: Poto waiting + Create Album CTA
   - Archived section: collapsible "Archived (N)" at bottom, each row has Restore button
   - FAB only shown when albums exist
2. **Invites** — split into "Spaces you manage" + "Spaces you're in"
   - Each row shows album thumbnail or gradient swatch + role + Manage/View CTA
3. **Activity** — albums with files shown as notification items (brightGold when has files)
4. **Profile** — avatar, name, stats, Legal & Support card (Privacy/Terms/Support links), Logout, Delete Account

### Album Details
- Collapsing `SliverAppBar` with full-bleed gradient cover (400px expanded → compact bar)
- Album name + originals count + members count overlaid on cover
- Role badge top-right; custom back button top-left
- **`···` menu** (Admin only): Rename (bottom sheet), Archive, Delete permanently
- Action strip: Upload / Save All / Members pills
- 3-column SliverGrid with 2px gaps
- Selection mode: checkmark overlays + sticky `_SelectionBar` with brightGold Save CTA
- After rename: toast + pop once (back to list). After archive/delete: toast + pop to home.

### Upload flow
- Upload screen: single "Choose Photos & Videos" picker, drop zone with Poto, thumbnail strip
- Upload Progress: Poto working/happy/error, gradient progress bar, per-file rows
- Smart retry: "Try Again" skips already-completed files

### Save All (Download)
- Same emotional arc as Upload Progress
- Packs files into ZIP, triggers FilePicker save dialog
- Split CTA on complete: "Save Again" ghost + "Back to Album" primary

### Members
- Invite form at top (admin only), sends Resend email to invitee
- Member list: avatar, name, role chip, `···` manage menu (admin only)
- Leave button (non-admin) at bottom

### File Preview
- Dark `midnightBurgundy` background (cinema mode)
- Photo preview hero at 50% screen height with gradient + texture
- warmCream info panel slides up from bottom
- Sticky download bar: brightGold button → progress bar → done state

### Create Album
- Live preview card that updates as user types
- "Create Space" CTA disabled until name is entered

### Profile
- 96px avatar with brightGold border
- Stats: originals / albums / people
- Legal & Support card (Privacy Policy, Terms, Contact support — all open in browser)
- Logout + Delete Account

---

## 8. Supabase Schema (key tables)

| Table | RLS | Notes |
|---|---|---|
| `albums` | ✅ | `is_deleted`, `is_archived`, `storage_provider_id` (Drive folder), `cover_thumbnail_url` |
| `album_members` | ✅ | `role` (admin/contributor/viewer), `is_active` |
| `media_files` | ✅ | `upload_status`, `is_deleted`, `permanently_deleted_at`, `thumbnail_url` |
| `storage_objects` | ✅ | Maps to Drive file ID via `provider_file_id` |
| `user_profiles` | ✅ | `display_name`, `email`, `avatar_url`, `is_active`, `is_banned` |
| `storage_providers` | ✅ | Google Drive config |

**RLS audit passed June 2026.** Two gaps were fixed:
- `albums` UPDATE: can no longer soft-delete directly from client
- `user_profiles` UPDATE: users can't self-deactivate or self-ban

---

## 9. What's Fully Done

- ✅ Full app redesign — every screen (Login, Onboarding, Splash, Home×4 tabs, Album Details, Upload, Upload Progress, Save All, Members, File Preview, Create Album, Profile)
- ✅ Design system (tokens, shadows, gradients, transitions, AppButton 3 variants, AppCard)
- ✅ Poto mascot: 5 expression WebPs + 12-frame wave animation (login/splash)
- ✅ App icon (Poto on iOS, Android, Web/PWA, macOS, Windows)
- ✅ Standard Google login button (real Google G SVG)
- ✅ Album cover thumbnails from latest uploaded file (Drive `thumbnailLink`)
- ✅ Album rename / archive / unarchive / delete (Drive cleanup on delete)
- ✅ Account deletion (Drive + DB + auth — App Store compliant)
- ✅ Onboarding (3 pages, first-run only, stored in SharedPreferences)
- ✅ Privacy Policy + Terms of Use at live GitHub Pages URLs
- ✅ Legal & Support links in Profile tab
- ✅ Invite emails via Resend (active — `RESEND_API_KEY` set in Supabase)
- ✅ Toast notifications on all management actions
- ✅ Upload smart retry (skips completed files)
- ✅ Offline / network error detection in `AppError.messageFor()`
- ✅ RLS audit (all 6 tables, two hardening SQL migrations applied)
- ✅ PWA install banner (10s delay, 14-day cooldown, conditional on `beforeinstallprompt`)
- ✅ Sentry code wired (inert until DSN added to `env.properties`)

---

## 10. What's NOT Done (Next Steps)

### Immediate — activate before real users

**A. Sentry crash reporting (V2, code ready)**
- Go to sentry.io → free account → New Project → Flutter → copy DSN
- Add `SENTRY_DSN=<dsn>` to `app/env.properties`
- Add `SENTRY_DSN` as GitHub Actions secret for the deployed PWA
- Code is already in `main.dart`: `SentryFlutter.init(...)` — just needs the DSN

### Before TestFlight

**B. App Store screenshots (Phase 14)**
- Required: iPhone 6.9" (1320×2868px) and 6.5" (1242×2688px)
- Optional but recommended: iPad 13"
- Take screenshots of: Onboarding, Login, Albums tab (with albums), Album Details (with photos), Upload, Profile
- Upload to App Store Connect

**C. App Store description + keywords (Phase 14)**
- Short description (30 chars): "Private photo spaces for real memories"
- Long description draft exists in `docs/` folder
- Keywords (100 chars max): private album, photo sharing, original quality, invite only, memories

**D. Demo account for App Review (Phase 14)**
- Apple reviewers need to log in — prepare a demo Google account
- Create a demo album with sample photos they can see

**E. Enroll in Apple Developer Program (Phase 16)**
- $99/year at developer.apple.com
- Required for TestFlight and App Store submission

### V2 Features (documented in `docs/POTOOS_V2_ROADMAP.md`)

1. **Transfer Admin** — let admin hand over album ownership to another member
2. **Archived Albums Section** — visible "Archived" tab/section so users can browse + unarchive (currently archived albums only show in a collapsible at the bottom of Albums tab)
3. **File Deletion** — long-press a gallery tile to remove one file (not the whole album)
4. **Custom Domain** — register `potoos.app`, update Supabase + OAuth redirect URLs
5. **Invite via Link** — share a URL instead of requiring the invitee's email
6. **Sprite Sheet optimization** — pack 12 wave frames into 1 WebP sprite sheet for faster PWA load
7. **Lottie animation** — replace sprite frames with vector Lottie animation
8. **Push Notifications** — FCM for upload/invite events
9. **Analytics** — Firebase Analytics (album_created, upload_success, etc.)
10. **Sentry activation** — add DSN to env to activate crash reporting

---

## 11. Known Minor Issues

| Issue | Where | Severity | Fix |
|---|---|---|---|
| Drive thumbnail URLs may expire | AlbumCard cover | Low | Re-upload a file to refresh. Permanent fix: store thumbnail URL on upload (already done for new uploads; old albums don't have it until next upload) |
| iOS Safari PWA install banner never shows | PWA | N/A | Browsers on iOS don't fire `beforeinstallprompt`. Banner only shows on Chrome/Edge. By design. |
| Album cover shows gradient on first open | Album Details | Low | `cover_thumbnail_url` only set after the FIRST upload after June 2026. Pre-existing albums need a new upload. |
| PNG files (like mascot frames) don't get Drive thumbnails | AlbumCard | Low | Drive only generates `thumbnailLink` for image/video MIME types that it can render. PNG of an owl is technically renderable but Drive may not cache it immediately. Upload a real photo to see the cover preview work. |

---

## 12. Key File Locations Quick Reference

| What | File |
|---|---|
| App color tokens | `app/lib/app/theme.dart` — `AppColors`, `AppSpacing`, `AppShadows`, `AppGradients` |
| Route definitions + transitions | `app/lib/app/routes.dart` |
| Main entry point | `app/lib/main.dart` (Sentry + Supabase init) |
| Env config loader | `app/lib/config/env.dart` |
| Poto mascot widget | `app/lib/core/widgets/poto_mascot.dart` |
| Toast utility | `app/lib/core/widgets/app_toast.dart` — `showAppToast(context, message:)` |
| PWA install service | `app/lib/core/services/pwa_install_service.dart` |
| Album repo (all DB ops) | `app/lib/features/albums/data/album_repository.dart` |
| Album providers + management controller | `app/lib/features/albums/providers/album_provider.dart` |
| Auth repo + providers | `app/lib/features/auth/` |
| Home screen (all 4 tabs) | `app/lib/features/albums/screens/home_screen.dart` |
| Album Details screen | `app/lib/features/albums/screens/album_details_screen.dart` |
| Edge Function shared helpers | `supabase/functions/_shared/` |
| Privacy Policy | `app/web/privacy.html` → live at `akircyno.github.io/potoos/privacy.html` |
| Terms of Use | `app/web/terms.html` → live at `akircyno.github.io/potoos/terms.html` |
| V1 build checklist | `docs/POTOOS_BUILD_ROADMAP.md` |
| V2 feature plan | `docs/POTOOS_V2_ROADMAP.md` |

---

## 13. Security Notes

- **Never commit `env.properties`** — it's in `.gitignore`. It contains Supabase anon key (public-safe but still shouldn't be committed), Google OAuth client IDs.
- **Never commit service role keys** — Google Drive credentials are stored as Supabase Edge Function secrets only.
- **RLS is active on all 6 tables** — clients can only read/write their own data. Edge Functions use `supabaseAdmin` (service role) to bypass RLS when needed (account deletion, album deletion, etc.).
- **Drive folder deletion** is performed by Edge Functions using the Google Drive API with the `potoos.storage@gmail.com` refresh token stored as a Supabase secret.

---

## 14. CI/CD

**Workflow:** `.github/workflows/pwa-beta.yml`  
**Trigger:** Push to `main` branch  
**What it does:**
1. Checks out the repo
2. Sets up Flutter
3. Writes `env.properties` from GitHub Actions secrets
4. Runs `flutter build web --base-href /potoos/`
5. Deploys `build/web/` to GitHub Pages

The deployed URL is: `https://akircyno.github.io/potoos/`

---

## 15. Conversation Context

This project was built over multiple sessions with Claude Sonnet 4.6. The previous sessions covered:
- Full infrastructure rename (LitratoLink → Potoos)
- Complete UI/UX redesign from scratch
- Design system implementation
- All screen redesigns
- Mascot integration
- Backend Edge Functions
- Security hardening
- Beta-readiness features

The app is **beta-ready** as of June 4, 2026. The primary remaining blocker for App Store submission is enrolling in the Apple Developer Program ($99/year).

---

*End of handoff document.*
