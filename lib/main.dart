import 'package:flutter/material.dart';

import 'package:pasanaku_app/config/router/app_router.dart';
import 'package:pasanaku_app/config/theme/appTheme.dart';
import 'package:pasanaku_app/providers/invitacion_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(),),
        ChangeNotifierProvider(create: (context) => InvitacionProvider(),),
      ],
      child: MaterialApp.router(
        theme: AppTheme().getTheme(),
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
