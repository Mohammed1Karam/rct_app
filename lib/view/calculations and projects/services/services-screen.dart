// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rct/l10n/app_localizations.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:provider/provider.dart';
// import 'package:rct/common%20copounents/app_bar_back_button.dart';
// import 'package:rct/common%20copounents/custom_dropdownlist.dart';
// import 'package:rct/common%20copounents/custom_textformfield.dart';
// import 'package:rct/common%20copounents/main_button.dart';
// import 'package:rct/constants/constants.dart';
// import 'package:rct/model/complex_model.dart';
// import 'package:rct/model/order_model.dart';
// import 'package:rct/view-model/cubits/complex/complex_cubit.dart';
// import 'package:rct/view-model/cubits/types/types_cubit.dart';
// import 'package:rct/view-model/functions/snackbar.dart';
// import 'package:rct/view/calculations%20and%20projects/services/measurment.dart';

// class ServicesScreen extends StatefulWidget {
//   const ServicesScreen({Key? key}) : super(key: key);

//   @override
//   State<ServicesScreen> createState() => _ServicesScreenState();
// }

// class _ServicesScreenState extends State<ServicesScreen> {
//   String? _selectedType;
//   int? selectedId;
//   String? selectedPrice;
//   bool showButton = false;
//   TextEditingController apartmentController = TextEditingController();
//   TextEditingController floorsController = TextEditingController();
//   List<dynamic>? data;
//   bool isLoading = false;
//   List<String> itemNames = [];
//   Map<String, Map<String, dynamic>> nameToDetails = {};

//   @override
//   void initState() {
//     super.initState();
//     context.read<TypesCubit>().get();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var local = S.of(context);
//     ComplexModel complexModel =
//         Provider.of<ComplexModel>(context, listen: false);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: BackButtonAppBar(context),
//       body: BlocBuilder<TypesCubit, TypesState>(
//         builder: (context, state) {
//           OrderModel orderModel =
//               Provider.of<OrderModel>(context, listen: false);

//           if (state is TypesLoading) {
//             isLoading = true;
//           } else if (state is TypesFailure) {
//             isLoading = false;
//             SchedulerBinding.instance.addPostFrameCallback((_) {
//               showSnackBar(context, state.errMessage, Colors.red);
//             });
//           } else if (state is TypesSuccess) {
//             isLoading = false;
//             data = state.types;
//             itemNames = data!.map((item) => item['name'] as String).toList();
//             for (var item in data!) {
//               nameToDetails[item['name']] = {
//                 'id': item['id'],
//                 'price': item['price']
//               };
//             }
//           }

//           return BlocListener<ComplexCubit, ComplexState>(
//             listener: (context, state) {
//               if (state is ComplexLoading) {
//                 setState(() {
//                   isLoading = true;
//                 });
//               } else if (state is ComplexFailure) {
//                 setState(() {
//                   isLoading = false;
//                 });
//                 SchedulerBinding.instance.addPostFrameCallback((_) {
//                   showSnackBar(context, state.errMessage, Colors.red);
//                 });
//               } else if (state is ComplexSuccess) {
//                 setState(() {
//                   isLoading = false;
//                 });
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => ServicesMeasurment()));
//               }
//             },
//             child: ModalProgressHUD(
//               inAsyncCall: isLoading,
//               child: SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         local.buildingMechanism,
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
//                       SizedBox(height: constVerticalPadding),
//                       CustomDropDownList(
//                         list: itemNames,
//                         selectedValue: _selectedType,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             showButton = true;
//                             _selectedType = newValue!;
//                             selectedId = nameToDetails[newValue]!['id'];
//                             selectedPrice = nameToDetails[newValue]!['price'];
//                             // _selectedType = nameToDetails[newValue]!['name'];
//                             // print(_selectedType == local.residentialComplex);
//                           });
//                         },
//                         hint: local.chooseType,
//                       ),
//                       SizedBox(height: constVerticalPadding),
//                       Center(
//                         child: showButton
//                             ? _selectedType == "مجمع سكنى"
//                                 ? Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         local.numberOfFloors,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyLarge,
//                                       ),
//                                       SizedBox(height: constVerticalPadding),
//                                       TextFormFieldCustom(
//                                         context: context,
//                                         labelText: local.enterNumberOfFloors,
//                                         controller: floorsController,
//                                         onChanged: (value) {},
//                                       ),
//                                       SizedBox(height: constVerticalPadding),
//                                       Text(
//                                         local.numberOfApartments,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyLarge,
//                                       ),
//                                       SizedBox(height: constVerticalPadding),
//                                       TextFormFieldCustom(
//                                         context: context,
//                                         labelText:
//                                             local.enterNumberOfApartments,
//                                         onChanged: (value) {},
//                                         controller: apartmentController,
//                                       ),
//                                       SizedBox(height: constVerticalPadding),
//                                       Center(
//                                         child: MainButton(
//                                           text: local.next,
//                                           backGroundColor: primaryColor,
//                                           onTap: () async {
//                                             await context
//                                                 .read<ComplexCubit>()
//                                                 .createComplex(complexModel);
//                                             complexModel.floorCount =
//                                                 floorsController.text;
//                                             complexModel.departmentCount =
//                                                 apartmentController.text;
//                                             complexModel.buildId =
//                                                 selectedId.toString();
//                                             orderModel.type_id = selectedId!;
//                                             if (kDebugMode) {
//                                               print(orderModel.type_id);
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : MainButton(
//                                     text: local.next,
//                                     backGroundColor: primaryColor,
//                                     onTap: () {
//                                       orderModel.type_id = selectedId!;
//                                       // orderModel.cost = selectedPrice!;
//                                       if (kDebugMode) {
//                                         print(
//                                             "build_id: ${orderModel.type_id}");
//                                       }
//                                       Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   ServicesMeasurment()));
//                                     },
//                                   )
//                             : Container(),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
