import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pasanaku_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print('message: ${message.data}');
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    //Verificar estado de las notificaciones
    _initialStatusCheck();
    // Listener para notificaciones en Foreground
    _onForegroubdMessage();
  }

  static Future<void> initializeFirebaseNotifications()async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _initialStatusCheck()async{
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));

  }
  
  void _getFCMToken()async{
    if(state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print(token);
  }

  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationsState> emit){
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();
  }

  void _handleRemoteMessage(RemoteMessage message){
    print('Messag data:${message.data}');
    if(message.notification == null) return;
    print(message.notification);

  }

  void _onForegroubdMessage(){
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,  
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true
    );
    add(NotificationStatusChanged(settings.authorizationStatus));

  }


}
