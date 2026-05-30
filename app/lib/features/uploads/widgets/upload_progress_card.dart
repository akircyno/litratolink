import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/app_progress_bar.dart';

class UploadProgressCard extends StatelessWidget {
  const UploadProgressCard({
    required this.name,
    required this.size,
    required this.progress,
    required this.status,
    this.done = false,
    this.waiting = false,
    super.key,
  });

  final String name;
  final String size;
  final double progress;
  final String status;
  final bool done;
  final bool waiting;

  @override
  Widget build(BuildContext context) {
    final statusColor = done
        ? const Color(0xFF3B6D11)
        : waiting
            ? AppColors.mutedInk
            : AppColors.maroon;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.creamLine, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.maroonFaint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image_outlined, color: AppColors.maroon, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 3),
                Text(size, style: const TextStyle(fontSize: 10, color: AppColors.mutedInk)),
                const SizedBox(height: 5),
                AppProgressBar(value: progress),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
