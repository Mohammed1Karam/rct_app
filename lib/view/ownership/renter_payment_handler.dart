import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rct/common%20copounents/sharewepview.dart';

import 'package:rct/constants/linkapi.dart';
import 'package:rct/shared_pref.dart';

class RenterPaymentHandler {
  static final Dio _dio = Dio();

  static Future<String?> _getAuthToken() async {
    return await AppPreferences.getData(key: 'loginToken');
  }

  static Future<void> createRenterAndPay({
    required BuildContext context,
    required dynamic city,
    required dynamic id,
    required dynamic district,
    required dynamic phone,
  }) async {
    try {
      final token = await _getAuthToken();
      print('TOKEN: $token');
      var data = json.encode({
        "type": "renter",
        "id": id,
        "payment_type": "down_payment",
        "phone": phone,
        "city": city,
        "district": district,
      });
      print('Request Body: $data');
      final postResponse = await _dio.post(
        '$linkServerName/api/payments/initiate',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('Response Status: ${postResponse.statusCode}');
      print('Response Data: ${postResponse.data}');
        final responseData = postResponse.data;
        final status = responseData['success'];
        if (status == true) {
            final redirectUrl =  postResponse.data['data']['redirect_url'];
            print('Redirect URL: $redirectUrl');
            if (redirectUrl != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SharePaymentWebViewScreen(paymentUrl: redirectUrl),
                ),
              );
            } else {
              throw 'Redirect URL is null.';
            }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(' فشل في إنشاء الطلب: ${postResponse.statusMessage}'),
            ),
          );
        }
    } catch (e) {
      print('Error: $e');
    }
  }
}
