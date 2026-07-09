import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/services/crud.dart';
part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());
  final Crud _crud = Crud();
  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  Future<void> uploadImages(Map<String, File?> images, String token) async {
    final token = await _getAuthToken();
    for (var entry in images.entries) {
      if (entry.value != null) {
        await _crud.postRequestWithFiles(
          '$linkServerName/api/orders',
          {'imageType': entry.key},
          {entry.key: entry.value},
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        );
      }
    }
  }

  Future<void> pushOrder(BuildContext context) async {
    void generateNewOrderNumber(OrderModel orderModel) {
      final random = Random();
      orderModel.number = (random.nextInt(100000) + 1).toString();
    }

    final token = await _getAuthToken();
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);

    generateNewOrderNumber(orderModel);
    if (!_validateOrder(orderModel)) {
      emit(OrderFailure(errMessage: "Please fill in all required fields."));
      return;
    }

    emit(OrderLoading());
    Map<String, File?> images = {
      'nationalidimage': orderModel.nationalidimage,
      'electronicimage': orderModel.electronicimage,
      'landcheckimage': orderModel.landCheckImage,
    };

    try {
      print(orderModel.birthDate);
      print(orderModel.nationalIdNumber);
      var result = await _crud.postRequestWithFiles(
        '$linkServerName/api/orders',
        {
          "build_id": orderModel.type_id.toString() ?? 1,
          "location": orderModel.location.toString() ?? "",
          "lat": orderModel.lat.toString() ?? "",
          "status": orderModel.status.toString() ?? "",
          "agreement": orderModel.agreement.toString() ?? "pending",
          "number": orderModel.number.toString() ?? "",
          "cost": orderModel.cost.toString() ?? "",
          "area": orderModel.areaspace.toString() ?? "",
          "has_pool": orderModel.has_pool.toString() ?? 0,
          "buildtype_id": orderModel.buildtype_id.toString() ?? 1,
          "floorcount": orderModel.floorcount.toString() ?? "",
          "main_type": orderModel.main_type.toString() ?? "",
          "client_birth": orderModel.birthDate.toString() ?? "",
          "identity_number": orderModel.nationalIdNumber.toString() ?? "",
          "finalforms": orderModel.finalForm.toString() ?? "",
          "streatdetail": orderModel.streetDetails.toString() ?? "",
          "user_status": "pending",
          "agreed_terms": 1.toString(),
          "coupon": "KVJUYU2J",
          "long": orderModel.long.toString() ?? "",
        },
        images,
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        },
      );

      if (result.containsKey("data")) {
        // Check if 'data' is empty
        if (result['data'].isEmpty) {
          emit(OrderFailure(errMessage: "No order numbers found."));
        } else {
          emit(OrderSuccess());
        }
      } else {
        emit(OrderFailure(
            errMessage: "Failed to upload order. Please try again."));
      }
    } catch (e) {
      emit(OrderFailure(errMessage: "An error occurred: $e"));
    }
  }

  bool _validateOrder(OrderModel orderModel) {
    return orderModel.type_id != null &&
        orderModel.location != null &&
        orderModel.lat != null &&
        orderModel.long != null &&
        orderModel.status != null &&
        orderModel.agreement != null &&
        orderModel.number != null &&
        orderModel.electronicimage != null;
  }
}
