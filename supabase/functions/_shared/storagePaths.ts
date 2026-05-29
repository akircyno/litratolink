export function getAlbumOriginalsPath(appEnv: string, albumId: string) {
  return `${appEnv}/albums/${albumId}/originals`;
}

export function createSafeStorageFilename(mediaFileId: string, originalFilename: string) {
  const safeName = originalFilename
    .trim()
    .replace(/[^\w.\-() ]+/g, "_")
    .replace(/\s+/g, " ");

  return `${mediaFileId}_${safeName}`;
}
