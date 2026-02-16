// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:provider/provider.dart';
// import 'package:rct/common%20copounents/app_bar_back_button.dart';
// import 'package:rct/common%20copounents/custom_textformfield.dart';
// import 'package:rct/common%20copounents/main_button.dart';
// import 'package:rct/common%20copounents/pop_up.dart';
// import 'package:rct/constants/constants.dart';
// import 'package:rct/view-model/cubits/real_estate/post_cubit.dart';
// import 'package:rct/model/realEstatemodel.dart';
// import 'package:rct/view-model/cubits/real_estate/post_states.dart';

// import 'package:rct/l10n/app_localizations.dart';
// import 'package:rct/view-model/functions/image_picker.dart';
// import 'package:rct/view-model/functions/location_permission.dart';
// import 'package:rct/view-model/functions/snackbar.dart';
// import 'package:rct/view/google%20maps/pin_location_screen.dart';
// import 'package:rct/view/home_screen.dart';

// import 'custom_textfield1.dart';

// class AddEstate extends StatefulWidget {
//   const AddEstate({super.key});

//   @override
//   State<AddEstate> createState() => _FormScreenState();
// }

// class _FormScreenState extends State<AddEstate> {
//   String? selectedType;
//   bool isLoading = false;
//   File? identity;
//   // ignore: non_constant_identifier_names
//   File? electronic_insurance;
//   File? image1;
//   File? image2;
//   File? image3;
//   File? image4;
//   String? selectedCity;
//   // TextEditingController houseTypeController = TextEditingController();
//   bool isLocationConfirmed = false;
//   TextEditingController houseNameController = TextEditingController();
//   TextEditingController houseSpaceController = TextEditingController();
//   TextEditingController distrectnameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//   TextEditingController locationController = TextEditingController();
//   void showImage(BuildContext context, File image) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           child: Image.file(image),
//         );
//       },
//     );
//   }

//   final List<String> types = ["سكني", "تجاري"];

//   @override
//   Widget build(BuildContext context) {
//     HouseModel houseModel = Provider.of<HouseModel>(context, listen: false);
//     var local = S.of(context);
//     List<String> _cities = [
//       local.riyadh,
//       local.jeddah,
//       local.makkahAlMukarramah,
//       local.madinahAlMunawwarah,
//       local.dammam,
//       local.khobar,
//       local.alAhsa,
//       local.dhahran,
//       local.qassim,
//       local.abha,
//       local.hail,
//       local.tabuk,
//       local.alJouf,
//       local.gurayat,
//       local.khamisMushait,
//       local.jazan,
//       local.najran,
//       local.yanbu,
//       local.alHofuf,
//       local.qatif,
//       local.buraydah,
//       local.unayzah,
//     ];

//     GlobalKey<FormState> formKey = GlobalKey();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: BackButtonAppBar(context),
//       body: BlocConsumer<HouseCubit, HouseStates>(
//         listener: (context, state) {
//           if (state is HouseLoadingg) {
//             setState(() {
//               isLoading = true;
//             });
//           }
//           if (state is HouseFaild) {
//             setState(() {
//               isLoading = false;
//             });
//             SchedulerBinding.instance.addPostFrameCallback((_) {
//               showSnackBar(context, state.errMessage,
//                   const Color.fromARGB(255, 32, 31, 31));
//             });
//           } else if (state is HouseSuccesss) {
//             isLoading = false;

