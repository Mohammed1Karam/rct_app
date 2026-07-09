abstract class Coopeativestates {}

class InitialCooperativeStates extends Coopeativestates {}

class RawLandLoadingStates extends Coopeativestates {}

class RawLandSuccessStates extends Coopeativestates {}

class RawLandFailedStates extends Coopeativestates {
  final String message;

  RawLandFailedStates(
    this.message,
  );
}

class OldBildingsLoadingStates extends Coopeativestates {}

class OldBildingSuccessStates extends Coopeativestates {}

class OldBildingFailedStates extends Coopeativestates {
  final String message;

  OldBildingFailedStates(
    this.message,
  );
}

class PlansLoadingStates extends Coopeativestates {}

class PlansSuccessStates extends Coopeativestates {}

class PlansFailedStates extends Coopeativestates {
  final String message;

  PlansFailedStates(
    this.message,
  );
}
