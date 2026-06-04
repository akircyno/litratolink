import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../services/pwa_install_service.dart';
import 'pressable_scale.dart';

/// Shows a subtle install-to-home-screen prompt after a delay.
/// Only appears on web when the browser has a deferred install event,
/// the app isn't already installed, and the user hasn't dismissed
/// within the last 14 days.
class PwaInstallBanner extends StatefulWidget {
  const PwaInstallBanner({super.key});

  @override
  State<PwaInstallBanner> createState() => _PwaInstallBannerState();
}

class _PwaInstallBannerState extends State<PwaInstallBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  bool _visible = false;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _slide = Tween(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Wait 10 seconds after the home screen loads, then check conditions
    _delayTimer = Timer(const Duration(seconds: 10), _checkAndShow);
  }

  Future<void> _checkAndShow() async {
    final should = await PwaInstallService.shouldShow();
    if (!should || !mounted) return;
    setState(() => _visible = true);
    _controller.forward();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    if (mounted) setState(() => _visible = false);
    await PwaInstallService.recordDismissal();
  }

  Future<void> _install() async {
    PwaInstallService.promptInstall();
    await _controller.reverse();
    if (mounted) setState(() => _visible = false);
    await PwaInstallService.recordDismissal();
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.fromLTRB(
              AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: AppColors.velvetMaroon.withValues(alpha: 0.12),
              width: 0.8,
            ),
            boxShadow: AppShadows.float,
          ),
          child: Row(
            children: [
              // Poto app icon
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Image.asset(
                  'assets/logo/potoos_logo.webp',
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Potoos to your home screen.',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFont,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepMaroon,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Faster access, works offline.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.featherTaupe,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Install button
              PressableScale(
                onTap: _install,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.velvetMaroon,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Text(
                    'Install',
                    style: TextStyle(
                      color: AppColors.pearlCream,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Dismiss
              GestureDetector(
                onTap: _dismiss,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.featherTaupe,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
