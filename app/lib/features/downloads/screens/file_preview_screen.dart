import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/app_screen.dart';
import '../../albums/models/media_file.dart';
import '../providers/download_provider.dart';
import '../widgets/download_button.dart';

class FilePreviewScreen extends ConsumerWidget {
  const FilePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeFile = ModalRoute.of(context)?.settings.arguments;
    if (routeFile is! MediaFile) {
      return Scaffold(
        appBar: AppBar(title: const Text('File Preview')),
        body: const AppScreen(
          children: [
            AppEmptyState(
              title: 'File unavailable',
              message: 'Open a completed file from an album first.',
            ),
          ],
        ),
      );
    }

    final file = routeFile;
    final downloadState = ref.watch(downloadControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('File Preview')),
      body: AppScreen(
        children: [
          Container(
            height: 320,
            decoration: BoxDecoration(
              color: AppColors.creamLine,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, color: AppColors.maroon, size: 70),
            ),
          ),
          const SizedBox(height: 18),
          Text(file.originalFilename, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            '${file.fileType} - ${file.fileSizeLabel} - ${file.mimeType}',
            style: const TextStyle(color: AppColors.mutedInk),
          ),
          const SizedBox(height: 4),
          Text(
            'Uploaded by ${file.uploaderName} - ${file.uploadedLabel}',
            style: const TextStyle(color: AppColors.mutedInk),
          ),
          const SizedBox(height: 20),
          AppCard(
            child: AppProgressBar(
              value: downloadState.progress,
              label: downloadState.isDownloading
                  ? 'Downloading original'
                  : downloadState.downloadedFile != null
                      ? 'Download complete'
                      : 'Download progress',
            ),
          ),
          if (downloadState.errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              downloadState.errorMessage!,
              style: const TextStyle(color: AppColors.maroon, fontWeight: FontWeight.w700),
            ),
          ],
          if (downloadState.downloadedFile != null) ...[
            const SizedBox(height: 10),
            Text(
              'Saved to ${downloadState.downloadedFile!.savedPath}',
              style: const TextStyle(color: AppColors.mutedInk, fontSize: 12),
            ),
          ],
          const SizedBox(height: 18),
          DownloadButton(
            isDownloading: downloadState.isDownloading,
            onPressed: () => ref.read(downloadControllerProvider.notifier).download(file),
          ),
          const SizedBox(height: 10),
          const Text(
            'Download must use the original file, never a thumbnail.',
            style: TextStyle(color: AppColors.maroon, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
