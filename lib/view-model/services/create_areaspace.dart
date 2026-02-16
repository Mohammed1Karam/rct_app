import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/view-model/services/crud.dart';

class CreateAreaSpace {
  final Crud _crud = Crud();
  Future<bool> create(String size, BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    return _crud.postRequest(
      linkAreaspaces,
      {"size": size},
    ).then((value) {
      if (value.containsKey("data")) {
        orderModel.areaspace_id = value["data"]["id"];
        if (kDebugMode) {
          print("areaSpace id: ${orderModel.areaspace_id}");
        }
        return true;
      } else {
        if (kDebugMode) {
          print("error in create areaSpace: $value");
        }
        return false;
      }
    });
    // .then((value) => orderModel.areaspace_id = value["data"]["id"])
    // .then((value) => );
  }
}
