import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/cubits/order/order_cubit.dart';
import 'package:rct/view-model/functions/image_picker.dart';
import 'package:rct/view-model/functions/location_permission.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/google%20maps/pin_location_screen.dart';
import 'package:rct/view/home_screen.dart';
import 'package:rct/l10n/app_localizations.dart';

import '../../generated/l10n.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  bool isLocked3 = false;
  dynamic nationalIdImage;
  TextEditingController birthController = TextEditingController();
  TextEditingController nationalIdControlller = TextEditingController();
  bool isLocked = false;
  bool isLocked2 = false;
  bool isNationalIdSelected = false;
  bool isCommercialRecordSelected = false;
  dynamic electronicImage;
  dynamic landCheckImage; // Optional
  bool isLocationConfirmed = false;

  void showImage(BuildContext context, File image) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.file(image),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    var local = S.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderLoading) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is OrderFailure) {
            setState(() {
              isLoading = false;
            });
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showSnackBar(context, local.errorPleaseTryAgain, Colors.red);
            });
          } else if (state is OrderSuccess) {
            setState(() {
              isLoading = false;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowPopUp(
                  title: Center(
                    child: Image.asset(
                      "assets/icons/popUp-icon.png",
                      height: 50.h,
                      width: 50.w,
                    ),
                  ),
                  content: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      local.requestSentSuccessfully,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(local.requestWillBeReviewed,
                        textAlign: TextAlign.center),
                  ),
                  ontap: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  ),
                );
              },
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                  if (isNationalIdSelected) ...[
                    Text(local.iDNumber, style: TextStyle(fontSize: 12)),
                    SizedBox(height: constVerticalPadding),
                    // Text field for "رقم الهوية"

                    // Inside your widget
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

                        orderModel.nationalIdNumber = convertedValue;
                        nationalIdControlller.text = convertedValue;
                        nationalIdControlller.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: nationalIdControlller.text.length),
                        );
                      },
                      numberofdigits: 10,
                      context: context,
                      labelText: "",
                      // Optional field
                      controller: nationalIdControlller,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9٠-٩]')), // Arabic & English digits
                      ],
                    ),

                    SizedBox(height: 2),

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
                          // Set minimum date
                          lastDate: DateTime.now(),
                          // Set maximum date
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor:
                                    primaryColor, // Customize primary color

                                colorScheme:
                                    ColorScheme.light(primary: primaryColor),
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
                          labelText: "",
                          // Optional field
                          controller: birthController,
                          onChanged: (value) {
                            // Handle changes if needed
                          },
                        ),
                      ),
                    ),
                  ],
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
                          onTap: () =>
                              pickImageFromGallery(context).then((value) {
                            if (value != null) {
                              setState(() {
                                nationalIdImage = value;
                                orderModel.nationalidimage = value;
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
                                                    nationalIdImage!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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
                                        nationalIdImage!,
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
                                          nationalIdImage = null;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: () => pickImageFromGallery(context)
                                      .then((value) {
                                    if (value != null) {
                                      setState(() {
                                        nationalIdImage = value;
                                        orderModel.nationalidimage = value;
                                        isLocked =
                                            true; // Lock the image when selected
                                      });
                                    }
                                  }),
                                  child: CacheHelper.getData(key: "lang") ==
                                          "ar"
                                      ? Image.asset(
                                          "$imagePath/upload-photo.png")
                                      : Image.asset("assets/images/upload.jpg"),
                                ),
                        ),
                      ],
                    ),
                  SizedBox(height: constVerticalPadding),
                  Text(
                    local.electronicDeed,
                    style: TextStyle(fontSize: 12, color: blackColor),
                  ),
                  SizedBox(height: constVerticalPadding),
                  InkWell(
                    onTap: () => pickImageFromGallery(context).then((value) {
                      if (value != null) {
                        setState(() {
                          electronicImage = value;
                          orderModel.electronicimage = value;
                        });
                      }
                    }),
                    child: isLocked2
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
                                              electronicImage!,
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
                                  electronicImage!,
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
                                    isLocked2 = false;
                                    electronicImage = null;
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
                                  electronicImage = value;
                                  orderModel.electronicimage = value;
                                  isLocked2 =
                                      true; // Lock the image when selected
                                });
                              }
                            }),
                            child: CacheHelper.getData(key: "lang") == "ar"
                                ? Image.asset("$imagePath/upload-photo.png")
                                : Image.asset("assets/images/upload.jpg"),
                          ),
                  ),
                  orderModel.islandChecked == 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: constVerticalPadding,
                            ),
                            Text(
                              local.addSoilTestReport,
                              style: TextStyle(fontSize: 12, color: blackColor),
                            ),
                            SizedBox(height: constVerticalPadding),
                            isLocked3
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.file(
                                                      landCheckImage!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                          landCheckImage!,
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
                                            isLocked3 = false;
                                            landCheckImage = null;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : InkWell(
                                    onTap: () => pickImageFromGallery(context)
                                        .then((value) {
                                      if (value != null) {
                                        setState(() {
                                          landCheckImage = value;
                                          orderModel.landCheckImage = value;
                                          isLocked3 =
                                              true; // Lock the image when selected
                                        });
                                      }
                                    }),
                                    child:
                                        CacheHelper.getData(key: "lang") == "ar"
                                            ? Image.asset(
                                                "$imagePath/upload-photo.png")
                                            : Image.asset(
                                                "assets/images/upload.jpg"),
                                  ),
                          ],
                        )
                      : Container(),
                  SizedBox(height: constVerticalPadding),
                  Text(
                    local.propertyLocation,
                    style: TextStyle(fontSize: 12, color: blackColor),
                  ),
                  SizedBox(height: constVerticalPadding),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        checkAndRequestLocation(context);
                        // await LocationPermissionHandler()
                        //     .requestLocationPermission()
                        //     .then((_) => LocationPermissionHandler().getCurrentLocation());
                        await Geolocator.requestPermission().then(
                            (value) async =>
                                await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.high));
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    PinLocationScreen(
                              onPlacePicked: (p0) {
                                // Ensure valid location data is being returned
                                if (p0.geometry != null) {
                                  orderModel.lat =
                                      p0.geometry!.location.lat.toString();
                                  orderModel.long =
                                      p0.geometry!.location.lng.toString();
                                  orderModel.location = p0.name ?? '';
                                  setState(() {
                                    controller.text = orderModel.location ?? '';
                                  });

                                  // Confirm that data is passed back correctly
                                  if (kDebugMode) {
                                    print(
                                        "Location selected: ${orderModel.location}");
                                    print("Latitude: ${orderModel.lat}");
                                    print("Longitude: ${orderModel.long}");
                                  }
                                } else {
                                  print("Error: Location or geometry is null");
                                }

                                // Close the map screen
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        "$imagePath/Frame 177.png",
                      ),
                    ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  TextFormFieldCustom(
                    context: context,
                    labelText: local.enterSiteLink, // Optional field
                    controller: controller,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: constVerticalPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        activeColor: primaryColor,
                        value: isLocationConfirmed,
                        onChanged: (value) {
                          setState(() {
                            isLocationConfirmed = value ?? false;
                          });
                        },
                      ),
                      Text(
                        local.confirmlocation,
                        style: TextStyle(fontSize: 12, color: blackColor),
                      ),
                    ],
                  ),
                  SizedBox(height: constVerticalPadding),
                  Center(
                    child: MainButton(
                      text: local.send,
                      backGroundColor: primaryColor,
                      onTap: () async {
                        // Validation for required fields
                        orderModel.buildtype_id =
                            AppPreferences.getData(key: "type");

                        if (nationalIdImage == null &&
                            birthController.text.isEmpty &&
                            nationalIdControlller.text.isEmpty) {
                          showSnackBar(
                              context,
                              local.uploadNationalIdOrCommercialRegister,
                              redColor);
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

                        if (nationalIdImage == null &&
                            isCommercialRecordSelected) {
                          showSnackBar(context, local.uploadCommercialRegister,
                              redColor);
                          return;
                        }

                        if (nationalIdControlller.text.length < 10 &&
                            isNationalIdSelected) {
                          showSnackBar(context, local.nationalIdMustBeAtLeast10,
                              redColor);
                          return;
                        }
                        if (birthController.text.isEmpty &&
                            isNationalIdSelected) {
                          showSnackBar(context, local.enterBirthDate, redColor);
                          return;
                        }
                        if (nationalIdControlller.text.isEmpty &&
                            isNationalIdSelected) {
                          showSnackBar(
                              context, local.enterNationalId, redColor);
                          return;
                        }
                        if (electronicImage == null) {
                          showSnackBar(context,
                              local.pleaseuploadtheelectronicdeed, redColor);
                          return;
                        }

                        if (nationalIdControlller.text.isEmpty &&
                            isNationalIdSelected) {
                          showSnackBar(
                              context, local.enterNationalId, redColor);
                          return;
                        }
                        if (nationalIdControlller.text.length < 10 &&
                            isNationalIdSelected) {
                          showSnackBar(context, local.nationalIdMustBeAtLeast10,
                              redColor);
                          return;
                        }

                        if (!isLocationConfirmed) {
                          showSnackBar(
                              context, local.confirmLocation, redColor);
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        if (isCommercialRecordSelected) {
                          orderModel.nationalIdNumber = "";
                          orderModel.birthDate = "";
                        } else {
                          orderModel.nationalidimage = null;
                        }

                        await context.read<OrderCubit>().pushOrder(context);
                      },
                    ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  Center(
                      child: MainButton(
                    text: local.cancelRequest,
                    backGroundColor: grey,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              local.areyousureyouwanttocanceltheorder,
                              style: TextStyle(fontSize: 12),
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    // Navigate to HomeScreen and remove all previous routes
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()),
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromRGBO(52, 168, 83, 1),
                                    elevation: 5,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Text(
                                    local.yes,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    // Simply close the dialog without any action
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Text(
                                    local.no,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )),
                  SizedBox(height: 70),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> checkAndRequestLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      showSettingsDialog(context); // عرض تنبيه بضرورة تفعيل الإذن
    }
  }

// 🔹 إظهار تنبيه مع خيارين: فتح الإعدادات أو الإلغاء
  void showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // المستخدم يمكنه إغلاقه بدون إجبار
      builder: (_) => AlertDialog(
        title: Text("إذن الموقع مطلوب"),
        content: Text(
            "يرجى تفعيل إذن الموقع من الإعدادات للاستمرار في استخدام هذه الميزة."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق التنبيه
              Geolocator.openAppSettings(); // فتح إعدادات التطبيق
            },
            child: Text("فتح الإعدادات"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), // إغلاق بدون فعل شيء
            child: Text("إلغاء"),
          ),
        ],
      ),
    );
  }
}
