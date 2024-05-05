import 'package:go_router/go_router.dart';
import 'package:pasanaku_app/pages/Dowload.dart';
import 'package:pasanaku_app/pages/HomePAge.dart';
import 'package:pasanaku_app/pages/InvitacionPage.dart';
import 'package:pasanaku_app/pages/InvitacionesPage.dart';
import 'package:pasanaku_app/pages/Login_Page.dart';
import 'package:pasanaku_app/pages/NotificacionPage.dart';
import 'package:pasanaku_app/pages/PartidaPage.dart';
import 'package:pasanaku_app/pages/PujaPage.dart';
import 'package:pasanaku_app/pages/QRDetallesPage.dart';
import 'package:pasanaku_app/pages/QRupdate.dart';
import 'package:pasanaku_app/pages/RegisterPage.dart';
import 'package:pasanaku_app/pages/ScanCodePage.dart';
import 'package:pasanaku_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authenticated =
          Provider.of<UserProvider>(context, listen: false).state;
      if (state.fullPath == '/register') return '/register';
      if (authenticated == 'no-authenticated') return '/login';
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
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/invitations',
        name: InvitacionesPage.name,
        builder: (context, state) => const InvitacionesPage(),
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
        path: '/notificacion',
        name: NotificacionPage.name,
        builder: (context, state) => const NotificacionPage(),
      ),
      GoRoute(
        path: '/downloader',
        name: SingleDownloader.name,
        builder: (context, state) => const SingleDownloader(),
      ),
      GoRoute(
        path: '/qr-update',
        name: QRupdate.name,
        builder: (context, state) => const QRupdate(),
      ),
      GoRoute(
        path: '/qr-scan',
        name: ScanCodePage.name,
        builder: (context, state) => const ScanCodePage(),
      ),
      GoRoute(
        path: '/qr-details/:messageId',
        name: QRDetallesPage.name,
        builder: (context, state) => QRDetallesPage(
          pushMessageId: state.pathParameters['messageId'] ?? '',
        ),
      ),
    ]);
