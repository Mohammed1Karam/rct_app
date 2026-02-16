import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';

class SupportScreen extends StatefulWidget {
  SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var local;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    local = S.of(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: BackButtonAppBar(context),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      local.support_and_assist,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      local.contact_times,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "من فضلك ادخل الاسم";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5),
                        labelText: local.name + ":",
                        labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "من فضلك ادخل البريد الالكتروني";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5),
                        labelText: local.email + ":",
                        labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'رقم الهاتف مطلوب';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5),
                        labelText: local.phone + ":",
                        labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'العنوان مطلوب';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5),
                        labelText: local.message_title,
                        labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: messageController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك ادخل الرسالة';
                        }
                        return null;
                      },
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5),
                        labelText: local.message,
                        labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          var headers = {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json',
                          };
                          var data = json.encode({
                            "name": nameController.text,
                            "email": emailController.text,
                            "phone": phoneController.text,
                            "subject": titleController.text,
                            "message": messageController.text
                          });
                          var dio = Dio();
                          var response = await dio.request(
                            'https://rctapp.com/api/contact/send',
                            options: Options(
                              method: 'POST',
                              headers: headers,
                            ),
                            data: data,
                          );
                          if (response.statusCode == 200) {
                            setState(() {
                              isLoading = false;
                            });
                            nameController.text = '';
                            emailController.text = '';
                            phoneController.text = '';
                            titleController.text = '';
                            messageController.text = '';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم ارسال الرسالة بنجاح')),
                            );
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('حدث خطأ أثناء ارسال الرسالة')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff20262F),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        local.send,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
