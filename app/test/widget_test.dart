import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:litratolink/app/app.dart';
import 'package:litratolink/config/env.dart';

void main() {
  testWidgets('shows the LitratoLink welcome flow', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appEnvProvider.overrideWithValue(
            const AppEnv(
              appEnv: 'test',
              supabaseUrl: '',
              supabaseAnonKey: '',
              googleWebClientId: '',
              googleIosClientId: '',
            ),
          ),
        ],
        child: const LitratoLinkApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Memories shared the way they were meant to be seen.'), findsOneWidget);
    expect(find.text('Share Memories in Original Quality'), findsWidgets);
  });
}
