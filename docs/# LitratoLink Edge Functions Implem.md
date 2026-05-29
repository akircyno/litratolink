# LitratoLink Edge Functions Implementation Plan v1.0

## 1. Document Purpose

This document explains how to build the first Supabase Edge Functions for LitratoLink.

This document is based on:

* LitratoLink Master Product Plan v1.0
* LitratoLink System Architecture Document v1.0
* LitratoLink Database Design Document v1.0
* LitratoLink API and Edge Functions Specification v1.0
* LitratoLink Supabase SQL and RLS Planning Document v1.0
* LitratoLink Actual SQL Migration Draft v1.0
* LitratoLink First Sprint Task List v1.0
* LitratoLink Google Drive API Proof Plan v1.0

The goal of this document is to guide the backend implementation for Sprint 1.

Sprint 1 backend goal:

1. Create user profile.
2. Create album.
3. Add creator as Admin.
4. Connect to Google Drive.
5. Create upload session.
6. Complete upload.
7. Get download access.
8. Protect all actions with permission checks.

---

## 2. Sprint 1 Edge Functions

Sprint 1 should include only these Edge Functions:

1. `create-user-profile`
2. `create-album`
3. `test-google-drive-connection`
4. `create-upload-session`
5. `complete-upload`
6. `get-download-access`

Do not build these yet in Sprint 1:

* `invite-member`
* `accept-invite`
* `decline-invite`
* `soft-delete-file`
* `restore-file`
* `send-notification`
* `register-device-token`
* `mark-notification-read`

Those will be added after the proof of concept works.

---

## 3. Main Backend Rule

The Flutter app must not contain private secrets.

Never put these in Flutter:

* Supabase service role key
* Google Drive client secret
* Google refresh token
* Google service account private key
* Push notification server key

Private values must stay inside Supabase Edge Function secrets or backend environment variables.

---

## 4. Required Backend Environment Variables

Add these secrets to Supabase Edge Functions:

```text
SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=
GOOGLE_DRIVE_CLIENT_ID=
GOOGLE_DRIVE_CLIENT_SECRET=
GOOGLE_DRIVE_REFRESH_TOKEN=
GOOGLE_DRIVE_ROOT_FOLDER_ID=
STORAGE_PROVIDER=google_drive
APP_ENV=development
```

Optional later:

```text
GOOGLE_DRIVE_DEVELOPMENT_FOLDER_ID=
GOOGLE_DRIVE_PRODUCTION_FOLDER_ID=
FCM_SERVER_KEY=
```

---

## 5. Recommended Supabase Functions Folder Structure

Recommended structure:

```text
supabase/
  functions/
    _shared/
      cors.ts
      response.ts
      auth.ts
      supabaseAdmin.ts
      validation.ts
      permissions.ts
      googleDrive.ts
      storagePaths.ts

    create-user-profile/
      index.ts
      deno.json

    create-album/
      index.ts
      deno.json

    test-google-drive-connection/
      index.ts
      deno.json

    create-upload-session/
      index.ts
      deno.json

    complete-upload/
      index.ts
      deno.json

    get-download-access/
      index.ts
      deno.json
```

---

## 6. Shared File: `cors.ts`

## 6.1 Purpose

Handles CORS headers for all Edge Functions.

## 6.2 Suggested Content

```ts
export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
};
```

## 6.3 Rule

Every function should handle `OPTIONS` request.

Example:

```ts
if (req.method === "OPTIONS") {
  return new Response("ok", { headers: corsHeaders });
}
```

---

## 7. Shared File: `response.ts`

## 7.1 Purpose

Creates consistent API responses.

## 7.2 Success Response

```ts
import { corsHeaders } from "./cors.ts";

export function success(data: unknown, status = 200) {
  return new Response(
    JSON.stringify({
      success: true,
      data,
    }),
    {
      status,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json",
      },
    },
  );
}
```

## 7.3 Error Response

