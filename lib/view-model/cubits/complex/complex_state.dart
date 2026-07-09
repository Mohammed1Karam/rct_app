part of 'complex_cubit.dart';

@immutable
sealed class ComplexState {}

final class ComplexInitial extends ComplexState {}

final class ComplexLoading extends ComplexState {}

final class ComplexSuccess extends ComplexState {}

final class ComplexFailure extends ComplexState {
  final String errMessage;
  ComplexFailure({required this.errMessage});
}
