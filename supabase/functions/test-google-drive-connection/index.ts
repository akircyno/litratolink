import { handleCors } from "../_shared/cors.ts";
import { error, success } from "../_shared/response.ts";
import { getUserFromRequest } from "../_shared/auth.ts";
import { getDriveFileMetadata } from "../_shared/googleDrive.ts";

Deno.serve(async (req) => {
  const corsResponse = handleCors(req);
  if (corsResponse) return corsResponse;

  if (req.method !== "GET" && req.method !== "POST") {
    return error("INVALID_REQUEST", "Please send a GET or POST request.", 405);
  }

  const { user, error: authError } = await getUserFromRequest(req);
  if (authError || !user) {
    return error("UNAUTHENTICATED", "Please log in to continue.", 401);
  }

  const rootFolderId = Deno.env.get("GOOGLE_DRIVE_ROOT_FOLDER_ID");

  if (!rootFolderId) {
    return error("STORAGE_ERROR", "Google Drive storage is not configured yet.", 500);
  }

  try {
    const metadata = await getDriveFileMetadata(rootFolderId);
    const isFolder = metadata.mimeType === "application/vnd.google-apps.folder";

    if (!isFolder) {
      return error("STORAGE_ERROR", "Google Drive root folder is invalid.", 500);
    }

    return success({
      connected: true,
      root_folder_found: true,
      root_folder_name: metadata.name,
    });
  } catch (driveError) {
    console.error("test-google-drive-connection failed", driveError);
    return error("STORAGE_ERROR", "Could not connect to Google Drive.", 500);
  }
});
