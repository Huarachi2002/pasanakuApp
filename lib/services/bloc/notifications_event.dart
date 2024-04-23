part of 'notifications_bloc.dart';

sealed class NotificationsEvent{
  const NotificationsEvent();
}

class NotificationStatusChanged extends NotificationsEvent{
  final AuthorizationStatus status;

  NotificationStatusChanged(this.status);
  
}

//TODO2: NotificationReceived # PushMessage
class NotificationReceived extends NotificationsEvent{
  final PushMessage message;
  NotificationReceived(this.message);
}

class NotificationTokenChanged extends NotificationsEvent {
  final String token;
  NotificationTokenChanged(this.token);
}
