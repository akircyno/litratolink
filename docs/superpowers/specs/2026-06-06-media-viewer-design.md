# Media Viewer — Design Spec

**Date:** 2026-06-06
**Status:** Approved

---

## Overview

Full-screen photo and video viewer that opens when a user taps any file in the album gallery. Supports pinch-to-zoom, swipe navigation, swipe-down dismiss, inline video playback, and a download action. Entry and exit use Hero animation from the gallery thumbnail.

---

## Architecture

### New screen

`lib/features/albums/screens/media_viewer_screen.dart`

Receives `MediaViewerArgs(files: List<MediaFile>, initialIndex: int)` via route arguments.

Owns:
- `PageController` initialised to `initialIndex`
- `_currentIndex` int state, updated on `onPageChanged`
- `_chromeVisible` bool state for overlay auto-hide
- `Timer? _hideTimer` reset on every user interaction

### Route

`/media-viewer` added to `AppRoutes`. Transition: `PageRouteBuilder` with **zero duration** — the Hero animation is the entire visual transition; no slide or fade needed from the route itself.

### PageView

Horizontal `PageView.builder` over all files. Each page renders either `ViewerPhotoPage` or `ViewerVideoPage` depending on `file.isVideo`.

### Hero tag

Tag: `'media-${file.id}'`

- `GalleryTile` wraps its thumbnail widget in `Hero(tag: 'media-${file.id}')`.
- In the viewer, only the page where `pageIndex == _currentIndex` receives the `Hero` wrapper. All other pages render without it.
- `onPageChanged` updates `_currentIndex` so the active Hero tag always reflects the currently visible file. This ensures that pressing back after swiping to a different file reverse-animates to that file's grid tile, not the originally tapped one.

---

## Photo page

**File:** `lib/features/albums/widgets/viewer_photo_page.dart`

### Zoom and pan

Uses `InteractiveViewer` with:
- `minScale: 1.0`, `maxScale: 5.0`
- `clipBehavior: Clip.none` (image can extend past bounds when zoomed)
- `TransformationController` to read and reset scale

### Double-tap zoom

`GestureDetector.onDoubleTapDown` records tap position. `onDoubleTap`:
- If scale is 1.0 → animate to 2.5x centred on tap position
- If scale > 1.0 → animate back to 1.0 (reset `TransformationController`)

Uses `AnimationController` + `Matrix4Tween` for smooth animated transition.

### PageView physics conflict

`_scaleNotifier` (ValueNotifier<double>) is updated in `InteractiveViewer.onInteractionUpdate`.

- When `scale > 1.0`: parent `PageView` switches to `NeverScrollableScrollPhysics`
- When `scale == 1.0`: restores `PageScrollPhysics`

This applies whether the scale change came from pinch **or** double-tap.

### Swipe-down dismiss

Enabled **only when scale == 1.0**.

`GestureDetector` on the page tracks `onVerticalDragUpdate`:
- Accumulates `_dragOffset` (vertical delta only)
- Threshold: 100px — triggers `Navigator.pop()`
- Below threshold: snap back via `AnimatedBuilder`
- Background opacity: `1.0 - (dragOffset / 300).clamp(0, 0.85)` — fades black background proportionally to drag

When scale > 1.0, vertical drag is passed through to `InteractiveViewer` for panning.

---

## Video page

### Conditional import dispatcher

**File:** `lib/features/albums/widgets/viewer_video_page.dart`

```dart
export 'viewer_video_page_mobile.dart'
    if (dart.library.html) 'viewer_video_page_web.dart';
```

### Mobile implementation

**File:** `lib/features/albums/widgets/viewer_video_page_mobile.dart`

Uses `video_player` package (`^2.9.2`).

Auth URL construction — same pattern as existing `media_video_preview_web.dart`:

```dart
final uri = Uri.parse('$supabaseUrl/functions/v1/stream-media-preview')
    .replace(queryParameters: {
      'media_file_id': file.id,
      'access_token': session.accessToken,
    });
VideoPlayerController.networkUrl(uri)
```

Lifecycle:
1. `initState` — create controller, call `initialize()`, then `setState`
2. `dispose` — `controller.dispose()`
3. Show `CircularProgressIndicator` while `!controller.value.isInitialized`
4. Show `VideoPlayer(controller)` once ready, aspect ratio preserved with `AspectRatio`

### Web implementation

**File:** `lib/features/albums/widgets/viewer_video_page_web.dart`

