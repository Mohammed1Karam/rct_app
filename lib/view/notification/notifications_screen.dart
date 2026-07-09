import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/wepviewforcalculation.dart';

import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';

import 'package:rct/shared_pref.dart';
import 'package:rct/view/final_orders/final-orders.dart';
import 'package:rct/view/home_screen.dart';

import 'package:rct/view/notification/download.dart';
import 'package:rct/view/notification/notify_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:rct/view/notification/notifycubit.dart';
import 'package:rct/view/notification/states.dart';
import 'package:rct/l10n/app_localizations.dart';

import '../../common copounents/sharewepview.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool hasNavigated = false;
  bool isLoading = false;
  bool flag = false;
  dynamic id;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<NotificationCubit>(context).fetchNotifications();
    });
  }

  Future<void> _handlePayment(BuildContext context, int orderId) async {
    final token = await _getAuthToken();

    try {

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var dio = Dio();
      var response = await dio.request(
        'https://rctapp.com/api/payments/pay/$orderId',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
      }
      else {
        print(response.statusMessage);
      }
      final status = response.data['success'];
      if (status == true) {
        final redirectUrl = response.data['data']['redirect_url'];
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("خطأ: رابط إعادة التوجيه فارغ.")),
          );
          throw Exception('خطأ: رابط إعادة التوجيه فارغ.');
        }
      } else {

        /*  ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(postResponse.statusMessage.toString())),
        );*/
        throw Exception(response.statusMessage);
      }
    } catch (e) {}
  }

  Future<void> PayContract({
    required BuildContext context,
    required int id,
    required String paymentType,
    required int contractId,
    required int installmentId,
  }) async {
    try {
      final token = await _getAuthToken();
      print('TOKEN: $token');
      var data = json.encode({
        "type": "renter",
        "id": id,
        "payment_type": paymentType,
        "contract_id": contractId,
        "installment_id": installmentId
      });
      print('Request Body: $data');
      final postResponse = await Dio().post(
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
        final redirectUrl = postResponse.data['data']['redirect_url'];
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("خطأ: رابط إعادة التوجيه فارغ.")),
          );
          throw Exception('خطأ: رابط إعادة التوجيه فارغ.');
        }
      } else {

      /*  ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(postResponse.statusMessage.toString())),
        );*/
        throw Exception(postResponse.statusMessage);
      }
    } catch (e) {
      if(e.toString().contains('429')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("يوجد عملية دفع قيد المعالجة بالفعل")),
        );
      }
      throw Exception('خطأ في معالجة الدفع ');
    }
  }

  Future<void> _setButtonPressed(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_$id', false);
  }

  Future<bool> _checkIfButtonPressed(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notification_$id') ?? true;
  }

  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Image.asset(
          "assets/images/photo_2024-09-16_00-14-11.jpg",
          fit: BoxFit.contain,
          width: 100,
          height: 100,
        ),
        // backgroundColor: primaryColor,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {}
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return Center();
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(child: Text(''));
            } else {
              // final notification = state.notifications[index];
              // final data = notification.notification.data;
              // id = notification.id.toString();
              // String file = notification.file.toString();
              // String type = notification.file.toString();
              //   String data_id = data.file;
              // AppPreferences.saveData(key: "notifyLength", value: state.notifications.length);
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                child: ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                      child: IntrinsicHeight(
                        child: Container(
                          child: Card(
                            elevation: 0,
                            color: Color.fromRGBO(151, 163, 169, 0.2),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 15, left: 15, top: 10, bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    style: TextStyle(fontSize: 12),
                                    AppPreferences.getData(key: "lang") == "ar"
                                        ? "${state.notifications[index].titleAr}"
                                        : "${state.notifications[index].titleEn}",
                                    maxLines: 3,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    style: TextStyle(fontSize: 14),
                                    AppPreferences.getData(key: "lang") == "ar"
                                        ? "${state.notifications[index].messageAr}"
                                        : "${state.notifications[index].messageEn}",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  state.notifications[index].type ==
                                          NotificationTypes
                                              .opportunityReturnStatus
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                style: TextStyle(fontSize: 14),
                                                "${local.orderNumber}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                style: TextStyle(fontSize: 14),
                                                ": ${state.notifications[index].data.opportunityId}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        )
                                      : (state.notifications[index].type ==
                                                  NotificationTypes
                                                      .partialPayment ||
                                              state.notifications[index].type ==
                                                  NotificationTypes
                                                      .rentalPaymentReminder)
                                          ? Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (state.notifications[index]
                                                          .type == NotificationTypes.partialPayment) {
                                                    _handlePayment(
                                                        context, state.notifications[index].data.actionData['order_id']
                                                    );
                                                  } else {
                                                    PayContract(
                                                      context: context,
                                                      id: state.notifications[index].data.actionData['renter_id'],
                                                      paymentType: "monthly_installment",
                                                      contractId: state.notifications[index].data.actionData['contract_id'],
                                                      installmentId: state.notifications[index].data.actionData['installment_id'],
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: primaryColor,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 6),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                ),
                                                child: Text(
                                                  local.payment,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          : state.notifications[index].type ==
                                                  NotificationTypes
                                                      .rentalPaymentReminder
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 1, top: 10),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      print(
                                                          "data_id ${state.notifications[index].id}  type: ${state.notifications[index].type} ");
                                                      print(state
                                                          .notifications[index]
                                                          .isRead);
                                                      setState(() {
                                                        flag = true;
                                                      });
                                                      await _setButtonPressed(
                                                          state
                                                              .notifications[
                                                                  index]
                                                              .id
                                                              .toString());
                                                      /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    DownloadScreen(
                                              type: state
                                                  .notifications[
                                                      index]
                                                  .type,
                                              data_id: (state
                                                  .notifications[
                                                      index]
                                                  .data
                                                  .userId),
                                              file: state
                                                      .notifications[
                                                          index].data.installmentNumber??
                                                  "",
                                              NotificationId: state
                                                  .notifications[
                                                      index]
                                                  .id,
                                            ),
                                          ),
                                        );*/
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          primaryColor,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 40,
                                                              vertical: 6),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      local.payment,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ))
                                              : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            return Center();
          }
        },
      ),
    );
  }
}
