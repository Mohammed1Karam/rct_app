import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/common%20copounents/sharewepview.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/services/cache_helper.dart';

import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rct/shared_pref.dart';

class PaymentHandler {
  static final Dio _dio = Dio();
  static final Crud _crud = Crud();

  /// Fetches the authentication token from shared preferences.
  static Future<String?> _getAuthToken() async {
    return await AppPreferences.getData(key: 'loginToken');
  }

  static Future<void> createOrderAndPay({
    required BuildContext context, // Added context parameter
    required int quantity,
    required dynamic cost,
    required dynamic id,
    required String city,
    required String district,
    required String phone,
  }
  ) async {
    final local = S.of(context);
    try {
      final token = await _getAuthToken();
      final String lang = CacheHelper.getData(key: "lang") ?? "ar";
      print('id  $id');
      var data = json.encode({
        "type": "opportunity",
        "id": id,
        "count": quantity,
        "phone": phone,
        "city": city,
        "district": district
      });

      final payResponse = await _dio.post(
          '$linkServerName/api/payments/initiate',
          data: data,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Accept-Language': lang,
              'Authorization': 'Bearer $token'
            },
          ),
        );

        print('Payment Response: ${payResponse.data}');

        if (payResponse.statusCode == 200) {
          final redirectUrl = payResponse.data['data']['redirect_url'];
          print('Redirect URL: $redirectUrl');
          if (redirectUrl != null) {
            // Instead of launching the URL externally, push a WebView screen:
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
          throw 'Failed to get payment URL: ${payResponse.statusMessage}';
        }
    } catch (e) {
      if(e.toString().contains("count")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(local.opportunity_not_available)),
        );
      }
    }
  }

  static Future<void> postUserDetails({
    required String userName,
    required String phone,
    required String cardNumber,
    required String cardDate,
    required String visaNumber,
    File? imagePath,
    String? opportunity_id,
    required BuildContext context,
  }) async {
    Map<String, File?> images = {
      'image': imagePath,
    };

    final String lang = CacheHelper.getData(key: "lang") ?? "ar";

    try {
      var result = await _crud.postRequestWithFiles(
        "$linkServerName/api/oper-user-details",
        {
          'user_name': userName,
          'phone': phone,
          'card_number': cardNumber,
          'card_date': cardDate,
          "opportunity_id": opportunity_id,
          "visa_number": visaNumber,
        },
        images,
        headers: {
          "Content-Type": "application/json",
          "Accept-Language": lang,
        },
      );

      if (result.containsKey("data")) {
        print("Response: $result");
        final local = S.of(context);
        showDialog(
          context: context,
          builder: (context) => ShowPopUp(
            title: Text(local.thanks),
            content: Text(local.data_sent_successfully),
            ontap: () => Navigator.pop(context),
          ),
        );
      } else {
        print("Error: $result");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
