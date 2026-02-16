import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/complex_model.dart';
import 'package:rct/view-model/services/crud.dart';

part 'complex_state.dart';

class ComplexCubit extends Cubit<ComplexState> {
  ComplexCubit() : super(ComplexInitial());
  final Crud crud = Crud();
  Future<void> createComplex(ComplexModel model) async {
    emit(ComplexLoading());
    try {
      await crud.postRequest(linkComplex, {
        "floorcount": model.floorCount,
        "departmentcount": model.departmentCount,
        "build_id": model.buildId,
      });
      emit(ComplexSuccess());
    } catch (e) {
      emit(ComplexFailure(errMessage: e.toString()));
    }
  }
}
