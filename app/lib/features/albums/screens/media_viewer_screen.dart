import 'package:flutter/material.dart';

class MediaViewerArgs {
  const MediaViewerArgs({required this.files, required this.initialIndex});
  final List<dynamic> files;
  final int initialIndex;
}

class MediaViewerScreen extends StatelessWidget {
  const MediaViewerScreen({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
