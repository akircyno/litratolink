import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appEnvProvider = Provider<AppEnv>((ref) {
  throw UnimplementedError('AppEnv must be overridden in ProviderScope.');
});

class AppEnv {
  const AppEnv({
    required this.appEnv,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.googleWebClientId,
    required this.googleIosClientId,
  });

  final String appEnv;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String googleWebClientId;
  final String googleIosClientId;

  bool get hasSupabaseConfig {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }

  static Future<AppEnv> load() async {
    await dotenv.load(fileName: '.env', isOptional: true);

    return AppEnv(
      appEnv: dotenv.maybeGet('APP_ENV', fallback: 'development') ?? 'development',
      supabaseUrl: dotenv.maybeGet('SUPABASE_URL', fallback: '') ?? '',
      supabaseAnonKey: dotenv.maybeGet('SUPABASE_ANON_KEY', fallback: '') ?? '',
      googleWebClientId: dotenv.maybeGet('GOOGLE_WEB_CLIENT_ID', fallback: '') ?? '',
      googleIosClientId: dotenv.maybeGet('GOOGLE_IOS_CLIENT_ID', fallback: '') ?? '',
    );
  }
}
