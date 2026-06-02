import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class LitratoLinkApp extends StatelessWidget {
  const LitratoLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LitratoLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      // On web, a hard refresh of a deep hash route (e.g. #/album-details)
      // would otherwise load that screen directly, but its in-memory
      // arguments are gone after a reload. Always start from the splash gate
      // so the session check runs and routes to Login or Home correctly.
      onGenerateInitialRoutes: (_) => [
        MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.splash),
          builder: AppRoutes.routes[AppRoutes.splash]!,
        ),
      ],
      // Safety net for any unrecognized route name: return to the gate.
      onUnknownRoute: (_) => MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.splash),
        builder: AppRoutes.routes[AppRoutes.splash]!,
      ),
    );
  }
}