```ts
import { corsHeaders } from "./cors.ts";

export function error(
  error_code: string,
  message: string,
  status = 400,
) {
  return new Response(
    JSON.stringify({
      success: false,
      error_code,
      message,
    }),
    {
      status,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json",
      },
    },
  );
}
```

---

## 8. Standard Error Codes

Use these error codes:

```text
UNAUTHENTICATED
FORBIDDEN
INVALID_REQUEST
NOT_FOUND
ALBUM_NOT_FOUND
FILE_NOT_FOUND
STORAGE_ERROR
UPLOAD_FAILED
DOWNLOAD_FAILED
STORAGE_FULL
SERVER_ERROR
```

User-friendly messages should be simple.

Examples:

```text
Please log in to continue.
You do not have permission to do this.
This album is no longer available.
This file is no longer available.
Upload failed. Please try again.
Download failed. Please try again.
```

---

## 9. Shared File: `supabaseAdmin.ts`

## 9.1 Purpose

Creates a Supabase client using the service role key.

This is used only inside Edge Functions.

## 9.2 Suggested Content

```ts
import { createClient } from "npm:@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL");
const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

if (!supabaseUrl || !serviceRoleKey) {
  throw new Error("Missing Supabase environment variables.");
}

export const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey, {
  auth: {
    persistSession: false,
  },
});
```

## 9.3 Important Rule

Never use the service role key in Flutter.

---

## 10. Shared File: `auth.ts`

## 10.1 Purpose

Gets the logged-in user from the request Authorization header.

## 10.2 Expected Header

The Flutter app should send:

```text
Authorization: Bearer <access_token>
```

## 10.3 Suggested Logic

```ts
import { supabaseAdmin } from "./supabaseAdmin.ts";

export async function getUserFromRequest(req: Request) {
  const authHeader = req.headers.get("Authorization");

  if (!authHeader) {
    return { user: null, error: "Missing authorization header." };
  }

  const token = authHeader.replace("Bearer ", "").trim();

  if (!token) {
    return { user: null, error: "Missing auth token." };
  }

  const { data, error } = await supabaseAdmin.auth.getUser(token);

  if (error || !data.user) {
    return { user: null, error: "Invalid auth token." };
  }

  return { user: data.user, error: null };
}
```

---

## 11. Shared File: `permissions.ts`

## 11.1 Purpose

Contains permission helpers used by functions.

## 11.2 Helper: `getAlbumRole`

```ts
import { supabaseAdmin } from "./supabaseAdmin.ts";

export async function getAlbumRole(albumId: string, userId: string) {
  const { data, error } = await supabaseAdmin
    .from("album_members")
    .select("role, is_active")
    .eq("album_id", albumId)
    .eq("user_id", userId)
    .eq("is_active", true)
    .maybeSingle();

  if (error || !data) return null;

  return data.role as "admin" | "contributor" | "viewer";
}
```

## 11.3 Helper: `canUploadToAlbum`

```ts
export async function canUploadToAlbum(albumId: string, userId: string) {
  const role = await getAlbumRole(albumId, userId);
  return role === "admin" || role === "contributor";
}
```

## 11.4 Helper: `isAlbumMember`

```ts
export async function isAlbumMember(albumId: string, userId: string) {
  const role = await getAlbumRole(albumId, userId);
  return role !== null;
}
```

---

## 12. Shared File: `validation.ts`

## 12.1 Purpose

Contains simple validation helpers.

## 12.2 Validate UUID

```ts
export function isUuid(value: unknown): value is string {
  if (typeof value !== "string") return false;

  return /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
    .test(value);
}
```

## 12.3 Validate Album Name

```ts
export function isValidAlbumName(value: unknown): value is string {
  return typeof value === "string" &&
    value.trim().length >= 1 &&
    value.trim().length <= 100;
}
```

## 12.4 Validate File Metadata

