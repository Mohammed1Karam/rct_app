import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/cubits/sketches/sketches_state.dart';
import 'package:rct/view-model/services/crud.dart';

class SketchesCubit extends Cubit<SketchesState> {
  final Crud _crud = Crud();
  List<Map<String, dynamic>> _favoriteList = [];
  SketchesCubit() : super(SketchesInitial()) {}

  List<dynamic> sketchesList = [];
  bool _isDataLoaded = false;
  Future<void> loadSketches(BuildContext context) async {
    try {
      // Make the API request
      final response = await _crud.getRequest(linkSketches);

      if (response is Map<String, dynamic>) {
        // Check if response contains the "data" key
        if (response.containsKey("data")) {
          final sketchesData = response["data"];

          // Ensure "data" is a List
          if (sketchesData is List) {
            sketchesList = List<Map<String, dynamic>>.from(sketchesData);
            _isDataLoaded = true; // Mark as loaded

            if (kDebugMode) {
              print("Sketches List Loaded Successfully:");
              print(sketchesList);
            }

            // Emit success state with the loaded data
            emit(SketchesSuccess(sketches: sketchesList));
          } else {
            // Emit failure if "data" is not a List
            final errorMessage = "Unexpected 'data' format: $sketchesData";
            emit(SketchesFailure(errMessage: errorMessage));

            if (kDebugMode) {
              print(errorMessage);
            }
          }
        } else {
          // Emit failure if "data" key is missing
          final errorMessage = "Missing 'data' key in response: $response";
          emit(SketchesFailure(errMessage: errorMessage));

          if (kDebugMode) {
            print(errorMessage);
          }
        }
      } else {
        // Emit failure if response is not a Map
        final errorMessage = "Unexpected response format: $response";
        emit(SketchesFailure(errMessage: errorMessage));

        if (kDebugMode) {
          print(errorMessage);
        }
      }
    } catch (e, stackTrace) {
      // Handle exceptions
      final errorMessage = "Exception occurred: $e";
      emit(SketchesFailure(errMessage: errorMessage));

      if (kDebugMode) {
        print(errorMessage);
        print(stackTrace);
      }
    }
  }

  void resetData() {
    sketchesList.clear();
    _isDataLoaded = false;
  }

  static SketchesCubit get(context) => BlocProvider.of(context);
}
