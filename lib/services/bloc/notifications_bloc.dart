import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pasanaku_app/config/local_notifications/local_notifications.dart';
import 'package:pasanaku_app/domain/entities/push_message.dart';
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
    //TODO 3: Crear el listener # _onPushMessageReceived
    on<NotificationReceived>(_onPushMessageReceived);

    on<NotificationTokenChanged>(_notificationTokenChanged);
    
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
    print('token: $token');
    add(NotificationTokenChanged(token!));
  }

  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationsState> emit){
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();
  }
  void _notificationTokenChanged(NotificationTokenChanged event, Emitter<NotificationsState> emit){
    emit(
      state.copyWith(
        token: event.token
      )
    );
  }

  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationsState> emit){
    emit(
      state.copyWith(
        notifications: [event.message, ...state.notifications]
      )
    );
  }

  void handleRemoteMessage(RemoteMessage message){
    print('Messag data:${message.data}');
    if(message.notification == null) return;
    print(message.notification);
    final notification = PushMessage(
      messageId: message.messageId
        ?.replaceAll(':', '').replaceAll('%', '')
        ?? '', 
      title: message.notification!.title ?? '', 
      body: message.notification!.body ?? '', 
      sentDate:  message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
        ? message.notification!.android?.imageUrl
        : message.notification!.apple?.imageUrl
    );
    
    //TODO 1: add de un nuevo evento
    add(NotificationReceived(notification));
  }

  void _onForegroubdMessage(){
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
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

    // Solicitar permiso a las local notifications
    await requestPermissionLocalNotification();
    add(NotificationStatusChanged(settings.authorizationStatus));

  }

  PushMessage? getMessageById(String pushMessageId){
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);
    if(!exist) return null;
    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }


}
