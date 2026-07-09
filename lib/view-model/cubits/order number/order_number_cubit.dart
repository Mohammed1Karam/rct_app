import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart'; // Dio import
import 'package:flutter/foundation.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';

part 'order_number_state.dart';

class OrderNumberCubit extends Cubit<OrderNumberState> {
  final Dio _dio = Dio(); // Create a Dio instance

  OrderNumberCubit() : super(OrderNumberInitial());

  Future<void> fetchOrders() async {
    emit(OrderNumberLoading());
    final token = await _getAuthToken();
    if (token == null) {
      emit(OrderNumberFailure(errMessage: 'Auth token is null.'));
      return;
    }

    try {
      Options options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          "Accept-Language": CacheHelper.getData(key: "lang"),
        },
      );

      final response =
          await _dio.get("$linkServerName/api/user/orders", options: options);

      if (response.statusCode == 200) {
        // Adjust to check for 'orders' instead of 'data'
        if (response.data.containsKey("orders") && response.data["orders"]["data"] is List) {
          final List<dynamic> orders = response.data["orders"]["data"];

          if (orders.isNotEmpty) {
            emit(OrderNumberSuccess(orderNumber: orders));
          } else {
            emit(OrderNumberFailure(errMessage: 'No orders found.'));
          }
        } else {
          emit(OrderNumberFailure(
              errMessage:
                  'Invalid response format: Missing "orders" key or it is not a list.'));
        }
      } else {
        emit(OrderNumberFailure(
            errMessage:
                'Failed to fetch orders. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(OrderNumberFailure(errMessage: e.toString()));
    }
  }
}

Future<String?> _getAuthToken() async {
  return AppPreferences.getData(key: 'loginToken');
}
