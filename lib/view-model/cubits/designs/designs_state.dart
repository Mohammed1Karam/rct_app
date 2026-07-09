abstract class DesignsState {}

final class DesignsInitial extends DesignsState {}

final class DesignsLoading extends DesignsState {}

final class DesignsSuccess extends DesignsState {
  final List<dynamic>
      designs; // Adjust the type according to your data structure

  DesignsSuccess({required this.designs});
}

final class DesignsFailure extends DesignsState {
  final String errMessage;

  DesignsFailure({required this.errMessage});
}
