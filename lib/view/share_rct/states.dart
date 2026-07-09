import 'package:rct/model/modelget.dart';

abstract class ShareState {}

class ShareInitial extends ShareState {}

class ShareLoading extends ShareState {}

class ShareSuccess extends ShareState {
  final List<Modelget> data;

  ShareSuccess(
    this.data,
  );
}

class ShareFavouriteSuccess extends ShareState {
  final List<Modelget> Share;

  ShareFavouriteSuccess(this.Share);
}

class ShareError extends ShareState {
  final String message;

  ShareError(
    this.message,
  );

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [message];
}

class ShareFilterloadingssState extends ShareState {}

class ShareFilterCategorySuccessState extends ShareState {
  final List<Modelget> Share;

  ShareFilterCategorySuccessState(this.Share);
}

class GetAboutUsLoadingState extends ShareState{}
class GetAboutUsSuccessState extends ShareState{}
class GetAboutUsErrorState extends ShareState{}

class GetTermsConditionsLoadingState extends ShareState{}
class GetTermsConditionsSuccessState extends ShareState{}
class GetTermsConditionsErrorState extends ShareState{}
class GetPrivacyListLoadingState extends ShareState{}
class GetPrivacyListSuccessState extends ShareState{}
class GetPrivacyListErrorState extends ShareState{}