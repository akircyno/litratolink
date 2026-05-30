import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../config/constants.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/widgets/brand_mark.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () async {
      if (mounted) {
        final session = ref.read(supabaseServiceProvider).currentSession;
        if (session != null) {
          await ref.read(authControllerProvider.notifier).loadCurrentUserProfile();
        }

        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          session == null ? AppRoutes.login : AppRoutes.home,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BrandMark(size: 88),
                const SizedBox(height: 22),
                Text(AppText.appName, style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 8),
                const Text(
                  AppText.tagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.mutedInk),
                ),
                const SizedBox(height: 28),
                const CircularProgressIndicator(color: AppColors.softGold),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
