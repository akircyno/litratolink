import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/app_screen.dart';
import '../../../core/widgets/save_all_ring.dart';

class SaveAllScreen extends StatelessWidget {
  const SaveAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppScreen(
        padding: EdgeInsets.zero,
        children: const [
          _SaveHeader(),
          SizedBox(height: 14),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: AppCard(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SaveAllRing(progress: 0.65),
                  SizedBox(height: 12),
                  Text('Saving your memories', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('159 of 245 files saved to Photos', style: TextStyle(color: AppColors.mutedInk, fontSize: 12)),
                  SizedBox(height: 18),
                  AppProgressBar(value: 0.65),
                  SizedBox(height: 16),
                  _SaveFileRow(icon: Icons.check_circle, name: 'IMG_20250529_001.jpg', status: 'Saved', done: true),
                  _SaveFileRow(icon: Icons.check_circle, name: 'IMG_20250529_002.jpg', status: 'Saved', done: true),
                  _SaveFileRow(icon: Icons.download, name: 'VID_20250529_003.mp4', status: 'Saving...', active: true),
                  _SaveFileRow(icon: Icons.schedule, name: 'IMG_20250529_004.jpg', status: 'Queued'),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text(
              'Original files are saved directly to your Photos app.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedInk, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveHeader extends StatelessWidget {
  const _SaveHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.deepMaroon,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close, color: AppColors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Text('Cancel', style: TextStyle(color: AppColors.white.withValues(alpha: 0.70), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Save All',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.warmCream),
          ),
          const SizedBox(height: 5),
          Text(
            'Me & Sofia - 245 files',
            style: TextStyle(color: AppColors.warmCream.withValues(alpha: 0.60), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _SaveFileRow extends StatelessWidget {
  const _SaveFileRow({
    required this.icon,
    required this.name,
    required this.status,
    this.done = false,
    this.active = false,
  });

  final IconData icon;
  final String name;
  final String status;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = done
        ? const Color(0xFF3B6D11)
        : active
            ? AppColors.maroon
            : AppColors.mutedInk;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
