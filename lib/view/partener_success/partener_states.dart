import 'package:rct/view/partener_success/model.dart';

abstract class PartenerStates {}

class IntialPartenerStates extends PartenerStates {}

class PartenerLoading extends PartenerStates {}

class PartenerSuccess extends PartenerStates {
  final List<PartenerModel>? data;
  PartenerSuccess({this.data});
}

class PartenerFailed extends PartenerStates {
  String? message;

  PartenerFailed({this.message});
}
