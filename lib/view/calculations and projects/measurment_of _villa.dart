import 'package:flutter/material.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_dropdownlist.dart';
import 'package:rct/common%20copounents/custom_textFormField.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view-model/services/create_areaspace.dart';
import 'package:rct/view/calculations%20and%20projects/building_struct_screen.dart';

import '../../generated/l10n.dart';

class MeasurmentOfVilla extends StatefulWidget {
  static String id = "MeasurmentOfFieldScreen";

  const MeasurmentOfVilla({super.key});

  @override
  State<MeasurmentOfVilla> createState() => _MeasurmentOfVillaState();
}

class _MeasurmentOfVillaState extends State<MeasurmentOfVilla> {
  String? selectedName;
  double? selectedPrice;

  int? _selectedCardIndex;

  String? _selectedType;
  String? _selectedType2;
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isChecked = false;
  bool islandChecked = false;
  @override
  Widget build(BuildContext context) {
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
                    controller: controller,
                    border: true,
                    number: true,
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
                      controller.text = convertedValue;
                      controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length),
                      );
                    },
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
                  // Checkbox and Text

                  Row(
                    children: [
                      Checkbox(
                        activeColor: primaryColor,
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Text(
                        local.addpool,
                        style: TextStyle(fontSize: 12),
                      ), // Update this with appropriate localization key
                    ],
                  ),

                  // Checkbox and Text

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

                  SizedBox(height: constVerticalPadding),
                  Center(
                    child: MainButton(
                      text: local.next,
                      backGroundColor: primaryColor,
                      onTap: () async {
                        orderModel.floorcount = 0;
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            if (isChecked == false) {
                              orderModel.SwimmingPool = 0;
                              orderModel.has_pool = 0;
                            } else {
                              orderModel.has_pool = 1;
                              orderModel.SwimmingPool = 48;
                            }
                            if (islandChecked == false) {
                              orderModel.islandChecked = 0;
                            } else {
                              orderModel.islandChecked = 1;
                            }
                            isLoading = true;
                            orderModel.areaspace =
                                double.parse(controller.text);
                          });
                          await CreateAreaSpace()
                              .create(controller.text, context)
                              .then((value) => {
                                    value
                                        ? {
                                            setState(() {
                                              isLoading = false;
                                            }),
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BuildingStructScreen())),
                                          }
                                        : {
                                            setState(() {
                                              isLoading = false;
                                            }),
                                            showSnackBar(
                                                context,
                                                local.errorPleaseTryAgain,
                                                redColor)
                                          }
                                  });
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
