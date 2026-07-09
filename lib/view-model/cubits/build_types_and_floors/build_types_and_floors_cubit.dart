import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/build_types_model.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/view-model/services/crud.dart';

part 'build_types_and_floors_state.dart';

class BuildTypesAndFloorsCubit extends Cubit<BuildTypesAndFloorsState> {
  BuildTypesAndFloorsCubit() : super(BuildTypesAndFloorsInitial());
  final Crud _crud = Crud();

  Future<void> getBuildTypes(BuildContext context) async {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    emit(BuildTypesAndFloorsLoading());
    try {
      final response = await _crud.getRequest(linkBuildstypes);
      final floorCounts = await _crud.getRequest(
          orderModel.type_id != null && orderModel.type_id != ""
              ? "$linkServerName/api/builds/${orderModel.type_id}/floors"
              : "$linkServerName/api/builds/1/floors");

      if (response.containsKey("data")) {
        if (kDebugMode) {

          print(response["data"]);
        }
        emit(BuildTypesAndFloorsSuccess(
          buildTypes: List<BuildTypesModel>.from(
            response["data"].map(
              (x) => BuildTypesModel.fromJson(x),
            ),
          ),
        ));
        if (floorCounts.containsKey("data")) {
          print("${floorCounts}floorCounts[" "data" "]");
          orderModel.floorDetails = floorCounts["data"];
        } else {
          print("${floorCounts}floorCounts[" "data" "]");

          if (kDebugMode) {
            print(floorCounts.toString());
          }
        }
        return response["data"];
      } else {
        emit(BuildTypesAndFloorsFailure(
            errMessage: response.entries.toString()));
        if (kDebugMode) {
          print(response.entries.toString());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(BuildTypesAndFloorsFailure(errMessage: "$e"));
    }
  }
}
