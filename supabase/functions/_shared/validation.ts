export type MediaFileType = "photo" | "video";

export function isUuid(value: unknown): value is string {
  if (typeof value !== "string") return false;

  return /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
    .test(value);
}

export function isValidAlbumName(value: unknown): value is string {
  return typeof value === "string" &&
    value.trim().length >= 1 &&
    value.trim().length <= 100;
}

export function isValidFileType(value: unknown): value is MediaFileType {
  return value === "photo" || value === "video";
}

export function isValidFileSize(value: unknown): value is number {
  return typeof value === "number" && Number.isFinite(value) && value > 0;
}

export function isValidMimeType(value: unknown): value is string {
  return typeof value === "string" &&
    value.includes("/") &&
    value.trim().length <= 255;
}

export function isValidFilename(value: unknown): value is string {
  return typeof value === "string" &&
    value.trim().length > 0 &&
    value.trim().length <= 255;
}
