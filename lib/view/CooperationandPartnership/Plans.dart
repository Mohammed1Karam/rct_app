import 'dart:io';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rct/services/cache_helper.dart';

import 'package:rct/view-model/functions/image_picker.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view/google%20maps/pin_location_screen.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view-model/cubits/cooperationandDevelopment/coopeativestates.dart';
import 'package:rct/model/cooperativeMdel.dart';
import 'package:rct/view-model/cubits/cooperationandDevelopment/cooperative_cubit.dart';

import 'package:rct/view/home_screen.dart';
import 'package:rct/view/RealEstate/custom_textfield1.dart';

import '../../generated/l10n.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController distrectnameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController nationalIdControlller = TextEditingController();
  TextEditingController birthController = TextEditingController();
  String? selectedCity;
  File? nationalIdImage;
  File? electronicimage;
  bool isLoading = false;
  bool isLocationConfirmed = false;
  final ImagePicker _picker = ImagePicker();
  bool loc = false;
  bool isLocked = false;
  bool isLocked2 = false;
  bool isLocked3 = false;
  bool isNationalIdSelected = false;
  bool isCommercialRecordSelected = false;
  File? schema;

  void _showImage(File image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.file(
          image,
          fit: BoxFit.fill,
          width: double.infinity,
          height: 400,
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    CooperativeModel cooperativeModel =
        Provider.of<CooperativeModel>(context, listen: false);
    var local = S.of(context);
    List<String> _cities = [
      local.riyadh,
      local.jeddah,
      local.makkahAlMukarramah,
      local.madinahAlMunawwarah,
      local.dammam,
      local.khobar,
      local.alAhsa,
      local.dhahran,
      local.qassim,
      local.abha,
      local.hail,
      local.tabuk,
      local.alJouf,
      local.gurayat,
      local.khamisMushait,
      local.jazan,
      local.najran,
      local.yanbu,
      local.alHofuf,
      local.qatif,
      local.buraydah,
      local.unayzah,
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocConsumer<CooperativeCubit, Coopeativestates>(
        listener: (context, state) {
          if (state is PlansLoadingStates) {
            setState(() {
              isLoading = true;
            });
          } else if (state is PlansFailedStates) {
            setState(() {
              isLoading = false;
            });
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showSnackBar(context, state.message, Colors.red);
            });
          } else if (state is PlansSuccessStates) {
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
                      height: 50,
                      width: 50,
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                            local.iDNumber,
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
                            "|  ${local.commercialRegister}",
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
                      Text(local.iDNumber, style: TextStyle(fontSize: 12)),
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
                          cooperativeModel.nationalIdNumber = value.toString();
                          nationalIdControlller.text = convertedValue;
                          nationalIdControlller.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: nationalIdControlller.text.length),
                          );
                        },
                        numberofdigits: 10,

                        context: context,
                        labelText: "", // Optional field
                        controller: nationalIdControlller,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9٠-٩]')), // Arabic & English digits
                        ],
                      ),
                      SizedBox(height: constVerticalPadding),
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
                            firstDate: DateTime(1900), // Set minimum date
                            lastDate: DateTime.now(), // Set maximum date
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
                            labelText: "", // Optional field
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
                                  cooperativeModel.identity = value;
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                          cooperativeModel.identity = value;
                                          isLocked =
                                              true; // Lock the image when selected
                                        });
                                      }
                                    }),
                                    child: CacheHelper.getData(key: "lang") ==
                                            "ar"
                                        ? Image.asset(
                                            "$imagePath/upload-photo.png")
                                        : CacheHelper.getData(key: "lang") ==
                                                "en"
                                            ? Image.asset(
                                                "assets/images/upload.jpg")
                                            : Image.asset(
                                                "$imagePath/upload-photo.png"),
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
                            electronicimage = value;
                            cooperativeModel.electronic_instrument = value;
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
                                                electronicimage!,
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
                                    electronicimage!,
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
                                      electronicimage = null;
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
                                    electronicimage = value;
                                    cooperativeModel.electronic_instrument =
                                        value;
                                    isLocked2 =
                                        true; // Lock the image when selected
                                  });
                                }
                              }),
                              child: CacheHelper.getData(key: "lang") == "ar"
                                  ? Image.asset("$imagePath/upload-photo.png")
                                  : CacheHelper.getData(key: "lang") == "en"
                                      ? Image.asset("assets/images/upload.jpg")
                                      : Image.asset(
                                          "$imagePath/upload-photo.png"),
                            ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "إرفاق التصميم أو المخطط",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () => pickImageFromGallery(context).then((value) {
                        if (value != null) {
                          setState(() {
                            schema = value;
                            cooperativeModel.schema = value;
                          });
                        }
                      }),
                      child: isLocked3
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
                                                schema!,
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
                                    schema!,
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
                                      schema = null;
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
                                    schema = value;
                                    cooperativeModel.schema = value;
                                    isLocked3 =
                                        true; // Lock the image when selected
                                  });
                                }
                              }),
                              child: CacheHelper.getData(key: "lang") == "ar"
                                  ? Image.asset("$imagePath/upload-photo.png")
                                  : CacheHelper.getData(key: "lang") == "en"
                                      ? Image.asset("assets/images/upload.jpg")
                                      : Image.asset(
                                          "$imagePath/upload-photo.png"),
                            ),
                    ),
                    SizedBox(height: constVerticalPadding),
                    SizedBox(height: 15),
                    Text(local.price, style: TextStyle(fontSize: 12)),
                    SizedBox(height: constVerticalPadding),

                    TextFormFieldCustom(
                      onChanged: (value) {
                        // Convert Arabic numbers to English numbers
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

                        // Update the controller with the converted value
                        priceController.text = convertedValue;

                        // Maintain the cursor position
                        priceController.selection = TextSelection.fromPosition(
                          TextPosition(offset: convertedValue.length),
                        );

                        // Use the converted value for further logic
                        cooperativeModel.price = convertedValue;
                      },
                      controller: priceController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9٠-٩]')), // Arabic & English digits
                      ],
                      context: context,
                      labelText: '',
                    ),

                    SizedBox(height: constVerticalPadding),
                    SizedBox(height: 15),
                    Text(
                      local.city,
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      value: selectedCity,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        fillColor: grey.withOpacity(0.5),
                        filled: true,
                        labelStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: darkGrey,
                                  overflow: TextOverflow.clip,
                                ),
                        hintText: "",
                      ),
                      items: _cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(
                            city,
                            style: TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCity = newValue;
                        });
                      },
                    ),
                    Custom_textField(
                      hintText: local.enterDistrict,
                      textt: local.district,
                      controller: distrectnameController,
                      validator: (value) {
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 15),
                    Text(
                      local.propertyLocation,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: InkWell(
                        child: Image.asset(
                          "$imagePath/Frame 177.png",
                        ),
                        onTap: () async {
                          checkAndRequestLocation(context);
                          // await LocationPermissionHandler()
                          //     .requestLocationPermission()
                          //     .then((value) => LocationPermissionHandler()
                          //         .getCurrentLocation());
                          await Geolocator.requestPermission().then(
                              (value) async =>
                                  await Geolocator.getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high));
                          loc = true;
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      PinLocationScreen(
                                onPlacePicked: (p0) {
                                  // Ensure valid location data is being returned
                                  if (p0.geometry != null) {
                                    cooperativeModel.lat =
                                        p0.geometry!.location.lat.toString();
                                    cooperativeModel.long =
                                        p0.geometry!.location.lng.toString();
                                    cooperativeModel.location = p0.name ?? '';
                                    setState(() {
                                      locationcontroller.text =
                                          cooperativeModel.location ?? '';
                                    });

                                    // Confirm that data is passed back correctly
                                    if (kDebugMode) {
                                      print(
                                          "Location selected: ${cooperativeModel.location}");
                                      print(
                                          "Latitude: ${cooperativeModel.lat}");
                                      print(
                                          "Longitude: ${cooperativeModel.long}");
                                    }
                                  } else {
                                    print(
                                        "Error: Location or geometry is null");
                                  }

                                  // Close the map screen
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: constVerticalPadding),
                    TextFormFieldCustom(
                      context: context,
                      labelText: local.enterSiteLink,
                      onChanged: (value) {},
                      controller: locationcontroller,
                      // number: true,
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
                          cooperativeModel.birthDate = birthController.text;
                          if (locationcontroller.text.isNotEmpty) {
                            loc = true;
                          }

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
                            showSnackBar(context,
                                local.uploadCommercialRegister, redColor);
                            return;
                          }

                          if (nationalIdControlller.text.length < 10 &&
                              isNationalIdSelected) {
                            showSnackBar(context,
                                local.nationalIdMustBeAtLeast10, redColor);
                            return;
                          }
                          if (birthController.text.isEmpty &&
                              isNationalIdSelected) {
                            showSnackBar(
                                context, local.enterBirthDate, redColor);
                            return;
                          }
                          if (nationalIdControlller.text.isEmpty &&
                              isNationalIdSelected) {
                            showSnackBar(
                                context, local.enterNationalId, redColor);
                            return;
                          }
                          if (electronicimage == null) {
                            showSnackBar(context,
                                local.pleaseuploadtheelectronicdeed, redColor);
                            return;
                          }
                          if (priceController.text.isEmpty) {
                            showSnackBar(
                                context, local.pleaseentertheprice, redColor);
                            return;
                          }
                          if (selectedCity == null || selectedCity!.isEmpty) {
                            showSnackBar(
                                context, local.pleaseselectacity, redColor);
                            return;
                          }
                          if (distrectnameController.text.isEmpty) {
                            showSnackBar(context,
                                local.pleaseentertheneighborhoodname, redColor);
                            return;
                          }
                          if (loc == false && locationcontroller.text.isEmpty) {
                            showSnackBar(
                                context,
                                local
                                    .pleaseselectthelocationviathemaporenterthelink,
                                redColor);
                            return;
                          }
                          if (!isLocationConfirmed) {
                            showSnackBar(
                                context, local.confirmLocation, redColor);
                            return;
                          }
                          if (cooperativeModel.location != null)
                            cooperativeModel.price = priceController.text;
                          cooperativeModel.district_name =
                              distrectnameController.text;
                          cooperativeModel.city_name = selectedCity;
                          cooperativeModel.identity = nationalIdImage;
                          cooperativeModel.electronic_instrument =
                              electronicimage;
                          cooperativeModel.schema = schema;
                          cooperativeModel.location = locationcontroller.text;
                          cooperativeModel.nationalIdNumber =
                              nationalIdControlller.text;
                          cooperativeModel.birthDate = birthController.text;
                          await context
                              .read<CooperativeCubit>()
                              .PlansFunction(context);
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
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
                                            (route) => false,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromRGBO(
                                              52, 168, 83, 1),
                                          elevation: 5,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
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
                                            borderRadius:
                                                BorderRadius.circular(7),
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
                          }),
                    ),
                    SizedBox(height: 70),
                  ],
                ),
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
