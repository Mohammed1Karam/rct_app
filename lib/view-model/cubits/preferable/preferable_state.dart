part of 'preferable_cubit.dart';

@immutable
sealed class PreferableState {}

final class PreferableInitial extends PreferableState {}

final class PreferableLoading extends PreferableState {}

final class PreferableSuccess extends PreferableState {}

final class PreferableFailure extends PreferableState {
  String errMessage;
  PreferableFailure({required this.errMessage});
}
