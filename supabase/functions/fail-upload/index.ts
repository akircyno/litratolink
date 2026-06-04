import { handleCors } from "../_shared/cors.ts";
import { error, success } from "../_shared/response.ts";
import { getUserFromRequest } from "../_shared/auth.ts";
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
    return error("INVALID_REQUEST", "Please send valid upload details.", 400);
  }

  if (!isUuid(body.media_file_id) || !isUuid(body.storage_object_id)) {
    return error("INVALID_REQUEST", "Please send valid upload identifiers.", 400);
  }

  const mediaFileId = body.media_file_id;
  const storageObjectId = body.storage_object_id;

  const { data: mediaFile, error: mediaError } = await supabaseAdmin
    .from("media_files")
    .select("id, uploader_id, upload_status")
    .eq("id", mediaFileId)
    .eq("storage_object_id", storageObjectId)
    .eq("is_deleted", false)
    .maybeSingle();

  if (mediaError) {
    console.error("fail-upload media lookup failed", mediaError.message);
    return error("SERVER_ERROR", "Could not load the upload. Please try again.", 500);
  }

  if (!mediaFile) {
    return error("FILE_NOT_FOUND", "This file is no longer available.", 404);
  }

  if (mediaFile.uploader_id !== user.id) {
    return error("FORBIDDEN", "You do not have permission to update this upload.", 403);
  }

  if (mediaFile.upload_status === "completed") {
    return error("UPLOAD_FAILED", "This upload is already complete.", 400);
  }

  if (mediaFile.upload_status !== "failed") {
    const { error: updateError } = await supabaseAdmin
      .from("media_files")
      .update({ upload_status: "failed" })
      .eq("id", mediaFileId);

    if (updateError) {
      console.error("fail-upload status update failed", updateError.message);
      return error("SERVER_ERROR", "Could not update the upload. Please try again.", 500);
    }
  }

  return success({
    media_file_id: mediaFileId,
    upload_status: "failed",
  });
});
