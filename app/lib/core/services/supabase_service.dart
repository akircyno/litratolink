import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/env.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(ref.watch(appEnvProvider));
});

class SupabaseService {
  const SupabaseService(this.env);

  final AppEnv env;

  bool get isConfigured => env.hasSupabaseConfig;

  SupabaseClient get client {
    if (!isConfigured) {
      throw StateError(
        'Supabase is not configured. Add SUPABASE_URL and SUPABASE_ANON_KEY to app/.env.',
      );
    }

    return Supabase.instance.client;
  }

  Session? get currentSession {
    if (!isConfigured) return null;
    return client.auth.currentSession;
  }
}
