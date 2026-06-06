String pluralize(int count, String singular, String plural) =>
    '$count ${count == 1 ? singular : plural}';

class FileUtils {
  const FileUtils._();

  static const imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'heic',
    'heif',
    'webp',
  };

  static const videoExtensions = {
    'mp4',
    'mov',
    'm4v',
    'avi',
    'mkv',
  };

  static String? inferMimeType(String filename, String? extension) {
    final ext = (extension ?? filename.split('.').last).toLowerCase();

    return switch (ext) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'heic' => 'image/heic',
      'heif' => 'image/heif',
      'webp' => 'image/webp',
      'mp4' => 'video/mp4',
      'mov' => 'video/quicktime',
      'm4v' => 'video/x-m4v',
      'avi' => 'video/x-msvideo',
      'mkv' => 'video/x-matroska',
      _ => null,
    };
  }

  static String? inferFileType(String mimeType) {
    if (mimeType.startsWith('image/')) return 'photo';
    if (mimeType.startsWith('video/')) return 'video';
    return null;
  }

  static List<String> allowedMediaExtensions({bool includeVideos = true}) {
    return [
      ...imageExtensions,
      if (includeVideos) ...videoExtensions,
    ].toList();
  }
}
