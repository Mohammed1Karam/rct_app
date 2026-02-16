part of 'receipts_cubit.dart';

@immutable
sealed class ReceiptsState {}

final class ReceiptsInitial extends ReceiptsState {}

final class ReceiptsSuccess extends ReceiptsState {}

final class ReceiptsFailure extends ReceiptsState {
  final String message;
  ReceiptsFailure(this.message);
}

final class ReceiptsLoading extends ReceiptsState {}
