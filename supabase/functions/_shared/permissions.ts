import { supabaseAdmin } from "./supabaseAdmin.ts";

export type AlbumRole = "admin" | "contributor" | "viewer";

export async function getAlbumRole(albumId: string, userId: string) {
  const { data, error } = await supabaseAdmin
    .from("album_members")
    .select("role, is_active")
    .eq("album_id", albumId)
    .eq("user_id", userId)
    .eq("is_active", true)
    .maybeSingle();

  if (error || !data) return null;

  return data.role as AlbumRole;
}

export async function isAlbumMember(albumId: string, userId: string) {
  const role = await getAlbumRole(albumId, userId);
  return role !== null;
}

export async function canUploadToAlbum(albumId: string, userId: string) {
  const role = await getAlbumRole(albumId, userId);
  return role === "admin" || role === "contributor";
}
