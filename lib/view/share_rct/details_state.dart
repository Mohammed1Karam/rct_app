import 'package:rct/model/modelget.dart';

abstract class ShareDetailsState {}

class ShareDetailsInitial extends ShareDetailsState {}

class ShareDetailsLoading extends ShareDetailsState {}

class ShareDetailsSuccess extends ShareDetailsState {
  final Modelget product;
  ShareDetailsSuccess(this.product);
}

class ShareDetailsError extends ShareDetailsState {
  final String message;
  ShareDetailsError(this.message);
}
