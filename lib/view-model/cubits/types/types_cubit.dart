import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';

part 'types_state.dart';

class TypesCubit extends Cubit<TypesState> {
  TypesCubit() : super(TypesInitial());
  final Crud _crud = Crud();
  Future<void> get() async {
    try {
      emit(TypesLoading());
      final response = await _crud.getRequest(linkBuilds);
      if (response.containsKey("data")) {
        if (kDebugMode) {
          print(response["data"]);
        }
        emit(TypesSuccess(types: response["data"]));
        return response["data"];
      } else {
        emit(TypesFailure(errMessage: response.entries.toString()));
        if (kDebugMode) {
          print(response.entries.toString());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(TypesFailure(errMessage: "$e"));
    }
  }
}
