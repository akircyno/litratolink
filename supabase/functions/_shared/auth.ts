import type { User } from "npm:@supabase/supabase-js@2";
import { supabaseAdmin } from "./supabaseAdmin.ts";

export type AuthResult =
  | { user: User; error: null }
  | { user: null; error: string };

export async function getUserFromRequest(req: Request): Promise<AuthResult> {
  const authHeader = req.headers.get("Authorization");

  if (!authHeader) {
    return { user: null, error: "Missing authorization header." };
  }

  const token = authHeader.replace(/^Bearer\s+/i, "").trim();

  if (!token || token === authHeader) {
    return { user: null, error: "Missing auth token." };
  }

  const { data, error } = await supabaseAdmin.auth.getUser(token);

  if (error || !data.user) {
    return { user: null, error: "Invalid auth token." };
  }

  return { user: data.user, error: null };
}
