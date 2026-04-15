import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import 'app_router.dart';

class CatDirectoryApp extends StatelessWidget {
  const CatDirectoryApp({super.key, this.router});

  final GoRouter? router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cat Directory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router ?? AppRouter.router,
    );
  }
}
