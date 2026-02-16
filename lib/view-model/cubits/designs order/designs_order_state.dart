part of 'designs_order_cubit.dart';

@immutable
sealed class DesignsOrderState {}

final class DesignsOrderInitial extends DesignsOrderState {}

final class DesignsOrderSuccess extends DesignsOrderState {}

final class DesignsOrderLoading extends DesignsOrderState {}

final class DesignsOrderFailure extends DesignsOrderState {
  final String errMessage;
  DesignsOrderFailure(this.errMessage);
}
