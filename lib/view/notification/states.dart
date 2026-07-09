import 'package:rct/view/notification/notify_model.dart';

abstract class NotificationState {}

// Initial state when the app starts
class NotificationInitial extends NotificationState {}

// State when loading notifications
class NotificationLoading extends NotificationState {}

// State when notifications are successfully loaded
class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  NotificationLoaded(this.notifications);
}

// State when there is an error loading notifications
class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}

final class PostInitialState extends NotificationState {}

final class PostLoading extends NotificationState {}

final class PostSuccess extends NotificationState {
  PostSuccess();
}

final class PostFailure extends NotificationState {
  String errMessage;
  PostFailure({required this.errMessage});
}
