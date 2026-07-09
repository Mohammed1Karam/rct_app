import 'package:rct/model/renter_model.dart';

abstract class OwnershipDetailsState {}

class OwnershipDetailsInitial extends OwnershipDetailsState {}

class OwnershipDetailsLoading extends OwnershipDetailsState {}

class OwnershipDetailsSuccess extends OwnershipDetailsState {
  final RenterModel renter;
  OwnershipDetailsSuccess(this.renter);
}

class OwnershipDetailsError extends OwnershipDetailsState {
  final String message;
  OwnershipDetailsError(this.message);
}
