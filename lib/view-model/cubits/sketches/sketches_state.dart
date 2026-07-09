import 'package:flutter/foundation.dart';

@immutable
sealed class SketchesState {}

final class SketchesInitial extends SketchesState {}

final class SketchesLoading extends SketchesState {}

final class SketchesSuccess extends SketchesState {
  final List<dynamic>
      sketches; // Adjust the type according to your data structure

  SketchesSuccess({required this.sketches});
}

final class SketchesFailure extends SketchesState {
  final String errMessage;

  SketchesFailure({required this.errMessage});
}
