import { handleCors } from "../_shared/cors.ts";
import { error, success } from "../_shared/response.ts";
import { getUserFromRequest } from "../_shared/auth.ts";
import { getGoogleAccessToken } from "../_shared/googleDrive.ts";
import { isAlbumMember } from "../_shared/permissions.ts";
import { supabaseAdmin } from "../_shared/supabaseAdmin.ts";
import { isUuid } from "../_shared/validation.ts";

Deno.serve(async (req) => {
  const corsResponse = handleCors(req);
  if (corsResponse) return corsResponse;

  if (req.method !== "POST") {
    return error("INVALID_REQUEST", "Please send a POST request.", 405);
  }

  const { user, error: authError } = await getUserFromRequest(req);
  if (authError || !user) {
    return error("UNAUTHENTICATED", "Please log in to continue.", 401);
  }

  let body: Record<string, unknown>;

  try {
    body = await req.json();
  } catch {
    return error("INVALID_REQUEST", "Please send valid download details.", 400);
  }

  if (!isUuid(body.media_file_id)) {
    return error("INVALID_REQUEST", "Please send a valid file ID.", 400);
  }

  const mediaFileId = body.media_file_id;

  const { data: mediaFile, error: mediaError } = await supabaseAdmin
    .from("media_files")
    .select(
      "id, album_id, storage_object_id, original_filename, mime_type, file_size_bytes, upload_status, is_deleted, permanently_deleted_at",
    )
    .eq("id", mediaFileId)
    .maybeSingle();

  if (mediaError) {
    console.error("get-download-access media lookup failed", mediaError.message);
    return error("SERVER_ERROR", "Could not load the file. Please try again.", 500);
  }

  if (
    !mediaFile ||
    mediaFile.upload_status !== "completed" ||
    mediaFile.is_deleted ||
    mediaFile.permanently_deleted_at
  ) {
    return error("FILE_NOT_FOUND", "This file is no longer available.", 404);
  }

  const { data: album, error: albumError } = await supabaseAdmin
    .from("albums")
    .select("id")
    .eq("id", mediaFile.album_id)
    .eq("is_deleted", false)
    .maybeSingle();

  if (albumError) {
    console.error("get-download-access album lookup failed", albumError.message);
    return error("SERVER_ERROR", "Could not load the album. Please try again.", 500);
  }

  if (!album) {
    return error("ALBUM_NOT_FOUND", "This album is no longer available.", 404);
  }

  const member = await isAlbumMember(mediaFile.album_id, user.id);
  if (!member) {
    return error("FORBIDDEN", "You do not have permission to download this file.", 403);
  }

  const { data: storageObject, error: storageError } = await supabaseAdmin
    .from("storage_objects")
    .select("id, provider_file_id, file_size_bytes, mime_type, is_deleted")
    .eq("id", mediaFile.storage_object_id)
    .eq("is_deleted", false)
    .maybeSingle();

  if (storageError) {
    console.error("get-download-access storage object lookup failed", storageError.message);
    return error("SERVER_ERROR", "Could not load the stored file. Please try again.", 500);
  }

  if (!storageObject?.provider_file_id) {
    return error("STORAGE_ERROR", "Download access is not ready yet.", 500);
  }

  try {
    const accessToken = await getGoogleAccessToken();
    const encodedFileId = encodeURIComponent(storageObject.provider_file_id);

    return success({
      media_file_id: mediaFile.id,
      download_url: `https://www.googleapis.com/drive/v3/files/${encodedFileId}?alt=media`,
      access_token: accessToken,
      original_filename: mediaFile.original_filename,
      mime_type: mediaFile.mime_type,
      file_size_bytes: storageObject.file_size_bytes ?? mediaFile.file_size_bytes,
    });
  } catch (downloadError) {
    console.error("get-download-access token creation failed", downloadError);
    return error("STORAGE_ERROR", "Could not prepare download access. Please try again.", 500);
  }
});
