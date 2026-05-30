import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../models/album.dart';
import '../models/media_file.dart';

class DemoData {
  const DemoData._();

  static const albums = [
    Album(
      id: 'album-1',
      name: 'Me and GF',
      description: 'Private memories from our favorite days.',
      role: 'Admin',
      fileCount: 245,
      memberCount: 2,
      updatedLabel: 'Today',
      coverColors: [AppColors.maroon, AppColors.softGold],
    ),
    Album(
      id: 'album-2',
      name: 'Family - Baguio 2025',
      description: 'Original photos and short videos from Baguio.',
      role: 'Contributor',
      fileCount: 87,
      memberCount: 6,
      updatedLabel: 'Yesterday',
      coverColors: [Color(0xFF1C3A6B), AppColors.maroon],
    ),
    Album(
      id: 'album-3',
      name: 'Barkada Boracay',
      description: 'Invite-only beach memories.',
      role: 'Viewer',
      fileCount: 312,
      memberCount: 5,
      updatedLabel: '3 days ago',
      coverColors: [Color(0xFF2A6B1C), AppColors.softGold],
    ),
  ];

  static const mediaFiles = [
    MediaFile(
      id: 'file-1',
      originalFilename: 'IMG_2048.JPG',
      fileType: 'Photo',
      mimeType: 'image/jpeg',
      fileSizeLabel: '5.2 MB',
      uploaderName: 'You',
      uploadedLabel: 'Today',
      isVideo: false,
    ),
    MediaFile(
      id: 'file-2',
      originalFilename: 'VID_1022.MOV',
      fileType: 'Video',
      mimeType: 'video/quicktime',
      fileSizeLabel: '42.8 MB',
      uploaderName: 'Mika',
      uploadedLabel: 'Yesterday',
      isVideo: true,
    ),
    MediaFile(
      id: 'file-3',
      originalFilename: 'IMG_2051.PNG',
      fileType: 'Photo',
      mimeType: 'image/png',
      fileSizeLabel: '3.9 MB',
      uploaderName: 'You',
      uploadedLabel: 'Yesterday',
      isVideo: false,
    ),
    MediaFile(
      id: 'file-4',
      originalFilename: 'IMG_2052.JPG',
      fileType: 'Photo',
      mimeType: 'image/jpeg',
      fileSizeLabel: '6.1 MB',
      uploaderName: 'You',
      uploadedLabel: 'Monday',
      isVideo: false,
    ),
  ];
}
