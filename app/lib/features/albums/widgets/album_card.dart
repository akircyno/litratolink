import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/app_card.dart';
import '../models/album.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({
    required this.album,
    required this.onTap,
    super.key,
  });

  final Album album;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 116,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: album.coverColors,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.08,
                    child: GridPaper(
                      color: AppColors.white,
                      divisions: 1,
                      interval: 16,
                      subdivisions: 1,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.20),
                      border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.30),
                          width: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      album.role.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 14,
                  right: 16,
                  child: Text(
                    album.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.photo_outlined,
                        color: AppColors.softGold, size: 14),
                    const SizedBox(width: 4),
                    Text('${album.fileCount} files',
                        style: const TextStyle(
                            color: AppColors.mutedInk, fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.group_outlined,
                        color: AppColors.softGold, size: 14),
                    const SizedBox(width: 4),
                    Text('${album.memberCount} members',
                        style: const TextStyle(
                            color: AppColors.mutedInk, fontSize: 12)),
                    const Spacer(),
                    Text(album.updatedLabel,
                        style: const TextStyle(
                            color: AppColors.mutedInk, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
