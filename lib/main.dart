
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pasanaku_app/config/router/app_router.dart';
import 'package:pasanaku_app/config/theme/appTheme.dart';
import 'package:pasanaku_app/providers/invitacion_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:pasanaku_app/services/bloc/notifications_bloc.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  await NotificationsBloc.initializeFirebaseNotifications();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => NotificationsBloc())
      ],
      child: const MainApp(),
    ),
  );
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
