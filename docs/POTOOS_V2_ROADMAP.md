# Potoos — Version 2 Roadmap

Features planned for the next major release. These are confirmed product decisions,
not speculative. Each item has a clear "Why" and a rough implementation note.

---

## Albums

### Transfer Admin
**Why:** The original creator of a space may leave, lose access, or simply want to
hand ownership to someone else. Currently the album is permanently tied to whoever
created it, which is a blocker for long-lived shared spaces (families, sports teams, etc.)

**How:**
- Admin-only option in the `···` menu on Album Details
- Shows a list of current members → select one → confirmation dialog
- Backend: update `album_members` role for both parties in one transaction
- The old admin becomes a Contributor by default (can be changed after)

**Edge case:** Only one Admin can exist per album at a time.

---

### Album Cover Preview (Latest File Thumbnail)
**Why:** The current gradient placeholder is a stopgap. Showing an actual thumbnail
from the album's most recent upload makes the home grid feel real and personal.

**How:**
- Requires schema change: add `thumbnail_url TEXT` to `media_files` table
- Update `upload-original-file` Edge Function to extract and store the Google Drive
  `thumbnailLink` from the Drive API upload response
- Add `cover_thumbnail_url TEXT` to `albums` table, updated to the latest file's
  thumbnail after each upload via a Supabase trigger or the `complete-upload` function
- `AlbumCard` tries to load `NetworkImage(album.coverThumbnailUrl)` with the gradient
  as fallback when no thumbnail exists yet
- The thumbnail is Drive's compressed preview — the original file is never touched

**Note:** Thumbnail quality is intentionally low (Google Drive serves ~220px previews).
The original file remains at full quality in Drive. This is display only.

---

### Archived Albums Section
**Why:** Currently archived albums are silently hidden with no way to access them
from the UI. A user who archives by accident or wants to unarchive has no path.

**How:**
- Collapsed "Archived" section at the bottom of the Albums tab
- Tap to expand → shows archived album cards in greyed-out style
- Each archived album card shows an "Unarchive" option via long-press or `···` menu
- Backend: already handled by `is_archived` flag

---

## Members & Permissions

### Role-Based Upload Limits
**Why:** Admins may want to restrict Contributors to specific file types or sizes.

**How:** Edge Function validation on `create-upload-session` checking per-album settings.

---

## Files

### File Deletion (Individual Files)
**Why:** Users upload the wrong file and have no way to remove it from an album
without deleting the whole album.

**How:**
- Long-press on a gallery tile → "Remove this file" option
- Only Admin and the file's original uploader can delete
- Calls a new `delete-file` Edge Function → removes from Drive + sets `is_deleted`
- Soft-delete first (30-day recovery window via existing `delete_expires_at` schema)

---

## Performance & PWA

### Mascot Asset Optimization (Sprite Sheet)
**Why:** The login screen waving animation loads 12 separate WebP files (≈1.5 MB total).
A sprite sheet packs all 12 frames into one file, eliminating 11 network round-trips
and reducing total load to ~400 KB.

**How:**
- Assemble `poto_wave_01–12.webp` into `poto_wave_sheet.png` using Aseprite or
  an online sprite sheet packer
- Update `PotoWave` widget to use `ClipRect` + `Transform.translate` sliding
  a viewport across the sprite sheet instead of loading individual files
- Same visual output, 3–4× faster load

### Mascot Lottie Animation
**Why:** Sprite sheets are limited to the frames you have. Lottie JSON animations
are vector-based, infinitely smooth, and scale to any size without quality loss.

**How:** Requires recreating the Poto waving animation in After Effects or a Lottie
editor, then exporting as JSON. Use `lottie` Flutter package.

---

## Discovery

### Invite via Link
**Why:** Sending an email invite requires knowing someone's email. A shareable link
lets admins share access with anyone without knowing their email address.

**How:** Generate a one-time token stored in Supabase → `potoos.app/join/TOKEN` →
clicking verifies the token and adds the user to the album with the specified role.

---

*Last updated: 2026-06-04*
