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
    );
  }
}
