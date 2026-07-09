part of 'renters_cubit.dart';

abstract class RentersState {}

final class RentersInitial extends RentersState {}

final class GetRenterLoading extends RentersState {}
final class GetRenterSuccess extends RentersState {
  final List<RenterModel> renters;
  GetRenterSuccess(this.renters);
}
final class GetRenterError extends RentersState {
  final String? message;
  GetRenterError([this.message]);
}

final class FilterSuccessState extends RentersState {
  final List<RenterModel> renters;
  FilterSuccessState(this.renters);
}

final class SearchSuccess extends RentersState {
  final List<RenterModel> renters;
  SearchSuccess(this.renters);
}

final class PayContractLoading extends RentersState {}
final class PayContractSuccess extends RentersState {}
final class PayContractError extends RentersState {
  final String? message;
  PayContractError([this.message]);
}

final class GetContractLoading extends RentersState {}
final class GetContractSuccess extends RentersState {
  final List<ContractModel> contracts;
  GetContractSuccess(this.contracts);
}
final class GetContractError extends RentersState {
  final String? message;
  GetContractError([this.message]);
}
