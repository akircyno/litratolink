# LitratoLink Flutter App

This folder contains the Flutter mobile UI scaffold for LitratoLink.

The current implementation is UI-first and backend-ready:

- Uses the LitratoLink brand palette.
- Uses General Sans for headings and Inter for body/UI text.
- Keeps reusable UI components in `lib/core/widgets`.
- Keeps screens grouped by feature under `lib/features`.
- Uses named routes from `lib/app/routes.dart`.
- Uses demo data only until Supabase and Edge Functions are connected.

Important:

- Do not redesign the UI here.
- Match `litratolink_mobile_ui.html` when that file is available.
- Backend functionality should follow the Master Product Plan.
- Original-quality upload/download logic must never compress, resize, or convert files.

Run later, after Flutter is installed:

```powershell
cd app
flutter pub get
flutter run
```
