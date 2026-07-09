part of 'types_cubit.dart';

@immutable
sealed class TypesState {}

final class TypesInitial extends TypesState {}

final class TypesSuccess extends TypesState {
  final types;
  TypesSuccess({required this.types});
}

final class TypesLoading extends TypesState {}

final class TypesFailure extends TypesState {
  final String errMessage;
  TypesFailure({required this.errMessage});
}
