import 'package:flutter/material.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_checkbox.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';

import 'package:rct/model/order_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/calculations%20and%20projects/confirmation_screen.dart';
import 'package:rct/view/terms_conditions_screen.dart';

class TotalCostScreen extends StatefulWidget {
  const TotalCostScreen({super.key});

  @override
  State<TotalCostScreen> createState() => _TotalCostScreenState();
}

class _TotalCostScreenState extends State<TotalCostScreen> {
  bool showButton = false;
  bool showDetails = false; // Add this flag to show/hide details
  TextEditingController controller = TextEditingController();
  bool isChecked = false;

  double? fence;
  dynamic finalFormsPrice;
  double? floorTotal;
  double? excavationAndBackfill;
  double? bridgesSpace;
  double? all;
  // Loading data from shared preferences
  Future<void> loadDataFromPreferences() async {
    fence = AppPreferences.getData(key: 'fence');
    finalFormsPrice = AppPreferences.getData(key: 'Finalforms');
    floorTotal = AppPreferences.getData(key: 'floorTotal');
    bridgesSpace = AppPreferences.getData(key: 'bridge');
    all = AppPreferences.getData(key: 'all');
    excavationAndBackfill =
        AppPreferences.getData(key: 'excavationandbackfill');

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadDataFromPreferences();
  }

  // Method to toggle details visibility
  void toggleDetailsVisibility() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    final formattedCost = NumberFormat('#,###').format(orderModel.cost);
    var local = S.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                local.totalProjectCost,
                style: TextStyle(
                  fontSize: 12,
                  color: blackColor.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(height: constVerticalPadding),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: grey,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 400.w,
              height: 50,
              child: Text(
                "$formattedCost ",
                style: TextStyle(
                  fontSize: 15,
                  color: blackColor.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(height: constVerticalPadding),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      local.buildingdetails,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      showDetails ? Icons.expand_less : Icons.expand_more,
                      color: primaryColor,
                    ),
                    onPressed:
                        toggleDetailsVisibility, // Toggle details visibility
                  ),
                ],
              ),
            ),

// Conditionally display details based on showDetails flag
            if (showDetails) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0), // Add padding to all content
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align Row vertically to start
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align all text to the start
                        children: [
                          Row(
                            children: [
                              Text(
                                local.waterTank,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Text(
                                " :23",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                local.sewageTank,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Text(
                                " :7",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                local.fence,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Text(
                                ": ${fence?.toStringAsFixed(2) ?? ''} ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                local.exteriorFinishing,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Text(
                                " :${finalFormsPrice?.toStringAsFixed(2) ?? ''}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                local.invertedBeams,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Text(
                                "${bridgesSpace?.toStringAsFixed(2) ?? ''}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                          orderModel.has_pool == 1
                              ? Row(
                                  children: [
                                    Text(
                                      local.swimmingPool,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    Text(
                                      "${orderModel.SwimmingPool}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                )
                              : Container(),
                          orderModel.islandChecked == 0
                              ? Row(
                                  children: [
                                    Text(
                                      local.soilTesting,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    Text(
                                      " :2000",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                )
                              : Container(),
                          Row(
                            children: [
                              Text(
                                local.floorArea,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Text(
                                ": ${floorTotal?.toStringAsFixed(2) ?? ''}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),

                          orderModel.floorcount != 0
                              ? Row(
                                  children: [
                                    Text(
                                      local.sortingUnite,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    Text(
                                      ": ${orderModel.unitNumber?.toStringAsFixed(2) ?? ''}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(height: 5), // Add space between texts
                          Row(
                            children: [
                              Text(
                                local.totalBuildingArea,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                              Text(
                                ": ${all?.toStringAsFixed(2) ?? ''}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                local.excavationandBackfillCharges,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                              Text(
                                ": ${excavationAndBackfill?.toStringAsFixed(2) ?? ''}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 10),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomCheckbox(
                    isChecked: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                        showButton = value ? true : false;
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

            SizedBox(height: constVerticalPadding),
            SizedBox(height: 10),
            showButton
                ? MainButton(
                    text: local.next,
                    backGroundColor: primaryColor,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConfirmationScreen())),
                  )
                : Container(),
            SizedBox(height: constVerticalPadding),
            // Toggle button to show/hide details
          ],
        ),
      ),
    );
  }
}
