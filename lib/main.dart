
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasanaku_app/config/router/app_router.dart';
import 'package:pasanaku_app/config/theme/appTheme.dart';
import 'package:pasanaku_app/providers/cuota_provider.dart';
import 'package:pasanaku_app/providers/invitacion_provider.dart';
import 'package:pasanaku_app/providers/partida_provider.dart';
import 'package:pasanaku_app/providers/previuosRoute_provider.dart';
import 'package:pasanaku_app/providers/puja_provider.dart';
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
        ChangeNotifierProvider(create: (context) => PartidaProvider(),),
        ChangeNotifierProvider(create: (context) => PreviousRouteProvider(),),
        ChangeNotifierProvider(create: (context) => PujaProvider(),),
        ChangeNotifierProvider(create: (context) => CuotaProvider(),),
      ],
      child: MaterialApp.router(
        theme: AppTheme().getTheme(),
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => HandleNotificationInteractions(child: child!),
      ),
    );
  }
}

class HandleNotificationInteractions extends StatefulWidget {
  final Widget child;
  const HandleNotificationInteractions({super.key, required this.child});

  @override
  State<HandleNotificationInteractions> createState() => _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState extends State<HandleNotificationInteractions> {
  
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  
  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);
    final messageData = context.watch<NotificationsBloc>().state.notifications;
    final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '');
    // context.read<PreviousRouteProvider>().changeRoute(newRoute: '/${messageData[messageData.length].data!['path']}/$messageId');
    appRouter.push('/login');
  }

  @override
  void initState() {
    super.initState();
    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
    context.read<NotificationsBloc>().requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}