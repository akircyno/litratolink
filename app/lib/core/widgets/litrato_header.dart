import 'package:flutter/material.dart';

import '../../app/theme.dart';

class LitratoHeader extends StatelessWidget {
  const LitratoHeader({
    this.title = 'Potoos',
    this.subtitle,
    this.avatarInitials,
    this.avatarUrl,
    this.showAvatar = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? avatarInitials;
  final String? avatarUrl;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final greeting = _greeting();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.midnightBurgundy, AppColors.deepMaroon],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderTitle(title: title),
                const SizedBox(height: 2),
                Text(
                  subtitle ?? greeting,
                  style: TextStyle(
                    color: AppColors.warmCream.withValues(alpha: 0.60),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (showAvatar) _Avatar(initials: avatarInitials, url: avatarUrl),
        ],
      ),
    );
  }

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning.';
    if (hour < 18) return 'Good afternoon.';
    return 'Good evening.';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.initials, this.url});

  final String? initials;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = url != null && url!.trim().isNotEmpty;

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.softGold, AppColors.garnetHighlight],
        ),
        border: Border.all(
            color: AppColors.brightGold.withValues(alpha: 0.45), width: 1.5),
      ),
      child: ClipOval(
        child: hasPhoto
            ? Image.network(
                url!.trim(),
                width: 34,
                height: 34,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _Initials(initials),
              )
            : _Initials(initials),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials(this.text);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text ?? '?',
        style: const TextStyle(
            color: AppColors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    if (title != 'Potoos') {
      return Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.warmCream,
              fontSize: 18,
            ),
      );
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.warmCream,
              fontSize: 18,
            ),
        children: const [
          TextSpan(text: 'Poto'),
          TextSpan(text: 'os', style: TextStyle(color: AppColors.brightGold)),
        ],
      ),
    );
  }
}
