import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/auth/register_screen.dart';
import 'package:rct/view/auth/login.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/view/home_screen.dart';

class SendOtp extends StatefulWidget {
  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  Dio _dio = Dio();
  bool flag = false;
  TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Function to handle OTP request
  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.post(
        '$linkServerName/api/resend-otp',
        data: {'phone': _phoneController.text},
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data['message']),
            backgroundColor: Colors.green,
          ),
        );
        print(response);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogiScreen(
              phoneNumber: _phoneController.text,
            ),
          ),
        );
      } else {
        showSnackBar(context, response.data['message'], redColor);
      }
    } on DioException catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('خطأ: ${e.message}', maxLines: 2),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('هناك خطأ يرجي المحاولة لاحقاً ${e.toString()}'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0, scrolledUnderElevation: 0.0,
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
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 50),
              Text(
                local.login,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                local.loginusingyourmobilenumber,
                style: TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLength: 9,
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: local.phone,
                  labelStyle:
                      TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  suffixText: CacheHelper.getData(key: "lang")=="ar"?'966+':'+966',
                  suffixStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  // Replace Arabic numbers with English numbers
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
                  _phoneController.text = convertedValue;
                  _phoneController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _phoneController.text.length),
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return local.pleaseenterthephonenumber;
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : MainButton(
                      backGroundColor: primaryColor,
                      textColor: Colors.white,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await _sendOtp();
                        }
                      },
                      text: local.login,
                    ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 50),
                child: Text.rich(
                  TextSpan(
                    text: local.doNotHaveAccount ?? 'لا تملك حساب؟',
                    children: <InlineSpan>[
                      TextSpan(
                        text: local.createAccount ?? 'أنشئ حساب',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                        recognizer: _tapGestureRecognizer
                          ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
