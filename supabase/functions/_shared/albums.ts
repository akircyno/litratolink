import { supabaseAdmin } from "./supabaseAdmin.ts";

export async function touchAlbum(albumId: string) {
  const { error } = await supabaseAdmin
    .from("albums")
    .update({ updated_at: new Date().toISOString() })
    .eq("id", albumId)
    .eq("is_deleted", false);

  if (error) {
    console.error("touch-album failed", error.message);
  }
}