//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return ShowPopUp(
//                     title: Center(
//                       child: Image.asset(
//                         "assets/icons/popUp-icon.png",
//                         height: 50.h,
//                         width: 50.w,
//                       ),
//                     ),
//                     content: ListTile(
//                       titleAlignment: ListTileTitleAlignment.center,
//                       title: Text(local.requestSentSuccessfully),
//                       subtitle: Text(local.requestWillBeReviewed),
//                     ),
//                     ontap: () => Navigator.of(context).pushAndRemoveUntil(
//                         MaterialPageRoute(builder: (context) => HomeScreen()),
//                         (route) => false),
//                   );
//                 });
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "",
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     InkWell(
//                       child: identity != null
//                           ? GestureDetector(
//                               onTap: () => showImage(context, identity!),
//                               child: Image.file(
//                                 identity!,
//                                 height: 60,
//                                 width: 60,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : Image.asset("$imagePath/upload-photo.png"),
//                       onTap: () => pickImageFromGallery(context).then((value) {
//                         if (value != null) {
//                           setState(() {
//                             houseModel.identity = value;
//                             identity = value; // updating UI
//                           });
//                         }
//                       }),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     Text(
//                       local.electronicDeed,
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     InkWell(
//                       child: electronic_insurance != null
//                           ? GestureDetector(
//                               onTap: () =>
//                                   showImage(context, electronic_insurance!),
//                               child: Image.file(
//                                 identity!,
//                                 height: 60,
//                                 width: 60,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : Image.asset("$imagePath/upload-photo.png"),
//                       onTap: () => pickImageFromGallery(context).then((value) {
//                         if (value != null) {
//                           setState(() {
//                             houseModel.electronic_instrument = value;
//                             electronic_insurance = value; // updating UI
//                           });
//                         }
//                       }),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     Custom_textField(
//                       hintText: '',
//                       textt: local.estateName,
//                       controller: houseNameController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال اسم العقار';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.text,
//                       onChanged: (value) {},
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       local.estateType,
//                     ),
//                     const SizedBox(height: 8),
//                     DropdownButtonFormField<String>(
//                       dropdownColor: Colors.white,
//                       value: selectedType,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                           borderSide: const BorderSide(
//                               color: Colors.transparent, width: 0),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                           borderSide: const BorderSide(
//                               color: Colors.transparent, width: 0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                           borderSide: const BorderSide(
//                               color: Colors.transparent, width: 0),
//                         ),
//                         fillColor: grey.withOpacity(0.5),
//                         filled: true,
//                         labelStyle:
//                             Theme.of(context).textTheme.bodyMedium!.copyWith(
//                                   color: darkGrey,
//                                   overflow: TextOverflow.clip,
//                                 ),
//                         hintText: "",
//                       ),
//                       items: types.map((String type) {
//                         return DropdownMenuItem<String>(
//                           value: type,
//                           child: Text(
//                             type,
//                             style: TextStyle(fontSize: 12),
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedType = newValue;
//                         });
//                       },
//                     ),
//                     Custom_textField(
//                       hintText: '',
//                       textt: local.space,
//                       controller: houseSpaceController,
//                       keyboardType: TextInputType.number, // If space is numeric
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال مساحة العقار';
//                         } else if (int.tryParse(value) == null) {
//                           return 'الرجاء إدخال مساحة صالحة';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) {},
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       local.city,
//                     ),
//                     const SizedBox(height: 8),
//                     DropdownButtonFormField<String>(
//                       dropdownColor: Colors.white,
//                       value: selectedCity,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                           borderSide: const BorderSide(
//                               color: Colors.transparent, width: 0),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                           borderSide: const BorderSide(
//                               color: Colors.transparent, width: 0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                           borderSide: const BorderSide(
//                               color: Colors.transparent, width: 0),
//                         ),
//                         fillColor: grey.withOpacity(0.5),
//                         filled: true,
//                         labelStyle:
//                             Theme.of(context).textTheme.bodyMedium!.copyWith(
//                                   color: darkGrey,
//                                   overflow: TextOverflow.clip,
//                                 ),
//                         hintText: "",
//                       ),
//                       items: _cities.map((String city) {
//                         return DropdownMenuItem<String>(
//                           value: city,
//                           child: Text(
//                             city,
//                             style: TextStyle(fontSize: 12),
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedCity = newValue;
//                         });
//                       },
//                     ),
//                     Custom_textField(
//                       hintText: local.enterDistrict,
//                       textt: local.district,
//                       controller: distrectnameController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال اسم الحي';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.text,
//                       onChanged: (value) {},
//                     ),
//                     Custom_textField(
//                       hintText: '',
//                       textt: local.price,
//                       controller: priceController,
//                       keyboardType: TextInputType.number, // If price is numeric
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال السعر';
//                         } else if (int.tryParse(value) == null) {
//                           return 'الرجاء إدخال قيمة صالحة للسعر';
//                         }
//                         return null;
//                       },
//                       onChanged: (value) {},
//                     ),
//                     Custom_textField(
//                       hintText: "",
//                       textt: local.estateSummary,
//                       controller: descriptionController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء إدخال وصف العقار';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.text,
//                       onChanged: (value) {},
//                     ),
//                     Custom_textField(
//                       hintText: "",
//                       textt: local.phone,
//                       controller: phoneController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "الرجاء إدخال رقم الهاتف";
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.text,
//                       onChanged: (value) {},
//                     ),
//                     Text(
//                       local.propertyLocation,
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     InkWell(
//                       child: Image.asset("$imagePath/Frame 177.png"),
//                       onTap: () async {
//                         await LocationPermissionHandler()
//                             .requestLocationPermission()
//                             .then((value) => LocationPermissionHandler()
//                                 .getCurrentLocation());
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder:
//                                 (context, animation, secondaryAnimation) =>
//                                     PinLocationScreen(
//                               onPlacePicked: (p0) {
//                                 // Ensure valid location data is being returned
//                                 if (p0.geometry != null) {
//                                   houseModel.lat =
//                                       p0.geometry!.location.lat.toString();
//                                   houseModel.long =
//                                       p0.geometry!.location.lng.toString();
//                                   houseModel.location = p0.name ?? '';
//                                   setState(() {
//                                     locationController.text =
//                                         houseModel.location ?? '';
//                                   });

//                                   // Confirm that data is passed back correctly
//                                   if (kDebugMode) {
//                                     print(
//                                         "Location selected: ${houseModel.location}");
//                                     print("Latitude: ${houseModel.lat}");
//                                     print("Longitude: ${houseModel.long}");
//                                   }
//                                 } else {
//                                   print("Error: Location or geometry is null");
//                                 }

//                                 // Close the map screen
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     TextFormFieldCustom(
//                       context: context,
//                       labelText: local.enterSiteLink,
//                       onChanged: (value) {
//                         houseModel.location = value;
//                       },
//                       controller: locationController,
//                       // number: true,
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     Text(local.mainPhoto,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 12)),
//                     SizedBox(height: constVerticalPadding),
//                     InkWell(
//                       onTap: () => pickImageFromGallery(context).then((value) {
//                         if (value != null) {
//                           setState(() {
//                             houseModel.image1 = value;
//                             image1 = value;
//                           });
//                         }
//                       }),
//                       child: Container(
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           border: Border.all(color: Colors.grey),
//                         ),
//                         child: image1 == null
//                             ? const Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.photo,
//                                         size: 25,
//                                         color:
//                                             Color.fromARGB(255, 77, 110, 168)),
//                                   ],
//                                 ),
//                               )
//                             : GestureDetector(
//                                 onTap: () => showImage(context, image1!),
//                                 child: Image.file(
//                                   image1!,
//                                   fit: BoxFit.cover,
//                                   width: 60,
//                                   height: 50,
//                                 ),
//                               ),
//                       ),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     Text(local.sectionPhotos,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 12)),
//                     SizedBox(height: constVerticalPadding),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         InkWell(
//                           onTap: () =>
//                               pickImageFromGallery(context).then((value) {
//                             if (value != null) {
//                               setState(() {
//                                 houseModel.image2 = value;
//                                 image2 = value;
//                               });
//                             }
//                           }),
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               border: Border.all(color: Colors.grey),
//                             ),
//                             child: image2 == null
//                                 ? const Center(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Icon(Icons.photo,
//                                             size: 25,
//                                             color: Color.fromARGB(
//                                                 255, 77, 110, 168)),
//                                       ],
//                                     ),
//                                   )
//                                 : GestureDetector(
//                                     onTap: () => showImage(context, image2!),
//                                     child: Image.file(
//                                       image2!,
//                                       fit: BoxFit.cover,
//                                       width: 40,
//                                       height: 40,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () =>
//                               pickImageFromGallery(context).then((value) {
//                             if (value != null) {
//                               setState(() {
//                                 houseModel.image3 = value;
//                                 image3 = value;
//                               });
//                             }
//                           }),
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               border: Border.all(color: Colors.grey),
//                             ),
//                             child: image3 == null
//                                 ? const Center(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Icon(Icons.photo,
//                                             size: 25,
//                                             color: Color.fromARGB(
//                                                 255, 77, 110, 168)),
//                                       ],
//                                     ),
//                                   )
//                                 : GestureDetector(
//                                     onTap: () => showImage(context, image3!),
//                                     child: Image.file(
//                                       image3!,
//                                       fit: BoxFit.cover,
//                                       width: 40,
//                                       height: 40,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () =>
//                               pickImageFromGallery(context).then((value) {
//                             if (value != null) {
//                               setState(() {
//                                 houseModel.image4 = value;
//                                 image4 = value;
//                               });
//                             }
//                           }),
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               border: Border.all(color: Colors.grey),
//                             ),
//                             child: image4 == null
//                                 ? const Center(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Icon(Icons.photo,
//                                             size: 25,
//                                             color: Color.fromARGB(
//                                                 255, 77, 110, 168)),
//                                       ],
//                                     ),
//                                   )
//                                 : GestureDetector(
//                                     onTap: () => showImage(context, image4!),
//                                     child: Image.file(
//                                       image4!,
//                                       fit: BoxFit.cover,
//                                       width: 60,
//                                       height: 50,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                           activeColor: primaryColor,
//                           value: isLocationConfirmed,
//                           onChanged: (value) {
//                             setState(() {
//                               isLocationConfirmed = value ?? false;
//                             });
//                           },
//                         ),
//                         Text(
//                           local.confirmlocation,
//                           style: TextStyle(fontSize: 12, color: blackColor),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     Center(
//                       child: MainButton(
//                         text: local.send,
//                         backGroundColor: primaryColor,
//                         onTap: () async {
//                           try {
//                             if (identity == null) {
//                               showSnackBar(context,
//                                   "من فضلك ارفع الهوية الوطنية", redColor);
//                               return;
//                             }

//                             if (electronic_insurance == null) {
//                               showSnackBar(
//                                   context,
//                                   local.pleaseuploadtheelectronicdeed,
//                                   redColor);
//                               return;
//                             }

//                             if (selectedType == null || selectedType!.isEmpty) {
//                               showSnackBar(
//                                   context, "يرجى إدخال نوع العقار", redColor);
//                               return;
//                             }

//                             if (houseNameController.text.isEmpty) {
//                               showSnackBar(
//                                   context, "يرجى إدخال اسم العقار", redColor);
//                               return;
//                             }

//                             if (houseSpaceController.text.isEmpty) {
//                               showSnackBar(
//                                   context, "يرجى إدخال مساحة العقار", redColor);
//                               return;
//                             }

//                             if (selectedCity == null || selectedCity!.isEmpty) {
//                               showSnackBar(
//                                   context, "يرجى اختيار المدينة", redColor);
//                               return;
//                             }

//                             if (distrectnameController.text.isEmpty) {
//                               showSnackBar(
//                                   context, "يرجى إدخال الحي", redColor);
//                               return;
//                             }

//                             if (priceController.text.isEmpty) {
//                               showSnackBar(
//                                   context, "يرجى إدخال السعر", redColor);
//                               return;
//                             }

//                             if (descriptionController.text.isEmpty) {
//                               showSnackBar(
//                                   context, "يرجى إدخال وصف العقار", redColor);
//                               return;
//                             }

//                             if (houseModel.location == null) {
//                               showSnackBar(
//                                   context, "يرجى تحديد موقع العقار", redColor);
//                               return;
//                             }

//                             if (houseModel.image1 == null) {
//                               showSnackBar(
//                                   context, "يرجى رفع الصورة الأولى", redColor);
//                               return;
//                             }

//                             if (phoneController.text.isEmpty) {
//                               showSnackBar(
//                                   context, "الرجاء إدخال رقم الهاتف", redColor);
//                               return;
//                             }

//                             if (!isLocationConfirmed) {
//                               showSnackBar(
//                                   context, local.confirmLocation, redColor);
//                               return;
//                             }
//                             if (electronic_insurance != null &&
//                                 identity != null &&
//                                 selectedType!.isNotEmpty &&
//                                 houseNameController.text.isNotEmpty &&
//                                 phoneController.text.isNotEmpty &&
//                                 houseSpaceController.text.isNotEmpty &&
//                                 selectedCity!.isNotEmpty &&
//                                 distrectnameController.text.isNotEmpty &&
//                                 priceController.text.isNotEmpty &&
//                                 descriptionController.text.isNotEmpty &&
//                                 houseModel.location != null &&
//                                 houseModel.image1 != null) {
//                               houseModel.house_space =
//                                   int.tryParse(houseSpaceController.text);
//                               houseModel.house_type = selectedType;
//                               houseModel.city_name = selectedCity;
//                               houseModel.description =
//                                   descriptionController.text;
//                               houseModel.district_name =
//                                   distrectnameController.text;
//                               houseModel.phone = phoneController.text;
//                               houseModel.house_name = houseNameController.text;
//                               houseModel.price =
//                                   int.tryParse(priceController.text);
//                               houseModel.identity = identity;
//                               houseModel.image1 = image1;
//                               houseModel.image2 = image2 ?? image1;
//                               houseModel.image3 = image3 ?? image1;
//                               houseModel.image4 = image4 ?? image1;

//                               await context
//                                   .read<HouseCubit>()
//                                   .pushOrder(context);
//                             }
//                           } on Exception catch (e) {
//                             print('Error: $e');
//                             showSnackBar(context, 'Error: Failed to log in $e',
//                                 redColor);
//                           }
//                         },
//                       ),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     Center(
//                       child: MainButton(
//                           text: local.cancelRequest,
//                           backGroundColor: grey,
//                           onTap: () {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   backgroundColor: Colors.white,
//                                   title: Text(
//                                     "هل انت متأكد من إلغاء الطلب؟",
//                                     style: TextStyle(fontSize: 12),
//                                   ),
//                                   content: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       ElevatedButton(
//                                         onPressed: () async {
//                                           // Navigate to HomeScreen and remove all previous routes
//                                           Navigator.of(context)
//                                               .pushAndRemoveUntil(
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     HomeScreen()),
//                                             (route) => false,
//                                           );
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           foregroundColor: Colors.white,
//                                           backgroundColor: const Color.fromRGBO(
//                                               52, 168, 83, 1),
//                                           elevation: 5,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 2),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(7),
//                                           ),
//                                         ),
//                                         child: const Text(
//                                           'نعم',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           // Simply close the dialog without any action
//                                           Navigator.of(context).pop();
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           foregroundColor: Colors.white,
//                                           backgroundColor: Colors.red,
//                                           elevation: 2,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 20, vertical: 2),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(7),
//                                           ),
//                                         ),
//                                         child: const Text(
//                                           local.no,
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             );
//                           }),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
