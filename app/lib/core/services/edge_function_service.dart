import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/app_error.dart';
import 'supabase_service.dart';

final edgeFunctionServiceProvider = Provider<EdgeFunctionService>((ref) {
  return EdgeFunctionService(ref.watch(supabaseServiceProvider));
});

class EdgeFunctionService {
  const EdgeFunctionService(this.supabaseService);

  final SupabaseService supabaseService;

  Future<T> callFunction<T>(
    String functionName, {
    Map<String, dynamic> body = const {},
    T Function(Object? data)? parser,
  }) async {
    if (!supabaseService.isConfigured) {
      throw const AppError('Supabase is not configured yet.');
    }

    final session = supabaseService.currentSession;
    if (session == null) {
      throw const AppError('Please log in to continue.', code: 'UNAUTHENTICATED');
    }

    final response = await supabaseService.client.functions.invoke(
      functionName,
      body: body,
      headers: {'Authorization': 'Bearer ${session.accessToken}'},
      method: HttpMethod.post,
    );

    final payload = response.data;
    if (payload is! Map) {
      if (parser != null) return parser(payload);
      return payload as T;
    }

    final success = payload['success'] == true;
    if (!success) {
      throw AppError(
        payload['message']?.toString() ?? 'Something went wrong. Please try again.',
        code: payload['error_code']?.toString(),
      );
    }

    final data = payload['data'];
    if (parser != null) return parser(data);
    return data as T;
  }

  Future<T> call<T>(
    String functionName, {
    Map<String, dynamic> body = const {},
    T Function(Object? data)? parser,
  }) {
    return callFunction<T>(
      functionName,
      body: body,
      parser: parser,
    );
  }
}