```ts
export function isValidFileType(value: unknown) {
  return value === "photo" || value === "video";
}

export function isValidFileSize(value: unknown) {
  return typeof value === "number" && Number.isFinite(value) && value > 0;
}

export function isValidMimeType(value: unknown) {
  return typeof value === "string" && value.includes("/");
}

export function isValidFilename(value: unknown) {
  return typeof value === "string" && value.trim().length > 0;
}
```

---

## 13. Shared File: `storagePaths.ts`

## 13.1 Purpose

Creates safe storage paths.

## 13.2 Storage Folder Pattern

```text
development/albums/{album_id}/originals/
development/albums/{album_id}/thumbnails/
```

## 13.3 Suggested Helper

```ts
export function getAlbumOriginalsPath(appEnv: string, albumId: string) {
  return `${appEnv}/albums/${albumId}/originals`;
}

export function createSafeStorageFilename(
  mediaFileId: string,
  originalFilename: string,
) {
  const safeName = originalFilename.replace(/[^\w.\-() ]+/g, "_");
  return `${mediaFileId}_${safeName}`;
}
```

---

# PART A: GOOGLE DRIVE HELPER

---

## 14. Shared File: `googleDrive.ts`

## 14.1 Purpose

This file contains Google Drive API helper logic.

Functions needed for Sprint 1:

1. Get Google access token.
2. Check folder exists.
3. Create folder if needed.
4. Create resumable upload session.
5. Get file metadata.
6. Get download URL or file content access.

---

## 15. Google Access Token Helper

## 15.1 Purpose

Uses refresh token to get access token.

## 15.2 Required Environment Variables

```text
GOOGLE_DRIVE_CLIENT_ID
GOOGLE_DRIVE_CLIENT_SECRET
GOOGLE_DRIVE_REFRESH_TOKEN
```

## 15.3 Suggested Logic

```ts
export async function getGoogleAccessToken() {
  const clientId = Deno.env.get("GOOGLE_DRIVE_CLIENT_ID");
  const clientSecret = Deno.env.get("GOOGLE_DRIVE_CLIENT_SECRET");
  const refreshToken = Deno.env.get("GOOGLE_DRIVE_REFRESH_TOKEN");

  if (!clientId || !clientSecret || !refreshToken) {
    throw new Error("Missing Google Drive credentials.");
  }

  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      client_id: clientId,
      client_secret: clientSecret,
      refresh_token: refreshToken,
      grant_type: "refresh_token",
    }),
  });

  if (!response.ok) {
    throw new Error("Failed to get Google access token.");
  }

  const data = await response.json();

  if (!data.access_token) {
    throw new Error("Google access token missing.");
  }

  return data.access_token as string;
}
```

---

## 16. Check Folder Exists

## 16.1 Purpose

Checks if Google Drive root folder exists.

## 16.2 Suggested Logic

