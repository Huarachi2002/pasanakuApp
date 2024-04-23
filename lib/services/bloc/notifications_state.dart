part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final AuthorizationStatus status;
  final List<PushMessage> notifications;
  final String token;
  
  const NotificationsState({this.token = '',this.status = AuthorizationStatus.notDetermined,this.notifications = const[]});
  
  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<PushMessage>? notifications,
    String? token,
  }) => NotificationsState(
    status: status ?? this.status,
    notifications:  notifications?? this.notifications,
    token: token ?? this.token
  );

  @override
  List<Object> get props => [status, notifications, token];
}

