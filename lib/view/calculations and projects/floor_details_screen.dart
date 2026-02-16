import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/build_types_model.dart';
import 'package:rct/model/complex_model.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/cubits/build_types_and_floors/build_types_and_floors_cubit.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/calculations%20and%20projects/total_cost_screen.dart';

class FloorDetailsScreen extends StatefulWidget {
  const FloorDetailsScreen({super.key});

  @override
  State<FloorDetailsScreen> createState() => _FloorDetailsScreenState();
}

class _FloorDetailsScreenState extends State<FloorDetailsScreen> {
  TextEditingController controller = TextEditingController();
  int? _selectedCardIndex;
  List<BuildTypesModel> buildTypesModel = [];
  bool isLoading = false;

  String? selectedName;
  dynamic selectedPrice = 1;

  @override
  void initState() {
    super.initState();
    context.read<BuildTypesAndFloorsCubit>().getBuildTypes(context);
  }

  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    ComplexModel complexModel =
        Provider.of<ComplexModel>(context, listen: false);

    // selectedPrice! = AppPreferences.getData(key: "price");

    var local = S.of(context);
    double floorTotal = 0.0;

    late dynamic fencepercent;
    double test;
    late dynamic fonalFormsPrice;
    double width = MediaQuery.of(context).size.width * 2;
    double excavationandbackfill = orderModel.areaspace * 1.5 * 57;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocBuilder<BuildTypesAndFloorsCubit, BuildTypesAndFloorsState>(
        builder: (context, state) {
          if (state is BuildTypesAndFloorsLoading) {
            isLoading = true;
          } else if (state is BuildTypesAndFloorsFailure) {
            isLoading = false;
            return Center(
              child: Text(state.errMessage),
            );
          } else if (state is BuildTypesAndFloorsSuccess) {
            isLoading = false;
            buildTypesModel = state.buildTypes;
            double? floorCount = double.tryParse(complexModel.floorCount);
            if (floorCount != null) {
              double first = orderModel.areaspace *
                  (floorCount - (floorCount - 1)) *
                  (0.75);
              double mid = orderModel.areaspace * (floorCount - 2) * (0.75);
              double last = orderModel.areaspace *
                  (floorCount - (floorCount - 1)) *
                  (0.525);
              floorTotal = first + mid + last;
              test = first + mid + last;
              if (kDebugMode) {}
            }
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 2.5,
                      child: orderModel.floorDetails.isEmpty
                          ? Container()
                          //  ListView.builder(
                          //     itemCount: 3,
                          //     itemBuilder: (context, index) {
                          //       String key = complexMap.keys.elementAt(index);
                          //       String value = complexMap[key]!;
                          //       return FloorDetails(
                          //           text: key, number: double.tryParse(value));
                          //     },
                          //   )
                          : ListView.builder(
                              itemCount: orderModel.floorDetails.length,
                              itemBuilder: (context, index) {
                                double? size = double.tryParse(
                                    orderModel.floorDetails[index]["size"]);
                                dynamic number =
                                    (size! / 100) * orderModel.areaspace;
                                floorTotal += number;
                                return FloorDetails(
                                  text: CacheHelper.getData(key: "lang")=="en"?orderModel.floorDetails[index]["name"]["en"]
                                      .toString():orderModel.floorDetails[index]["name"]["ar"]
                                      .toString(),
                                  number: number,
                                );
                              },
                            ),
                    ),
                    Text(
                      local.typeOfBuilding,
                      style: TextStyle(
                        fontSize: 12,
                        color: blackColor.withOpacity(0.5),
                      ).copyWith(
                        fontWeight: mainFontWeight,
                      ),
                    ),
                    SizedBox(
                      height: constVerticalPadding,
                    ),
                    SizedBox(
                      height: 80,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                10.0), // Adjust the value for equal spacing
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: buildTypesModel.length,
                          itemBuilder: (context, index) {
                            return buildCard(
                              index,
                              ''' ${buildTypesModel[index].name!}''',
                              '''${buildTypesModel[index].price!}''',
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: constVerticalPadding),
                    Center(
                      child: MainButton(
                        text: local.next,
                        backGroundColor: primaryColor,
                        onTap: () async {
                          fencepercent = orderModel.streetDetails ==
                                  local.oneStreetFencePercentage
                              ? 1.97
                              : orderModel.streetDetails ==
                                      local.twoStreetsFencePercentage
                                  ? 1.8
                                  : orderModel.streetDetails ==
                                          local.threeStreetsFencePercentage
                                      ? 1.65
                                      : 1.5;
                          double Fence =
                              ((orderModel.areaspace / 20) * 2 + 40) /
                                  fencepercent;
                          double WaterTank = 23;
                          double SewageTank = 7;
                          double bridgesSpace =
                              (((floorTotal / 10) * 650) / selectedPrice);

                          fonalFormsPrice = orderModel.finalForm ==
                                  local.decorativeFacade
                              ? sqrt(orderModel.areaspace * 12 / 150) /
                                  selectedPrice
                              : orderModel.finalForm == local.stoneFacade
                                  ? (sqrt(orderModel.areaspace) *
                                          12 *
                                          1 *
                                          180) /
                                      selectedPrice
                                  : orderModel.finalForm ==
                                          local.twoStoneFacades
                                      ? (sqrt(orderModel.areaspace) *
                                              12 *
                                              2 *
                                              180) /
                                          selectedPrice
                                      : orderModel.finalForm ==
                                              local.threeStoneFacades
                                          ? (sqrt(orderModel.areaspace) *
                                                  12 *
                                                  3 *
                                                  180) /
                                              selectedPrice
                                          : orderModel.finalForm ==
                                                  local.fourStoneFacades
                                              ? (sqrt(orderModel.areaspace) *
                                                      12 *
                                                      4 *
                                                      180) /
                                                  selectedPrice
                                              : 0;
                          dynamic islandChecked =
                              orderModel.islandChecked == 1 ? 0 : 2000;
                          AppPreferences.saveData(key: 'fence', value: Fence);
                          AppPreferences.saveData(
                              key: 'Finalforms', value: fonalFormsPrice);

                          AppPreferences.saveData(
                              key: 'floorTotal', value: floorTotal);
                          //excavationandbackfill

                          AppPreferences.saveData(
                              key: 'excavationandbackfill',
                              value: excavationandbackfill);

                          AppPreferences.saveData(
                              key: 'bridge', value: bridgesSpace);

                          double all = (floorTotal +
                              Fence +
                              WaterTank +
                              SewageTank +
                              orderModel.SwimmingPool +
                              fonalFormsPrice +
                              bridgesSpace);
                          AppPreferences.saveData(key: 'all', value: all);
                          if (selectedName != null && selectedPrice != null) {
                            // Use selectedName and selectedPrice here
                            if (kDebugMode) {
                              print('Selected Name: $selectedName');
                              print('Selected Price: $selectedPrice');
                            }
                            // double? cost = double.tryParse(orderModel.cost as String);
                            print(orderModel.cost);
                            print("****");
                            orderModel.cost = (selectedPrice! * all) +
                                excavationandbackfill +
                                islandChecked;
                            // await CostCalc().calc(context);

                            print(
                                "$selectedPrice   ${orderModel.cost}**  $floorTotal + $Fence+ $fonalFormsPrice + $bridgesSpace+ $WaterTank+ $SewageTank+  total ${(floorTotal + Fence + WaterTank + SewageTank + orderModel.SwimmingPool + fonalFormsPrice + bridgesSpace)} + cost ${orderModel.cost} ");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TotalCostScreen()));
                          } else {
                            showSnackBar(
                                context, local.choosebuidingType, redColor);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCard(int index, String text, String price) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCardIndex = index;
          selectedName = buildTypesModel[index].name;
          selectedPrice = double.tryParse(buildTypesModel[index].price!);
          AppPreferences.saveData(
              key: "type", value: buildTypesModel[index].id);
        });
      },
      child: IntrinsicHeight(
        child: Container(
          width: 120.w,
          child: Card(
            color: _selectedCardIndex == index ? darkGrey : whiteBackGround,
            surfaceTintColor: whiteBackGround,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Column(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    double.parse(price).toStringAsFixed(0),
                    maxLines: 1,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}

class FloorDetails extends StatelessWidget {
  final String text;
  final dynamic number;
  const FloorDetails({
    super.key,
    required this.text,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: blackColor.withOpacity(0.5),
          ).copyWith(
            fontWeight: mainFontWeight,
          ),
        ),
        SizedBox(height: constVerticalPadding),
        Container(
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          child: Text(
            number!.toStringAsFixed(2),
          ),
        ),
        SizedBox(
          height: constVerticalPadding,
        ),
      ],
    );
  }
}
