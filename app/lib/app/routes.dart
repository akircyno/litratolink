import 'package:flutter/material.dart';

import '../features/albums/screens/album_details_screen.dart';
import '../features/albums/screens/create_album_screen.dart';
import '../features/albums/screens/home_screen.dart';
import '../features/albums/screens/members_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/downloads/screens/file_preview_screen.dart';
import '../features/downloads/screens/save_all_screen.dart';
import '../features/uploads/screens/upload_progress_screen.dart';
import '../features/uploads/screens/upload_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const createAlbum = '/create-album';
  static const albumDetails = '/album-details';
  static const upload = '/upload';
  static const uploadProgress = '/upload-progress';
  static const filePreview = '/file-preview';
  static const saveAll = '/save-all';
  static const members = '/members';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (_) => const SplashScreen(),
      login: (_) => const LoginScreen(),
      home: (_) => const HomeScreen(),
      createAlbum: (_) => const CreateAlbumScreen(),
      albumDetails: (_) => const AlbumDetailsScreen(),
      upload: (_) => const UploadScreen(),
      uploadProgress: (_) => const UploadProgressScreen(),
      filePreview: (_) => const FilePreviewScreen(),
      saveAll: (_) => const SaveAllScreen(),
      members: (_) => const MembersScreen(),
      profile: (_) => const HomeScreen(initialIndex: 3),
    };
  }
}
