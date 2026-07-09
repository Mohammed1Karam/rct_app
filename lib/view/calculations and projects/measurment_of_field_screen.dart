import 'package:flutter/material.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_dropdownlist.dart';
import 'package:rct/common%20copounents/custom_textFormField.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';

import 'package:rct/model/complex_model.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/services/cache_helper.dart';

import 'package:rct/view-model/cubits/complex/complex_cubit.dart';
import 'package:rct/view-model/functions/snackbar.dart';

import 'package:rct/view/calculations%20and%20projects/floor_detailsFor3Amaaer.dart';

import '../../generated/l10n.dart';

class MeasurmentOfFieldScreen extends StatefulWidget {
  static String id = "MeasurmentOfFieldScreen";

  const MeasurmentOfFieldScreen({super.key});

  @override
  State<MeasurmentOfFieldScreen> createState() =>
      _MeasurmentOfFieldScreenState();
}

class _MeasurmentOfFieldScreenState extends State<MeasurmentOfFieldScreen> {
  String? selectedName;
  double? selectedPrice;

  String? _selectedType;
  String? _selectedType2;
  int? selectedId;
  bool islandChecked = false;
  bool isNumberChecked = false;
  bool showButton = false;
  TextEditingController apartmentController = TextEditingController();
  TextEditingController floorsController = TextEditingController();
  TextEditingController areaspacecontroller = TextEditingController();
  TextEditingController Unitcontroller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  // bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    ComplexModel complexModel =
        Provider.of<ComplexModel>(context, listen: false);
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    var local = S.of(context);
    List<String> finishitem = [
      local.noStone,
      local.stoneFacade,
      local.twoStoneFacades,
      local.threeStoneFacades,
      local.fourStoneFacades,
      local.decorativeFacade,
    ];

    List<String> landItem = [
      local.oneStreetFencePercentage,
      local.twoStreetsFencePercentage,
      local.threeStreetsFencePercentage,
      local.fourStreetsFencePercentage,
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.totalLandArea,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ).copyWith(
                      fontWeight: mainFontWeight,
                    ),
                  ),
                  SizedBox(height: constVerticalPadding + 10),
                  TextFormFieldCustom(
                    context: context,
                    labelText: local.pleaseEnterTotalArea,
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

                      areaspacecontroller.text = convertedValue;
                      areaspacecontroller.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: areaspacecontroller.text.length),
                      );
                    },
                    controller: areaspacecontroller,
                    border: true,
                    number: true,
                  ),

                  SizedBox(height: constVerticalPadding),

                  CustomDropDownList(
                    list: finishitem,
                    selectedValue: _selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                        orderModel.finalForm = newValue;
                      });
                    },
                    hint: local.exteriorfinishing,
                  ),
                  SizedBox(height: constVerticalPadding),
                  CustomDropDownList(
                    list: landItem,
                    selectedValue: _selectedType2,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType2 = newValue!;
                        orderModel.streetDetails = newValue;
                      });
                    },
                    hint: local.landdetails,
                  ),

                  SizedBox(height: constVerticalPadding),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormFieldCustom(
                        context: context,
                        labelText: local.enterNumberOfFloors,
                        controller: floorsController,
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

                          floorsController.text = convertedValue;
                          floorsController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: floorsController.text.length),
                          );
                        },
                      ),
                      SizedBox(height: constVerticalPadding),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: primaryColor,
                            value: islandChecked,
                            onChanged: (value) {
                              setState(() {
                                islandChecked = value!;
                              });
                            },
                          ),
                          Text(
                            local.landcheck,
                            style: TextStyle(fontSize: 12),
                          ), // Update this with appropriate localization key
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: primaryColor,
                            value: isNumberChecked,
                            onChanged: (value) {
                              setState(() {
                                isNumberChecked = value!;
                              });
                              orderModel.unitNumber = 0;
                            },
                          ),
                          CacheHelper.getData(key: "lang") == "en"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      local.sortingUnite,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      local.independentTitleDeedforEachUnit,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      local.sortingUnite,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      local.independentTitleDeedforEachUnit,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                          SizedBox(width: constVerticalPadding),
                        ],
                      ),
                      isNumberChecked
                          ? SizedBox(
                              child: TextFormFieldCustom(
                                  context: context,
                                  labelText: local.enterUnitNumber,
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

                                    // Update the text field controller with the converted value if necessary
                                    Unitcontroller.text = convertedValue;
                                    Unitcontroller.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: floorsController.text.length),
                                    );
                                    orderModel.unitNumber =
                                        int.tryParse(Unitcontroller.text)! *
                                                1500 ??
                                            0;
                                  },
                                  controller: Unitcontroller),
                            )
                          : Container(),
                      SizedBox(height: constVerticalPadding),
                      Center(
                        child: MainButton(
                          text: local.next,
                          backGroundColor: primaryColor,
                          onTap: () async {
                            if (floorsController.text.isNotEmpty &&
                                areaspacecontroller.text.trim().isNotEmpty) {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  orderModel.SwimmingPool = 0;
                                  orderModel.has_pool = 0;

                                  isLoading = true;
                                  orderModel.areaspace =
                                      double.parse(areaspacecontroller.text);

                                  if (islandChecked == false) {
                                    orderModel.islandChecked = 0;
                                  } else {
                                    orderModel.islandChecked = 1;
                                  }
                                });
                              }

                              /******************************* */
                              await context
                                  .read<ComplexCubit>()
                                  .createComplex(complexModel);
                              complexModel.floorCount = floorsController.text;
                              orderModel.floorcount = floorsController.text;
                              complexModel.departmentCount =
                                  apartmentController.text;
                              complexModel.buildId = "";
                              orderModel.type_id = "";

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Floor3maaerDetails(),
                              ));
                              Unitcontroller.clear();
                              isNumberChecked = false;
                            } else {
                              if (floorsController.text.trim().isEmpty) {
                                showSnackBar(
                                    context, local.completeMessage, redColor);
                                return;
                              }
                              if (apartmentController.text.trim().isEmpty) {
                                showSnackBar(
                                    context, local.completeMessage, redColor);
                                return;
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  // Checkbox and Text

                  SizedBox(height: constVerticalPadding),

                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
