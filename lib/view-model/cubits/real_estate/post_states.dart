import 'package:meta/meta.dart';

@immutable
abstract class HouseStates {}

final class HouseInitiall extends HouseStates {}

final class HouseLoadingg extends HouseStates {}

final class HouseSuccesss extends HouseStates {}

// ignore: must_be_immutable
final class HouseFaild extends HouseStates {
  String errMessage;
  HouseFaild({required this.errMessage});
}

class notificationSentSuccessfullyState extends HouseStates {}

class failedToSentNotification extends HouseStates {
  final String message;

  failedToSentNotification(this.message);

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [message];
}