```ts
export async function getDriveFileMetadata(fileId: string) {
  const accessToken = await getGoogleAccessToken();

  const response = await fetch(
    `https://www.googleapis.com/drive/v3/files/${fileId}?fields=id,name,mimeType,parents,size`,
    {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    },
  );

  if (!response.ok) {
    throw new Error("Failed to get Google Drive file metadata.");
  }

  return await response.json();
}
```

---

## 17. Create Google Drive Folder

## 17.1 Purpose

Creates album folder or originals folder if missing.

## 17.2 Important Note

For Sprint 1, folder creation can be simple.

Later, folder IDs should be cached in the database to avoid repeated Google Drive searches.

## 17.3 Suggested Logic

```ts
export async function createDriveFolder(name: string, parentId: string) {
  const accessToken = await getGoogleAccessToken();

  const response = await fetch(
    "https://www.googleapis.com/drive/v3/files",
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        name,
        mimeType: "application/vnd.google-apps.folder",
        parents: [parentId],
      }),
    },
  );

  if (!response.ok) {
    throw new Error("Failed to create Google Drive folder.");
  }

  return await response.json();
}
```

---

## 18. Create Resumable Upload Session

## 18.1 Purpose

Creates a Google Drive resumable upload session.

## 18.2 Suggested Logic

```ts
export async function createResumableUploadSession(params: {
  filename: string;
  mimeType: string;
  parentFolderId: string;
  fileSizeBytes: number;
}) {
  const accessToken = await getGoogleAccessToken();

  const response = await fetch(
    "https://www.googleapis.com/upload/drive/v3/files?uploadType=resumable",
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json; charset=UTF-8",
        "X-Upload-Content-Type": params.mimeType,
        "X-Upload-Content-Length": String(params.fileSizeBytes),
      },
      body: JSON.stringify({
        name: params.filename,
        mimeType: params.mimeType,
        parents: [params.parentFolderId],
      }),
    },
  );

  if (!response.ok) {
    throw new Error("Failed to create Google Drive upload session.");
  }

  const uploadUrl = response.headers.get("Location");

  if (!uploadUrl) {
    throw new Error("Google upload session URL missing.");
  }

  return uploadUrl;
}
```

---

## 19. Get Google Drive Download URL

## 19.1 Purpose

Creates a download link for original file.

## 19.2 Simple Sprint 1 Approach

For Sprint 1, the backend may return:

```text
https://www.googleapis.com/drive/v3/files/{fileId}?alt=media
```

But the app must also have access to an Authorization token.

Safer approach:

* Flutter asks backend for download access.
* Backend checks permission.
* Backend returns a short-lived Google access token and download URL, or
* Backend streams the file itself.

## 19.3 Recommended Sprint 1 Approach

Use backend-proxy download if simple enough.

Meaning:

1. Flutter calls `get-download-access`.
2. Backend checks permission.
3. Backend uses Google token to request file.
4. Backend returns a temporary download URL or streams file.

For the fastest proof, returning download URL plus short-lived access token can be tested.

For better privacy, backend streaming is safer but may be heavier.

## 19.4 Decision for Sprint 1

Use the simplest secure approach that works.

Preferred order:

1. Backend streaming if manageable.
2. Temporary download URL + short-lived access token if streaming is too complex.
3. Avoid permanent public links.

---

# PART B: EDGE FUNCTIONS

---

## 20. Function: `create-user-profile`

## 20.1 Purpose

Create profile after Google Login.

## 20.2 Request Body

```json
{
  "display_name": "User Name",
  "avatar_url": "https://example.com/avatar.jpg"
}
```

## 20.3 Permission Check

User must be logged in.

## 20.4 Implementation Steps

1. Handle CORS.
2. Get current user from token.
3. Get user email from auth user.
4. Check if profile already exists.
5. If profile exists, return profile.
6. If profile does not exist, insert profile.
7. Return profile.

## 20.5 Success Response

```json
{
  "success": true,
  "data": {
    "user_id": "uuid",
    "email": "user@example.com",
    "display_name": "User Name"
  }
}
```

## 20.6 Error Cases

* Missing token
* Invalid token
* Missing email
* Insert failed

---

## 21. Function: `create-album`

## 21.1 Purpose

Create album and add creator as Admin.

## 21.2 Request Body

```json
{
  "name": "Me and GF",
  "description": "Private memories"
}
```

## 21.3 Permission Check

User must be logged in.

## 21.4 Implementation Steps

1. Handle CORS.
2. Get current user.
3. Validate album name.
4. Check user profile exists.
5. Get default Google Drive storage provider.
6. Insert album with `owner_id = user.id`.
7. Insert `album_members` record with role `admin`.
8. Return album data.

## 21.5 Important Rule

Album creation and Admin membership creation must both succeed.

If album is created but membership fails, the function should clean up or return a clear error.

## 21.6 Success Response

```json
{
  "success": true,
  "data": {
    "album_id": "uuid",
    "name": "Me and GF",
    "role": "admin"
  }
}
```

---

## 22. Function: `test-google-drive-connection`

## 22.1 Purpose

Check if backend can connect to Google Drive.

## 22.2 Request Body

No body required.

## 22.3 Permission Check

For development, user must be logged in.

Later, this should be admin-only or disabled.

## 22.4 Implementation Steps

1. Handle CORS.
2. Get current user.
3. Load `GOOGLE_DRIVE_ROOT_FOLDER_ID`.
4. Call `getDriveFileMetadata`.
5. Confirm root folder exists.
6. Return success.

## 22.5 Success Response

```json
{
  "success": true,
  "data": {
    "connected": true,
    "root_folder_found": true,
    "root_folder_name": "LitratoLink Storage"
  }
}
```

## 22.6 Important Rule

Do not expose Google tokens in the response.

---

## 23. Function: `create-upload-session`

## 23.1 Purpose

Prepare upload of one original file.

## 23.2 Request Body

```json
{
  "album_id": "uuid",
  "original_filename": "IMG_001.JPG",
  "mime_type": "image/jpeg",
  "file_size_bytes": 5123456,
  "file_type": "photo"
}
```

## 23.3 Permission Check

User must be:

* Logged in
* Active member of the album
* Admin or Contributor

## 23.4 Implementation Steps

1. Handle CORS.
2. Get current user.
3. Validate request body.
4. Check album exists and is not deleted.
5. Check user can upload to album.
6. Get default Google Drive storage provider.
7. Create pending `storage_objects` record.
8. Create pending `media_files` record.
9. Create or find Google Drive album folder.
10. Create or find `originals` folder.
11. Create safe storage filename.
12. Create Google Drive resumable upload session.
13. Return upload session data.

## 23.5 Folder Naming

Album folder:

```text
album_{album_id}
```

Originals folder:

```text
originals
```

Final filename:

```text
{media_file_id}_{original_filename}
```

## 23.6 Success Response

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "storage_object_id": "uuid",
    "upload_url": "temporary-upload-url",
    "upload_method": "PUT",
    "required_headers": {
      "Content-Type": "image/jpeg"
    }
  }
}
```

