part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterSuccess extends RegisterState {}

final class RegisterFailed extends RegisterState {
  final String errMessage;
  RegisterFailed({required this.errMessage});
}

final class RegisterLoading extends RegisterState {}
