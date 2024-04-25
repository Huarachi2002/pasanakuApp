
import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/pages/DetailsPage.dart';
import 'package:pasanaku_app/pages/HomePAge.dart';
import 'package:pasanaku_app/pages/InvitacionPage.dart';
import 'package:pasanaku_app/pages/Login_Page.dart';
import 'package:pasanaku_app/pages/NotificacionPage.dart';
import 'package:pasanaku_app/pages/PartidaPage.dart';
import 'package:pasanaku_app/pages/PujaPage.dart';
import 'package:pasanaku_app/pages/RegisterPage.dart';
import 'package:pasanaku_app/providers/previuosRoute_provider.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final authenticated = Provider.of<UserProvider>(context, listen: false).state;
    // print(authenticated);
    // print('path: ${state.path}');
    // print('name: ${state.name}');
    // print('Fullpath: ${state.fullPath}');
    if(state.fullPath == '/register') return '/register'; 
    if(authenticated == 'no-authenticated') return '/login';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: LoginPage.name,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: RegisterPage.name,
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      name: HomePage.name,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/notificacion',
      name: NotificacionPage.name,
      builder: (context, state) => const NotificacionPage(),
    ),
    GoRoute(
      path: '/partida',
      name: PartidaPage.name,
      builder: (context, state) => const PartidaPage(),
    ),
    GoRoute(
      path: '/invitacion',
      name: InvitacionPage.name,
      builder: (context, state) => const InvitacionPage(),
    ),
    GoRoute(
      path: '/puja',
      name: PujaPage.name,
      builder: (context, state) => const PujaPage(),
    ),
    GoRoute(
      path: '/push-details/:messageId',
      // name: InvitacionPage.name,
      builder: (context, state) => DetailsPage(pushMessageId: state.pathParameters['messageId']??'',),
    ),
    
  ]
);