## 23.7 Important Rule

The backend prepares the upload.

The Flutter app uploads the original file bytes to the upload URL.

The app must not compress, resize, or convert the file.

---

## 24. Function: `complete-upload`

## 24.1 Purpose

Mark file upload as completed.

## 24.2 Request Body

```json
{
  "media_file_id": "uuid",
  "storage_object_id": "uuid",
  "provider_file_id": "google-drive-file-id",
  "final_file_size_bytes": 5123456,
  "checksum": "optional"
}
```

## 24.3 Permission Check

User must be the original uploader.

## 24.4 Implementation Steps

1. Handle CORS.
2. Get current user.
3. Validate request body.
4. Get media file record.
5. Check user is uploader.
6. Get Google Drive file metadata using `provider_file_id`.
7. Check file exists.
8. Compare size if available.
9. Update `storage_objects` with:

   * `provider_file_id`
   * `file_size_bytes`
   * `checksum` if available
10. Update `media_files` with:

* `upload_status = completed`
* `uploaded_at = now()`

11. Return completed file data.

## 24.5 Success Response

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "upload_status": "completed",
    "uploaded_at": "timestamp"
  }
}
```

## 24.6 Important Rule

Do not mark upload as completed if Google Drive file cannot be confirmed.

---

## 25. Function: `get-download-access`

## 25.1 Purpose

Allow an active album member to download the original file.

## 25.2 Request Body

```json
{
  "media_file_id": "uuid"
}
```

## 25.3 Permission Check

User must be:

* Logged in
* Active member of the file’s album

File must be:

* Completed
* Not deleted
* Not permanently deleted

Album must be:

* Not deleted

## 25.4 Implementation Steps

1. Handle CORS.
2. Get current user.
3. Validate `media_file_id`.
4. Get media file record.
5. Check file is completed.
6. Check file is not deleted.
7. Check user is active album member.
8. Get storage object.
9. Get Google Drive file ID.
10. Return download access.

## 25.5 Download Response Option A: Token + URL

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "download_url": "https://www.googleapis.com/drive/v3/files/google-file-id?alt=media",
    "access_token": "short-lived-google-access-token",
    "original_filename": "IMG_001.JPG",
    "mime_type": "image/jpeg",
    "file_size_bytes": 5123456
  }
}
```

