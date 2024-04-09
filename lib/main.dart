import 'package:flutter/material.dart';
import 'package:pasanaku_app/config/router/app_router.dart';
import 'package:pasanaku_app/config/theme/appTheme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
