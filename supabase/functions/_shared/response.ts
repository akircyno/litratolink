import { corsHeaders } from "./cors.ts";

export type ApiErrorCode =
  | "UNAUTHENTICATED"
  | "FORBIDDEN"
  | "INVALID_REQUEST"
  | "NOT_FOUND"
  | "ALBUM_NOT_FOUND"
  | "FILE_NOT_FOUND"
  | "STORAGE_ERROR"
  | "UPLOAD_FAILED"
  | "DOWNLOAD_FAILED"
  | "STORAGE_FULL"
  | "USER_NOT_FOUND"
  | "MEMBER_NOT_FOUND"
  | "ALREADY_EXISTS"
  | "SERVER_ERROR";

const jsonHeaders = {
  ...corsHeaders,
  "Content-Type": "application/json",
};

export function success(data: unknown, status = 200) {
  return new Response(
    JSON.stringify({
      success: true,
      data,
    }),
    {
      headers: jsonHeaders,
      status,
    },
  );
}

export function error(error_code: ApiErrorCode, message: string, status = 400) {
  return new Response(
    JSON.stringify({
      success: false,
      error_code,
      message,
    }),
    {
      headers: jsonHeaders,
      status,
    },
  );
}
