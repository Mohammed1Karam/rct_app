// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rct/l10n/app_localizations.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:provider/provider.dart';
// import 'package:rct/common%20copounents/app_bar_back_button.dart';
// import 'package:rct/common%20copounents/custom_textformfield.dart';
// import 'package:rct/common%20copounents/main_button.dart';
// import 'package:rct/common%20copounents/pop_up.dart';
// import 'package:rct/constants/constants.dart';
// import 'package:rct/model/order_model.dart';
// import 'package:rct/view-model/cubits/order/order_cubit.dart';
// import 'package:rct/view-model/functions/image_picker.dart';
// import 'package:rct/view-model/functions/location_permission.dart';
// import 'package:rct/view-model/functions/snackbar.dart';
// import 'package:rct/view/google%20maps/pin_location_screen.dart';
// import 'package:rct/view/home_screen.dart';

// class ServiseForm extends StatefulWidget {
//   const ServiseForm({super.key});

//   @override
//   State<ServiseForm> createState() => _ServiseFormState();
// }

// class _ServiseFormState extends State<ServiseForm> {
//   TextEditingController controller = TextEditingController();
//   bool isLoading = false;
//   File? nationalidimage;
//   File? electronicimage;
//   @override
//   Widget build(BuildContext context) {
//     OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
//     var local = S.of(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: BackButtonAppBar(context),
//       body: BlocConsumer<OrderCubit, OrderState>(
//         listener: (context, state) {
//           // TODO: implement listener
//           if (state is OrderLoading) {
//             isLoading = true;
//           }
//           if (state is OrderFailure) {
//             isLoading = false;
//             SchedulerBinding.instance.addPostFrameCallback((_) {
//               showSnackBar(context, state.errMessage, Colors.red);
//             });
//           } else if (state is OrderSuccess) {
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
//                     ontap: () => Navigator.of(context).pushNamedAndRemoveUntil(
//                         HomeScreen.id, (route) => false),
//                   );
//                 });
//           }
//         },
//         builder: (context, state) {
//           return ModalProgressHUD(
//             inAsyncCall: isLoading,
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       local.nationalIdOrCommercialRegister,
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     InkWell(
//                       child: Image.asset("$imagePath/upload-photo.png"),
//                       onTap: () => pickImageFromGallery(context)
//                           .then((value) => value != null
//                               ? {
//                                   orderModel.nationalidimage = value,
//                                   nationalidimage = value,
//                                 }
//                               : null),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     Text(
//                       local.electronicDeed,
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     InkWell(
//                       child: Image.asset("$imagePath/upload-photo.png"),
//                       onTap: () => pickImageFromGallery(context)
//                           .then((value) => value != null
//                               ? {
//                                   orderModel.electronicimage = value,
//                                   electronicimage = value,
//                                 }
//                               : null),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     Text(
//                       local.addSoilTestReport,
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     Text(
//                       local.additionalCostIfNotAvailable,
//                       style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                             color: Colors.red,
//                             fontWeight: mainFontWeight,
//                           ),
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     InkWell(
//                       child: Image.asset("$imagePath/upload-photo.png"),
//                       onTap: () => pickImageFromGallery(context).then((value) =>
//                           value != null
//                               ? orderModel.landCheckImage = value
//                               : null),
//                     ),
//                     Text(
//                       local.propertyLocation,
//                       style: Theme.of(context).textTheme.bodyLarge,
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
//                                 orderModel.lat =
//                                     p0.geometry!.location.lat.toString();
//                                 orderModel.long =
//                                     p0.geometry!.location.lng.toString();
//                                 orderModel.location = p0.name!;
//                                 if (kDebugMode) {
//                                   print(orderModel.location);
//                                 }
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
//                       onChanged: (value) {},
//                       controller: controller,
//                       // number: true,
//                     ),
//                     SizedBox(height: constVerticalPadding),
//                     Center(
//                       child: MainButton(
//                         text: local.send,
//                         backGroundColor: primaryColor,
//                         onTap: () async {
//                           if (electronicimage != null &&
//                               nationalidimage != null) {
//                             await context.read<OrderCubit>().pushOrder(context);
//                           } else {
//                             showSnackBar(
//                                 context, "من فضلك اكمل المطلوب", redColor);
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
//                             Navigator.of(context).pushNamedAndRemoveUntil(
//                                 HomeScreen.id, (route) => false);
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
