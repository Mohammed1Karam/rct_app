// import 'package:flutter/material.dart';
// import 'package:rct/l10n/app_localizations.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:provider/provider.dart';
// import 'package:rct/common%20copounents/app_bar_back_button.dart';
// import 'package:rct/common%20copounents/custom_textFormField.dart';
// import 'package:rct/common%20copounents/main_button.dart';
// import 'package:rct/constants/constants.dart';
// import 'package:rct/model/order_model.dart';
// import 'package:rct/view-model/functions/snackbar.dart';
// import 'package:rct/view-model/services/create_areaspace.dart';
// import 'package:rct/view/calculations%20and%20projects/services/services_form.dart';

// class ServicesMeasurment extends StatefulWidget {
//   static String id = "MeasurmentOfFieldScreen";

//   const ServicesMeasurment({super.key});

//   @override
//   State<ServicesMeasurment> createState() => _ServicesMeasurmentState();
// }

// class _ServicesMeasurmentState extends State<ServicesMeasurment> {
//   TextEditingController controller = TextEditingController();
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
//     var local = S.of(context);
//     return ModalProgressHUD(
//       inAsyncCall: isLoading,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: BackButtonAppBar(context),
//         body: SafeArea(
//           child: Form(
//             key: formKey,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     local.totalLandArea,
//                     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                           fontWeight: mainFontWeight,
//                         ),
//                   ),
//                   SizedBox(height: constVerticalPadding),
//                   TextFormFieldCustom(
//                     context: context,
//                     labelText: local.pleaseEnterTotalArea,
//                     onChanged: (value) {},
//                     controller: controller,
//                     border: true,
//                     number: true,
//                   ),
//                   SizedBox(
//                     height: constVerticalPadding,
//                   ),
//                   Center(
//                     child: MainButton(
//                       text: local.next,
//                       backGroundColor: primaryColor,
//                       onTap: () async {
//                         if (formKey.currentState!.validate()) {
//                           // Navigator.pushNamed(
//                           //     context, AppRoutes.buildingStructScreen);
//                           setState(() {
//                             isLoading = true;
//                             orderModel.areaspace =
//                                 double.parse(controller.text);
//                           });
//                           await CreateAreaSpace()
//                               .create(controller.text, context)
//                               .then((value) => {
//                                     value
//                                         ? {
//                                             setState(() {
//                                               isLoading = false;
//                                             }),
//                                             Navigator.of(context).push(
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ServiseForm())),
//                                           }
//                                         : {
//                                             setState(() {
//                                               isLoading = false;
//                                             }),
//                                             showSnackBar(
//                                                 context,
//                                                 local.errorPleaseTryAgain,
//                                                 redColor)
//                                           }
//                                   });
//                         }
//                       },
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
