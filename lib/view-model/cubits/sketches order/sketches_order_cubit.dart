import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/sketches_order_model.dart';
import 'package:rct/view-model/services/crud.dart';

part 'sketches_order_state.dart';

class SketchesOrderCubit extends Cubit<SketchesOrderState> {
  SketchesOrderCubit() : super(SketchesOrderInitial());
    final Crud crud = Crud();
  Future<void> designOrder(SketchesOrderModel model) async {
    emit(SketchesOrderLoading());
    final response = await crud.postRequest(
      linkAreaspaces,
      {
        "description": model.description,
        // "id":model.id,
        "name": "name",
      },
    );
    if (response.containsKey("data")) {
      emit(SketchesOrderSuccess());
      // orderModel.areaspace_id = value["data"]["id"];
      // if (kDebugMode) {
      //   print("areaSpace id: ${orderModel.areaspace_id}");
      // }
      // return true;
    } else {
      emit(SketchesOrderFailure(response[0].toString()));
      // if (kDebugMode) {
      //   print("error in create areaSpace: $value");
      // }
      // return false;
    }
  }

}
