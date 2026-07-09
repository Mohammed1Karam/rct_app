part of 'order_number_cubit.dart';

@immutable
sealed class OrderNumberState {}

final class OrderNumberInitial extends OrderNumberState {}

final class OrderNumberLoading extends OrderNumberState {}

final class OrderNumberFailure extends OrderNumberState {
  String errMessage;
  OrderNumberFailure({required this.errMessage});
}

final class OrderNumberSuccess extends OrderNumberState {
  final orderNumber;
  OrderNumberSuccess({required this.orderNumber});
}
