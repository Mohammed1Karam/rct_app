import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_checkbox.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';

import 'package:rct/constants/constants.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/functions/image_picker.dart';
import 'package:rct/view-model/functions/snackbar.dart';

import 'package:rct/view/RealEstate/custom_textfield1.dart';
import 'package:rct/view/share_rct/paymenthandel.dart';
import 'package:rct/view/terms_conditions_screen.dart';

import '../../common copounents/sharewepview.dart';

// ignore: must_be_immutable
class PostUserDetails extends StatefulWidget {
  dynamic id;
  dynamic totalPrice;
  String city;
  String district;
  int countofchances;

  PostUserDetails(
      {super.key,
      required this.id,
      required this.totalPrice,
      required this.city,
      required this.district,
      required this.countofchances});

  @override
  State<PostUserDetails> createState() => _PostUserDetailsState();
}

class _PostUserDetailsState extends State<PostUserDetails> {
  bool _isChecked = false;
  TextEditingController userNameController = TextEditingController();
  bool isNationalIdSelected = false;
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();

  bool isCommercialRecordSelected = false;
  TextEditingController nationalIdControlller = TextEditingController();
  TextEditingController birthController = TextEditingController();
  // dynamic product;
  dynamic image;
  bool isLocked = false;
  bool isLoading = false;
  void _showImage(File image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.file(
          image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      appBar: BackButtonAppBar(context),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isNationalIdSelected = true;
                      isCommercialRecordSelected = false;
                    });
                  },
                  child: Text(
                    local.nationalID,
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.grey,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isNationalIdSelected = false;
                      isCommercialRecordSelected = true;
                    });
                  },
                  child: Text(
                    "| ${local.commercialRegister}",
                    style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: constVerticalPadding,
            ),
            // Show text fields if "الهوية الوطنية" is selected
            if (isNationalIdSelected) ...[
              Text(local.nationalID, style: TextStyle(fontSize: 12)),
              SizedBox(height: constVerticalPadding),
              // Text field for "رقم الهوية"
              TextFormFieldCustom(
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

                  nationalIdControlller.text = convertedValue;
                  nationalIdControlller.selection = TextSelection.fromPosition(
                    TextPosition(offset: nationalIdControlller.text.length),
                  );
                },
                numberofdigits: 10,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9٠-٩]')), // Arabic & English digits
                ],
                context: context,
                labelText: "", // Optional field
                controller: nationalIdControlller,
              ),
              SizedBox(height: 10),
              // Date picker for "تاريخ الميلاد"
              Text(
                local.birthDate,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: constVerticalPadding),
              GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: primaryColor, // Customize primary color

                          colorScheme: ColorScheme.light(primary: primaryColor),
                          buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                          // Customizing text styles
                          textTheme: TextTheme(
                            bodySmall: TextStyle(fontSize: 10.0),
                            headlineMedium: TextStyle(
                                fontSize:
                                    10.0), // Change font size for the date
                            // You can customize other text styles here
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (selectedDate != null) {
                    final formattedDate = "${selectedDate.toLocal()}"
                        .split(' ')[0]; // Format to "YYYY-MM-DD"
                    birthController.text =
                        formattedDate; // Update the controller text
                  }
                },
                child: AbsorbPointer(
                  // Prevent keyboard from showing
                  child: TextFormFieldCustom(
                    inputType: TextInputType.datetime,
                    context: context,
                    labelText: "", // Optional field
                    controller: birthController,
                    onChanged: (value) {
                      // Handle changes if needed
                    },
                  ),
                ),
              ),
            ],

            // File upload if "السجل التجاري" is selected
            if (isCommercialRecordSelected)
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        local.commercialRegister,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: constVerticalPadding,
                  ),
                  InkWell(
                    onTap: () => pickImageFromGallery(context).then((value) {
                      if (value != null) {
                        setState(() {
                          image = value;
                        });
                      }
                    }),
                    child: isLocked
                        ? Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  // Show the image in a dialog when clicked
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.file(
                                              image!,
                                              fit: BoxFit.cover,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Close'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Image.file(
                                  image!,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  // Unlock the image and show the text field again
                                  setState(() {
                                    isLocked = false;
                                    image = null;
                                  });
                                },
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: () =>
                                pickImageFromGallery(context).then((value) {
                              if (value != null) {
                                setState(() {
                                  image = value;

                                  isLocked =
                                      true; // Lock the image when selected
                                });
                              }
                            }),
                            child: CacheHelper.getData(key: "lang") == "ar"
                                ? Image.asset("$imagePath/upload-photo.png")
                                : Image.asset("assets/images/upload.jpg"),
                          ),
                  ),
                ],
              ),
            SizedBox(height: constVerticalPadding),
            Custom_textField(
              hintText: "",
              textt: local.name,
              controller: userNameController,
              validator: (value) {
                return null;
              },
              onChanged: (value) {},
            ),
            SizedBox(height: constVerticalPadding),
            Text(local.phone, style: TextStyle(fontSize: 12)),
            SizedBox(height: constVerticalPadding),
            TextFormFieldCustom(
              numberofdigits: 9,
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
                phonecontroller.text = convertedValue;
                phonecontroller.selection = TextSelection.fromPosition(
                  TextPosition(offset: phonecontroller.text.length),
                );
              },

              context: context,
              labelText: "", // Optional field
              controller: phonecontroller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9٠-٩]')), // Arabic & English digits
              ],
            ),

            Text("IBAN", style: TextStyle(fontSize: 12)),
            SizedBox(height: constVerticalPadding),
            TextFormFieldCustom(
              numberofdigits: 22,
              prefix: "SA",
              onChanged: (value) {
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
                cardNumberController.text = convertedValue;
                cardNumberController.selection = TextSelection.fromPosition(
                  TextPosition(offset: cardNumberController.text.length),
                );
              },
              context: context,
              controller: cardNumberController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9٠-٩]')), // Arabic & English digits
              ],
              labelText: '',
            ),
            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomCheckbox(
                    isChecked: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                ),
                Text(
                  local.agreeToTermsAndConditions,
                  style: TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TermsAndConditionsScreen()));
                  },
                  child: Text(
                    local.termsConditions,
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : MainButton(
                    width: double.infinity,
                    text: local.payment,
                    backGroundColor: primaryColor,
                    textColor: Colors.white,
                    onTap: () async {
                      if (image == null &&
                          birthController.text.isEmpty &&
                          nationalIdControlller.text.isEmpty) {
                        showSnackBar(
                            context,
                            local.uploadNationalIdOrCommercialRegister,
                            redColor);
                        return;
                      }
                      if (image == null && isCommercialRecordSelected) {
                        showSnackBar(
                            context, local.uploadCommercialRegister, redColor);
                        return;
                      }
                      if (birthController.text.isEmpty &&
                          isNationalIdSelected) {
                        showSnackBar(context, local.enterBirthDate, redColor);
                        return;
                      }

                      if (birthController.text.isNotEmpty) {
                        DateTime? birthDate =
                            DateTime.tryParse(birthController.text);

                        if (birthDate == null) {
                          showSnackBar(context,
                              local.theagemustbemorethan18years, redColor);
                          return;
                        }

                        // Calculate age
                        int age = DateTime.now().year - birthDate.year;
                        if (DateTime.now().month < birthDate.month ||
                            (DateTime.now().month == birthDate.month &&
                                DateTime.now().day < birthDate.day)) {
                          age--; // Adjust age if birthday hasn't occurred yet this year
                        }

                        // Check if age is less than 18
                        if (age < 18) {
                          showSnackBar(context,
                              local.theagemustbemorethan18years, redColor);
                          return;
                        }
                      }

                      if (nationalIdControlller.text.isEmpty &&
                          isNationalIdSelected) {
                        showSnackBar(context, local.enterNationalId, redColor);
                        return;
                      }

                      if (nationalIdControlller.text.length < 10 &&
                          isNationalIdSelected) {
                        showSnackBar(
                            context, local.nationalIdMustBeAtLeast10, redColor);
                        return;
                      }

                      if (phonecontroller.text.isEmpty) {
                        showSnackBar(
                            context, local.pleaseenterthephonenumber, redColor);
                        return;
                      }
                      if (phonecontroller.text.length < 9) {
                        showSnackBar(
                            context,
                            local.phone_number_limit_9,
                            redColor);
                        return;
                      }
                      if (userNameController.text.isEmpty) {
                        showSnackBar(context,
                            local.pleaseenterthenamematchingtheID, redColor);
                        return;
                      }
                      if (cardNumberController.text.isEmpty ||
                          cardNumberController.text.length < 22) {
                        showSnackBar(
                            context, S.of(context).iban, redColor);
                        return;
                      }
                      if (!_isChecked) {
                        showSnackBar(context,
                            local.agreetothetermsandconditions, redColor);
                        return;
                      } else {
                        // Proceed with payment and post user details
                        print("${widget.id}+ ${widget.countofchances}");
                        setState(() {
                          isLoading = true;
                        });
                        print("total ${widget.totalPrice}");

                        try {
                          final token =
                              await AppPreferences.getData(key: "loginToken");
                          final String lang = CacheHelper.getData(key: "lang") ?? "ar";
                          var headers = {
                            'Content-Type': 'application/json',
                            'Accept': 'application/json',
                            'Accept-Language': lang,
                            'Authorization': 'Bearer $token'
                          };
                          var data = json.encode({
                            "type": "opportunity",
                            "id": widget.id,
                            "count": widget.countofchances.toString(),
                            "phone": phonecontroller.text,
                            "city": widget.city,
                            "district": widget.district
                          });
                          var dio = Dio();
                          try{
                            var response = await dio.post(
                              'https://rctapp.com/api/payments/initiate',
                              options: Options(
                                headers: headers,
                              ),
                              data: data,
                            );
                            if (response.statusCode == 200) {
                              print(json.encode(response.data));
                            } else {
                              print(response.statusMessage);
                            }

                            print('Payment Response: ${response.data}');

                            if (response.statusCode == 200) {
                              final redirectUrl =
                              response.data['data']['redirect_url'];
                              print('Redirect URL: $redirectUrl');
                              if (redirectUrl != null) {
                                // Instead of launching the URL externally, push a WebView screen:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SharePaymentWebViewScreen(
                                            paymentUrl: redirectUrl),
                                  ),
                                );
                              } else {
                                throw 'Redirect URL is null.';
                              }
                            }

                          } on DioException catch(e){
                            if(e.response!=null){
                              print(e.response);
                              print(e.response!.statusCode);
                              throw e.response.toString();
                            }
                          }catch(e) {
                            throw e;
                          }

                        } catch (e) {
                          if (e.toString().contains("count")) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(local.opportunity_not_available)),
                            );
                          }
                        }
                        /*PaymentHandler.createOrderAndPay(
                          context:  context,
                          quantity: widget.countofchances,
                          cost:widget.totalPrice,
                          id: widget.id,
                          city:  widget.city,
                         district:  widget.district,
                          phone: phonecontroller.text,
                        ).then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          */ /*PaymentHandler.postUserDetails(
                            userNameController.text,
                            phonecontroller.text,
                            nationalIdControlller.text,
                            birthController.text,
                            image,
                            widget.id,
                            context,
                          );*/ /*
                        });*/

                        PaymentHandler.postUserDetails(
                          userName: userNameController.text,
                          phone: phonecontroller.text,
                          cardNumber: nationalIdControlller.text,
                          cardDate: birthController.text,
                          imagePath: image,
                          opportunity_id: widget.id,
                          context: context,
                          visaNumber: cardNumberController.text,
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),

            SizedBox(
              height: 20,
            ),
            MainButton(
              width: double.infinity,
              text: local.cancel,
              backGroundColor: grey,
              textColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 70),
          ]),
        ),
      ),
    );
  }

  bool _validateFields() {
    if (userNameController.text.isEmpty ||
        phonecontroller.text.isEmpty ||
        nationalIdControlller.text.isEmpty ||
        birthController.text.isEmpty ||
        image == null ||
        !_isChecked) {
      // Check if the checkbox is not selected
      return false;
    }
    return true;
  }
}