## 25.6 Download Response Option B: Backend Proxy URL

```json
{
  "success": true,
  "data": {
    "media_file_id": "uuid",
    "proxy_download_url": "https://project.supabase.co/functions/v1/download-file?media_file_id=uuid",
    "original_filename": "IMG_001.JPG",
    "mime_type": "image/jpeg",
    "file_size_bytes": 5123456
  }
}
```

## 25.7 Recommended for Sprint 1

Start with Option A if faster.

But do not expose permanent public links.

For production, review Option B or a stronger temporary access method.

---

# PART C: FUNCTION DETAILS AND RULES

---

## 26. Authorization Handling

Every function must:

1. Read `Authorization` header.
2. Validate token.
3. Get user.
4. Return `UNAUTHENTICATED` if invalid.

Example error:

```json
{
  "success": false,
  "error_code": "UNAUTHENTICATED",
  "message": "Please log in to continue."
}
```

---

## 27. Request Validation

Every function must validate request body.

If invalid:

```json
{
  "success": false,
  "error_code": "INVALID_REQUEST",
  "message": "Please check your request and try again."
}
```

---

## 28. Permission Error

If user is not allowed:

```json
{
  "success": false,
  "error_code": "FORBIDDEN",
  "message": "You do not have permission to do this."
}
```

---

## 29. Storage Error

If Google Drive fails:

```json
{
  "success": false,
  "error_code": "STORAGE_ERROR",
  "message": "Storage error. Please try again."
}
```

---

## 30. Server Error

For unexpected errors:

```json
{
  "success": false,
  "error_code": "SERVER_ERROR",
  "message": "Something went wrong. Please try again."
}
```

Do not return raw error details to the app.

Raw errors may be logged in backend for debugging.

---

# PART D: DEVELOPMENT ORDER

---

## 31. Step 1: Shared Helpers

Build shared helpers first:

1. `cors.ts`
2. `response.ts`
3. `supabaseAdmin.ts`
4. `auth.ts`
5. `validation.ts`
6. `permissions.ts`
7. `storagePaths.ts`
8. `googleDrive.ts`

Done when:

* Helpers compile.
* No secrets are exposed.
* They can be imported by functions.

---

## 32. Step 2: Profile Function

Build:

* `create-user-profile`

Test:

* New user profile creation
* Existing user profile return
* Missing auth error

---

## 33. Step 3: Album Function

Build:

* `create-album`

Test:

* Album created
* Creator becomes Admin
* Empty album name blocked
* User without profile blocked or profile created first

---

## 34. Step 4: Google Drive Test Function

Build:

* `test-google-drive-connection`

Test:

* Root folder found
* Bad folder ID returns error
* Missing Google secrets returns error

---

## 35. Step 5: Upload Session Function

Build:

* `create-upload-session`

Test:

* Admin can create upload session
* Viewer cannot create upload session
* Non-member cannot create upload session
* Invalid file metadata is blocked
* Upload URL is returned

---

## 36. Step 6: Complete Upload Function

Build:

* `complete-upload`

Test:

* Uploader can complete upload
* Non-uploader cannot complete upload
* Fake Google Drive file ID fails
* Completed file appears in album

---

## 37. Step 7: Download Access Function

Build:

* `get-download-access`

Test:

* Album member can get download access
* Non-member cannot get download access
* Deleted file is blocked
* Incomplete file is blocked
* Download uses original file

---

# PART E: TESTING PLAN

---

## 38. Function Testing Checklist

### `create-user-profile`

Test:

