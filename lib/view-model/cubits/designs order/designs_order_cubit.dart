import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/designs_order_model.dart';
import 'package:rct/view-model/services/crud.dart';

part 'designs_order_state.dart';

class DesignsOrderCubit extends Cubit<DesignsOrderState> {
  DesignsOrderCubit() : super(DesignsOrderInitial());
  final Crud crud = Crud();

  Future<void> designOrder(DesignsOrderModel model) async {
    emit(DesignsOrderLoading());
    final response = await crud.postRequest(
      linkAreaspaces,
      {
        // "id":model.id,
        "description": model.description,
        // ignore: equal_keys_in_map
        "description": model.description,

        "name": "name",
      },
    );
    if (response.containsKey("data")) {
      emit(DesignsOrderSuccess());
      // orderModel.areaspace_id = value["data"]["id"];
      // if (kDebugMode) {
      //   print("areaSpace id: ${orderModel.areaspace_id}");
      // }
      // return true;
    } else {
      emit(DesignsOrderFailure(response[0].toString()));
      // if (kDebugMode) {
      //   print("error in create areaSpace: $value");
      // }
      // return false;
    }
  }
}
