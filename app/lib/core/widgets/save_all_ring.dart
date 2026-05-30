import 'package:flutter/material.dart';

import '../../app/theme.dart';

class SaveAllRing extends StatelessWidget {
  const SaveAllRing({
    required this.progress,
    super.key,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return SizedBox(
      width: 82,
      height: 82,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 5,
              backgroundColor: AppColors.maroonTint,
              color: AppColors.maroon,
            ),
          ),
          Text(
            '$percent%',
            style: const TextStyle(
              color: AppColors.deepMaroon,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