Reuses the `HtmlVideoElement` + `ui_web.platformViewRegistry` pattern from `media_video_preview_web.dart`, but upgraded:
- `controls = false` (custom controls overlay handles this)
- `muted = false` (user can unmute; default muted until first tap)
- Exposes `play()`, `pause()`, `seek(double seconds)`, `mute/unmute`, current position and duration via a `ValueNotifier` for the controls overlay

### Video controls overlay

Rendered on top of the video widget (same for mobile and web, receives a `VideoControlsState` interface):

- **Centre play/pause button**: large circle, `Icons.play_arrow` / `Icons.pause`, white on semi-transparent dark bg
- **Bottom bar** (within chrome):
  - Elapsed time — `mm:ss`
  - `Slider` scrub bar — white active, grey inactive
  - Total duration — `mm:ss`
  - Mute/unmute icon button — `Icons.volume_up` / `Icons.volume_off`
- Tapping the video area toggles play/pause AND resets chrome hide timer

---

## Chrome overlay

Chrome = top bar + bottom filename bar. Controlled by `_chromeVisible` in `MediaViewerScreen`.

### Auto-hide behaviour

- **Show**: any tap or interaction resets the timer and sets `_chromeVisible = true`
- **Hide**: `Timer(const Duration(seconds: 2), () => setState(() => _chromeVisible = false))`
- Timer cancelled in `dispose()`
- Chrome never hides while video controls are being interacted with (scrubber drag holds visibility)

### Animation

`AnimatedOpacity(opacity: _chromeVisible ? 1.0 : 0.0, duration: Duration(milliseconds: 200))`

### Top bar content

- **Top-left**: close button (X icon) — `Navigator.pop()`
- **Top-right**: `"${_currentIndex + 1} of ${files.length}"` counter + download icon button

### Bottom bar content

- Filename of current file — small, muted white, `fontSize: 12`, with text shadow
- Uploader name — even smaller, more muted

---

## Download

Top-right download icon button calls `ref.read(downloadControllerProvider.notifier).download(currentFile)`. Uses existing `downloadControllerProvider` — same provider as `FilePreviewScreen`. No new provider needed.

Toast on completion re-uses existing `showAppToast`.

---

## Files

### New files

| File | Purpose |
|---|---|
| `lib/features/albums/screens/media_viewer_screen.dart` | Screen, PageView, chrome, Hero management |
| `lib/features/albums/widgets/viewer_photo_page.dart` | InteractiveViewer, zoom, swipe-down dismiss |
| `lib/features/albums/widgets/viewer_video_page.dart` | Conditional import dispatcher |
| `lib/features/albums/widgets/viewer_video_page_mobile.dart` | video_player implementation |
| `lib/features/albums/widgets/viewer_video_page_web.dart` | HtmlVideoElement implementation with controls |

### Modified files

| File | Change |
|---|---|
| `app/pubspec.yaml` | Add `video_player: ^2.9.2` |
| `lib/app/routes.dart` | Add `/media-viewer` route with zero-duration `PageRouteBuilder` |
| `lib/features/albums/widgets/gallery_tile.dart` | Wrap thumbnail in `Hero(tag: 'media-${file.id}')` |
| `lib/features/albums/screens/album_details_screen.dart` | Change tile `onTap` to push `/media-viewer` with `MediaViewerArgs` |

---

## Acceptance criteria

- [ ] Tapping any thumbnail opens viewer with Hero expand animation
- [ ] Pinch to zoom works: min 1x, max 5x, smooth
- [ ] Double-tap toggles between 1x and 2.5x
- [ ] When zoomed, PageView swipe is disabled
- [ ] Swipe left/right navigates between files (disabled when zoomed)
- [ ] Swipe down (at 1x) dismisses with background fade and reverse Hero
- [ ] At first/last file, further swipe in that direction has no effect (bounce)
- [ ] Chrome auto-hides after 2s, reappears on tap
- [ ] "N of M" counter updates on swipe
- [ ] Download button triggers download of current file
- [ ] Videos play inline with play/pause, scrubber, time, mute controls
- [ ] No crash on dispose (controllers cleaned up)
- [ ] Navigating back after swiping to a different file: Hero animates to correct grid tile

---

## Out of scope

- Sharing / copy link from viewer
- Edit / delete from viewer
- Full-res image loading (viewer shows authenticated thumbnail — same source as gallery)
- Pinch-to-dismiss (only swipe-down dismiss)
