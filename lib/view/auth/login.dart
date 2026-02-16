import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/main.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/notification/notifications_screen.dart';
import 'package:rct/view/home_screen.dart';

import '../../generated/l10n.dart';

class LogiScreen extends StatefulWidget {
  final String phoneNumber;

  LogiScreen({required this.phoneNumber});

  @override
  _LogiScreenState createState() => _LogiScreenState();
}

class _LogiScreenState extends State<LogiScreen> {
  String? fcmToken;

  void initState() {
    // context.read<FinalOrdersCubit>().Users();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        // context.read<FinalOrdersCubit>().Users();
        AppPreferences.getData(key: 'myname') ?? 'Default Name';

        AppPreferences.getData(key: 'myimage') ?? "";

        int notificationId = Random().nextInt(1000000) + 10;
        debugPrint('$notificationId');
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: notificationId,
              channelKey: 'local notification key',
              displayOnBackground: true,
              displayOnForeground: true,
              title: message.notification!.title,
              body: message.notification!.body),
        );
      });
    });
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AwesomeNotifications().setListeners(onActionReceivedMethod: (receivedAction) {
        ////here                  Routes.teacherNavbarPageRoute
        return Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
      });
      // Ensure a Future<void> is returned
    });
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.getToken().then((token) {
      fcmToken = token;
      print("****************************************");
      print("fcmToken is $fcmToken");

      print("****************************************");
    });
    super.initState();
  }

  static String? token;
  static String? name;
  static dynamic image;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  Dio _dio = Dio();

  Future<void> _validateOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.post(
        '$linkServerName/api/validate-otp',
        data: {
          'phone': widget.phoneNumber,
          'otp': _otpController.text,
          'fcm_token': fcmToken,
        },
      );

      if (response.statusCode == 200) {
        // Extract and store relevant data from the response
        final token = response.data['token'];

        // Extract user data from the 'user' object
        final userData = response.data['user'];
        final name = userData['name'];
        final phone = userData['phone'];
        final image = userData['image'];
        final email = userData['email'];
        final pass = userData['password'];

        // Save token and user data to secure storage
        await secureStorage.write(key: 'token', value: token);
        await secureStorage.write(key: 'name', value: name);

        await secureStorage.write(key: 'image', value: image);

        // Save data to AppPreferences
        AppPreferences.saveData(key: 'loginToken', value: token);
        AppPreferences.saveData(key: 'username', value: name);
        AppPreferences.saveData(key: 'phone', value: phone);
        AppPreferences.saveData(key: 'image', value: image);

        print("ttttk$token");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${response.data['message']}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${response.data['message']}")),
        );
      }
    } on DioException catch (e) {
      // Handle Dio exceptions (network issues, timeout, etc.)
      if (e.response != null && e.response!.statusCode == 500) {
        // Server-side error (500 status code)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("الرمز المدخل غير صحيح"), backgroundColor: Colors.red),
        );
      } else {
        // Handle other types of DioErrors (connection timeout, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("الرمز المدخل غير صحيح"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${"الرمز المدخل غير صحيح"}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to resend OTP
  Future<void> _resendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.post(
        '$linkServerName/api/resend-otp',
        data: {'phone': widget.phoneNumber},
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إعادة إرسال رمز التفعيل بنجاح'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل  إعادة إرسال رمز التفعيل . حاول مرة اخرى : ${response.statusMessage}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    // LoginModel l = Provider.of<LoginModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                Text(
                  local.confirmPhone,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      local.theverificationcodehasbeensenttthenumberendingwith,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      " ${widget.phoneNumber.substring(widget.phoneNumber.length - 3)}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Directionality(
                  textDirection: TextDirection.ltr, // Set the text direction to Left-to-Right
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    // Set the length of the PIN code
                    controller: _otpController,
                    // Your TextEditingController
                    keyboardType: TextInputType.number,
                    // Only allow number input
                    enableActiveFill: true,
                    // Allows the boxes to be filled
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      // Define the shape of the fields
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.grey,
                      // Set a color for the active state
                      inactiveFillColor: Colors.grey[200]!,
                      // Set a color for the inactive state
                      selectedFillColor: Colors.grey,
                      // Set a color for the selected state
                      activeColor: Colors.grey,
                      // Border color when the field is active
                      inactiveColor: Colors.grey,
                      // Border color when the field is inactive
                      selectedColor: Colors.grey, // Border color when a field is selected
                    ),
                    onChanged: (value) {
                      // Handle changes in the pin code input
                      String convertedValue = value
                          .replaceAll('٠', '0')
                          .replaceAll('١', '1')
                          .replaceAll('٢', '2')
                          .replaceAll('٣', '3')
                          .replaceAll('٤', '4')
                          .replaceAll('٥', '5')
                          .replaceAll('٦', '6')
                          .replaceAll('٧', '7')
                          .replaceAll('٨', '8')
                          .replaceAll('٩', '9');

                      // Update the text field controller with the converted value if necessary
                      _otpController.text = convertedValue;
                      _otpController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _otpController.text.length),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return local.pleaseentertheactivationcode; // Arabic error message
                      }
                      return null;
                    },

                    beforeTextPaste: (text) {
                      return true; // Allow text pasting
                    },
                  ),
                ),
                SizedBox(height: 40),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : MainButton(
                        backGroundColor: primaryColor,
                        textColor: Colors.white,
                        onTap: _validateOtp,
                        text: local.login,
                      ),
                SizedBox(height: 20),
                Text(
                  local.didntreceivetheverificationcode,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/Vector.png",
                      height: 20,
                      width: 20,
                    ),
                    TextButton(
                      onPressed: _resendOtp,
                      child: Text(
                        local.resendverificationcode,
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
