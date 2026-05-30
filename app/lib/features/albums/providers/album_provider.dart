import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/album_repository.dart';
import '../models/album.dart';
import '../models/media_file.dart';

final albumListProvider = FutureProvider<List<Album>>((ref) {
  return ref.watch(albumRepositoryProvider).fetchMyAlbums();
});

final albumMediaFilesProvider = FutureProvider.family<List<MediaFile>, String>((ref, albumId) {
  return ref.watch(albumRepositoryProvider).fetchAlbumMediaFiles(albumId);
});
