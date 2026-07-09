part of 'orders_list_cubit.dart';

@immutable
sealed class OrdersListState {}

final class OrdersListInitial extends OrdersListState {}

final class OrdersListLoading extends OrdersListState {}

final class OrdersListFailure extends OrdersListState {
  final String message;

  OrdersListFailure(this.message);
}

final class OrdersListSuccess extends OrdersListState {
  final List orders;

  OrdersListSuccess(this.orders);
}
