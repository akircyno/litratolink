import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../config/constants.dart';
import '../../../core/widgets/poto_mascot.dart';
import '../providers/auth_provider.dart';
import '../widgets/google_login_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AsyncLoading;

    ref.listen(authControllerProvider, (_, next) {
      if (next is AsyncData && !isLoading) {
        final hasSession = ref.read(currentUserProfileProvider) != null;
        if (hasSession && context.mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.midnightBurgundy, AppColors.deepMaroon],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const PotoMascot(expression: PotoExpression.idle, size: 110),
                  const SizedBox(height: 20),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: AppTheme.headingFont,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'Poto',
                          style: TextStyle(color: AppColors.pearlCream),
                        ),
                        TextSpan(
                          text: 'os',
                          style: TextStyle(color: AppColors.brightGold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    AppText.tagline,
                    style: TextStyle(
                      color: AppColors.featherTaupe,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'The people you love\ndeserve the real thing.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.pearlCream,
                          fontSize: 22,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'A private space for the people who were actually there.\nEvery photo and video, exactly as you took it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.pearlCream.withValues(alpha: 0.65),
                      fontSize: 13,
                      height: 1.65,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _Pill(icon: Icons.lock_outline, label: 'Just your people'),
                      _Pill(icon: Icons.high_quality_outlined, label: 'No compression, ever'),
                      _Pill(icon: Icons.group_outlined, label: 'By invite only'),
                    ],
                  ),
                  const Spacer(),
                  if (authState is AsyncError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Sign in failed. Please try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.brightGold.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  GoogleLoginButton(
                    isLoading: isLoading,
                    onPressed: () => ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'For the moments you want to keep, not perform.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.pearlCream.withValues(alpha: 0.40),
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.pearlCream.withValues(alpha: 0.06),
        border: Border.all(
          color: AppColors.brightGold.withValues(alpha: 0.22),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.brightGold, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.pearlCream.withValues(alpha: 0.65),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
