import 'package:rct/model/modelget.dart';

abstract class RealEstateDetailsState {}

class RealEstateDetailsInitial extends RealEstateDetailsState {}

class RealEstateDetailsLoading extends RealEstateDetailsState {}

class RealEstateDetailsSuccess extends RealEstateDetailsState {
  final Modelget product;
  RealEstateDetailsSuccess(this.product);
}

class RealEstateDetailsError extends RealEstateDetailsState {
  final String message;
  RealEstateDetailsError(this.message);
}