* Valid logged-in user
* Missing token
* Repeated call

### `create-album`

Test:

* Valid album name
* Empty album name
* Creator membership created

### `test-google-drive-connection`

Test:

* Correct folder ID
* Wrong folder ID
* Missing Google credentials

### `create-upload-session`

Test:

* Admin user
* Contributor user later
* Viewer user later
* Non-member user
* Invalid file type
* Invalid file size

### `complete-upload`

Test:

* Valid uploader
* Wrong uploader
* Missing Google file
* File size mismatch

### `get-download-access`

Test:

* Valid album member
* Non-member
* Deleted file
* Failed upload file
* Missing storage object

---

## 39. Manual Test Flow

Use this manual flow after all Sprint 1 functions are ready:

1. Log in with Google.
2. Call `create-user-profile`.
3. Call `create-album`.
4. Call `test-google-drive-connection`.
5. Select one photo.
6. Call `create-upload-session`.
7. Upload original file using returned upload URL.
8. Call `complete-upload`.
9. Open album.
10. Call `get-download-access`.
11. Download original file.
12. Compare original and downloaded file.

---

## 40. Original Quality Test

Compare:

* Original file size
* Downloaded file size
* Original MIME type
* Downloaded MIME type
* Original width
* Downloaded width
* Original height
* Downloaded height

Optional:

* SHA-256 checksum

Best result:

Checksum matches exactly.

---

# PART F: COMMON IMPLEMENTATION RISKS

---

## 41. Risk: Direct Upload URL Does Not Return File ID

Problem:

Google resumable upload may return file metadata after final upload, but Flutter must capture it correctly.

Solution:

After upload completes, read the final response body and extract the Google Drive file ID.

If not available, the backend may need another way to confirm uploaded file.

---

## 42. Risk: Edge Function Timeout

Problem:

Large uploads should not pass through Edge Function if the function timeout is short.

Solution:

Use Edge Function only to create upload session.

Let Flutter upload directly to the Google resumable upload URL.

Then call `complete-upload`.

---

## 43. Risk: Google Access Token Exposure

Problem:

Returning Google access token to Flutter may be less ideal.

Solution:

For Sprint 1, it may be acceptable only if token is short-lived and scoped.

For production, consider backend proxy download or another controlled method.

---

## 44. Risk: Picker Returns Compressed File

Problem:

Flutter picker may return an optimized/compressed version.

Solution:

Use a picker that returns the actual file.

Test file size and checksum.

---

## 45. Risk: RLS Conflict With Service Role

Problem:

Service role bypasses RLS, so Edge Functions must do permission checks manually.

Solution:

Every Edge Function must check user permission before using service role actions.

---

## 46. Risk: Duplicate Google Drive Folders

Problem:

Creating folders repeatedly may create duplicates.

Solution:

For Sprint 1, duplicates are acceptable for testing.

For MVP, save folder IDs or search before creating.

---

# PART G: SPRINT 1 COMPLETION RULE

---

## 47. Edge Functions Are Ready When

Sprint 1 Edge Functions are ready when:

* User profile creation works.
* Album creation works.
* Creator becomes Admin.
* Backend connects to Google Drive.
* Upload session can be created.
* Original file can upload.
* Upload can be marked completed.
* Download access can be generated.
* Non-members are blocked.
* Secrets are not exposed in Flutter.
* Errors are user-friendly.

---

## 48. Final Decision After Edge Function Proof

If all functions work:

Continue to Flutter UI integration.

If upload session works but download is risky:

Review download approach before building Save All.

If Google Drive API becomes too complex:

Review backup storage options, but do not change the plan until proof is fully tested.

---

## 49. Next Recommended Document

The next recommended document is:

**LitratoLink Flutter Project Structure Guide v1.0**

This document should define:

* Flutter folder structure
* Feature modules
* Models
* Services
* Riverpod providers
* Routing
* Theme setup
* Environment setup
* Sprint 1 screens
* Coding rules
