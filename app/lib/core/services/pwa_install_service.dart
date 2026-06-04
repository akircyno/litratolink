import 'package:shared_preferences/shared_preferences.dart';

// Conditional: uses dart:js_util on web, no-op stub everywhere else
import 'pwa_install_service_stub.dart'
    if (dart.library.js_interop) 'pwa_install_service_web.dart' as impl;

const _dismissedKey = 'pwa_install_dismissed_at';
const _cooldownDays = 14;

class PwaInstallService {
  static bool get isPromptAvailable => impl.isPromptAvailable();
  static bool get isInstalled => impl.isInstalled();
  static void promptInstall() => impl.promptInstall();

  static Future<bool> shouldShow() async {
    if (isInstalled || !isPromptAvailable) return false;

    final prefs = await SharedPreferences.getInstance();
    final dismissedAt = prefs.getInt(_dismissedKey);
    if (dismissedAt == null) return true;

    final dismissed = DateTime.fromMillisecondsSinceEpoch(dismissedAt);
    return DateTime.now().difference(dismissed).inDays >= _cooldownDays;
  }

  static Future<void> recordDismissal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dismissedKey, DateTime.now().millisecondsSinceEpoch);
  }
}
