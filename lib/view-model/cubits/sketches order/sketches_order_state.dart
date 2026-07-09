part of 'sketches_order_cubit.dart';

@immutable
sealed class SketchesOrderState {}

final class SketchesOrderInitial extends SketchesOrderState {}

final class SketchesOrderLoading extends SketchesOrderState {}

final class SketchesOrderSuccess extends SketchesOrderState {}

final class SketchesOrderFailure extends SketchesOrderState {
  final String errMessage;
  SketchesOrderFailure(this.errMessage);
}
