import 'package:flutter/material.dart';

import '../../app/theme.dart';

class QualityPromiseCard extends StatelessWidget {
  const QualityPromiseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepMaroon, AppColors.maroon],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepMaroon.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brightGold.withValues(alpha: 0.14),
              border: Border.all(
                  color: AppColors.brightGold.withValues(alpha: 0.32),
                  width: 0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_outlined,
                color: AppColors.brightGold, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Every file, exactly as you took it.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.warmCream,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nothing gets compressed. What goes in comes back out.',
                  style: TextStyle(
                    color: AppColors.warmCream.withValues(alpha: 0.68),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
