import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'package:intl/intl.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/sar_image.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/functions/check_token.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/view/auth/sendotp.dart';
import 'package:rct/view/ownership/OwnerShipFeature2.dart';
import 'package:rct/view/share_rct/cubit.dart';
import 'package:rct/view/share_rct/userdetails.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../common copounents/custom_project_datails_widget.dart';
import '../../common copounents/pdf_viewer_view.dart';
import '../../generated/l10n.dart';
import '../google maps/open_in_maps.dart';
import '../ownership/ownership_details_screen.dart';

// ignore: must_be_immutable
class ShareDetails extends StatefulWidget {
  String id;
  final bool isdeeplink;
  static String ScreenId = "/details";

  ShareDetails({super.key, required this.id, this.isdeeplink = false});

  @override
  State<ShareDetails> createState() => _ShareDetailsState();
}

class _ShareDetailsState extends State<ShareDetails> {
  int ind = 0;
  int countofchances = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  RangeValues values = const RangeValues(0, 10);
  dynamic formattedCost;
  double? price;
  initState() {
    super.initState();
    checkLoginStatus();
    // bool isFound= context.read<ShareCubit>().checkproduct(widget.id!);
    // if (!isFound) {
    //   print("iiiiiiiiiiiiiiiiiiii");
    //   _fetchInitialData();
    // }
    List<Modelget> getdata = ShareCubit.get(context).allShareList;

    // if (state is ShareFilterCategorySuccessState) {
    //   getdata = ShareCubit.get(context).filterByCategoryList!;
    // }

    product = getdata.firstWhere(
      (element) => element.id == widget.id,
      orElse: () => Modelget(id: ''),
    );

    setState(() {
      price = double.tryParse(product.opportunity_price.toString());

      print("oper age: ${product.age}");
      if (price != null) {
        double totalCost =
            price! * countofchances; // Multiply before formatting
        print("Raw Total Cost: $totalCost");

        formattedCost = NumberFormat('#,###').format(totalCost);
        print("Formatted Total Cost: $formattedCost");
      } else {
        formattedCost = '0';
      }

      print("Count of chances: $countofchances");
    });
  }

  dynamic product;
  TextEditingController phonecontroller = TextEditingController();
  bool? isLoggedIn;

  Future<bool> checkLoginStatus() async {
    isLoggedIn =
        await Checktoken().hasToken(); // Ensure Checktoken is correctly defined
    return isLoggedIn ?? false; // Return false if isLoggedIn is null
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return SafeArea(
      bottom: false,
      top: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          floatingActionButton: Row(
            children: [
              IconButton(
                padding: EdgeInsets.all(10),
                icon: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  child: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Spacer(),
              IconButton(
                icon: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  if (product != null && product.id != null) {
                    // Construct the deep link URL with the product ID
                    String deepLink = "$linkServerName/share/${product.id}";

                    // Share the product details
                    Share.share(
                      "$deepLink : ${local.joinRCT}",
                    );
                  } else {
                    // Show an error message if product details are unavailable
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: Unable to fetch product details"),
                      ),
                    );
                  }
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .42,
                            child: Stack(
                              children: [
                                PageView(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      ind = index;
                                    });
                                  },
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _showImageDialog(
                                          [
                                            "${product.image1}",
                                            if (product.image2 != null)
                                              "${product.image2}",
                                            if (product.image3 != null)
                                              "${product.image3}",
                                            if (product.image4 != null)
                                              "${product.image4}",
                                          ],
                                          0, // This should match the index of the tapped image
                                          context,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(40),
                                            bottomLeft: Radius.circular(40)),
                                        child: Image.network(
                                          "${product.image1}",
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showImageDialog(
                                          [
                                            "${product.image1}",
                                            if (product.image2 != null)
                                              "${product.image2}",
                                            if (product.image3 != null)
                                              "${product.image3}",
                                            if (product.image4 != null)
                                              "${product.image4}",
                                          ],
                                          1, // This should match the index of the tapped image
                                          context,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(40),
                                            bottomLeft: Radius.circular(40)),
                                        child: Image.network(
                                          product.image2 == null
                                              ? "${product.image1}"
                                              : "${product.image2}",
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showImageDialog(
                                          [
                                            "${product.image1}",
                                            if (product.image2 != null)
                                              "${product.image2}",
                                            if (product.image3 != null)
                                              "${product.image3}",
                                            if (product.image4 != null)
                                              "${product.image4}",
                                          ],
                                          2, // This should match the index of the tapped image
                                          context,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(40),
                                            bottomLeft: Radius.circular(40)),
                                        child: Image.network(
                                          product.image3 == null
                                              ? "${product.image1}"
                                              : "${product.image3}",
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showImageDialog(
                                          [
                                            "${product.image1}",
                                            if (product.image2 != null)
                                              "${product.image2}",
                                            if (product.image3 != null)
                                              "${product.image3}",
                                            if (product.image4 != null)
                                              "${product.image4}",
                                          ],
                                          3, // This should match the index of the tapped image
                                          context,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(40),
                                            bottomLeft: Radius.circular(40)),
                                        child: Image.network(
                                          product.image4 == null
                                              ? "${product.image1}"
                                              : "${product.image4}",
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                /* SafeArea(
                                  child: Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: IconButton(
                                      icon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 10.h),
                                        child: Icon(
                                          Icons.arrow_back_ios_new_sharp,
                                          color: Colors.black,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                                SafeArea(
                                  child: Align(
                                    alignment: AlignmentDirectional.topEnd,
                                    child: IconButton(
                                      icon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 15.h),
                                        child: Icon(
                                          Icons.share,
                                          color: Colors.black,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (product != null &&
                                            product.id != null) {
                                          // Construct the deep link URL with the product ID
                                          String deepLink =
                                              "$linkServerName/details/${product.id}";

                                          // Share the product details
                                          Share.share(
                                            "$deepLink : ${local.joinRCT}",
                                          );
                                        } else {
                                          // Show an error message if product details are unavailable
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Error: Unable to fetch product details"),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: product.image1 != null
                                  ? 1
                                  : 0 +
                                      (product.image2 != null ? 1 : 0) +
                                      (product.image3 != null ? 1 : 0) +
                                      (product.image4 != null ? 1 : 0),
                              effect: const ExpandingDotsEffect(
                                dotWidth: 15,
                                dotHeight: 12,
                                dotColor: Colors.grey,
                                activeDotColor: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "${product.name}",
                              style: const TextStyle(
                                color: Color(0xFF20262F),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  // Image.asset(
                                  //   "assets/images/location.png",
                                  //   scale: 1.2,
                                  // ),
                                  SvgPicture.asset(
                                    "assets/icons/location.svg",
                                    width: 15,
                                    height: 17,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  product.city_name != "" &&
                                          product.district_name != ''
                                      ? Flexible(
                                          child: Text.rich(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${"${product.city_name}" ?? ''}",
                                                  style: const TextStyle(
                                                    color: Color(0xFF20262F),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " - ",
                                                  style: const TextStyle(
                                                    color: Color(0xFF20262F),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: product.district_name ??
                                                      '',
                                                  style: const TextStyle(
                                                    color: Color(0xFF20262F),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Flexible(
                                          child: Text.rich(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${product.location ?? ''}",
                                                  style: const TextStyle(
                                                    color: Color(0xFF20262F),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                         /* Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                // Image.asset(
                                //   "assets/images/locationMap.png",
                                //   scale: 1.5,
                                // ),
                                SvgPicture.asset(
                                  "assets/icons/locationMap.svg",
                                  width: 15,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    openGoogleMaps(
                                        double.parse(
                                            product.lat.toString() ?? ''),
                                        double.parse(
                                            product.long.toString() ?? ''),
                                        label: product.name);
                                  },
                                  child: Text(S.of(context).view_on_map,
                                      style: const TextStyle(
                                        color: Color(0xFF20262F),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),*/
                          product.type == "Existing Property" ||
                                  product.type == "عقار قائم"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      // Image.asset(
                                      //   "assets/images/home.png",
                                      //   scale: 1.5,
                                      // ),
                                      SvgPicture.asset(
                                        "assets/icons/home.svg",
                                        width: 13,
                                        height: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        S.of(context).renter_age,
                                        style: const TextStyle(
                                          color: Color(0xFF20262F),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${double.tryParse(product.age.toString() ?? '0')!.round() ?? ''}",
                                        style: const TextStyle(
                                          color: Color(0xFF20262F),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 5,
                          ),
                          ////
                          ////
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 70,
                                    child: Stack(
                                      children: [
                                        IgnorePointer(
                                          child: FlutterSlider(
                                            rtl: CacheHelper.getData(
                                                        key: 'lang') ==
                                                    'ar'
                                                ? true
                                                : false,
                                            values: [
                                              0,
                                              (double.parse(product
                                                      .number_opportunity_pay)) +
                                                  countofchances.toDouble()
                                            ],
                                            rangeSlider: true,
                                            max: double.tryParse(
                                                product.opportunity_count),
                                            min: 0,
                                            handlerWidth: 12,
                                            handlerHeight: 12,
                                            handler: FlutterSliderHandler(
                                              decoration: const BoxDecoration(),
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            rightHandler: FlutterSliderHandler(
                                              decoration: const BoxDecoration(),
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            tooltip: FlutterSliderTooltip(
                                              alwaysShowTooltip: true,
                                              custom: (value) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Text(
                                                    value.toInt().toString(),
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                );
                                              },
                                            ),
                                            trackBar: FlutterSliderTrackBar(
                                              activeTrackBarHeight: 2,
                                              inactiveTrackBarHeight: 2,
                                              activeTrackBar: BoxDecoration(
                                                  color: Colors.black),
                                              inactiveTrackBar: BoxDecoration(
                                                  color: Colors.grey[300]),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            top: 0,
                                            right: CacheHelper.getData(
                                                        key: 'lang') ==
                                                    'en'
                                                ? 0
                                                : null,
                                            left: CacheHelper.getData(
                                                        key: 'lang') ==
                                                    'ar'
                                                ? 0
                                                : null,
                                            child: Visibility(
                                              visible: (double.parse(product
                                                          .number_opportunity_pay)) +
                                                      countofchances
                                                          .toDouble() <
                                                  double.parse(product
                                                      .opportunity_count),
                                              child: Text(
                                                  '${product.opportunity_count}',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey[600])),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${NumberFormat('#,###').format(int.tryParse(product.total_price))}",
                                        style: const TextStyle(
                                          color: Color(0xFF20262F),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      CacheHelper.getData(key: "lang") == "ar"
                                          ? SarImage(
                                              height: 14,
                                              color: primaryColor,
                                            )
                                          : Container(),
                                      // CacheHelper.getData(key: "lang") == "en"
                                      //     ? SarImage(
                                      //         height: 14,
                                      //         color: primaryColor,
                                      //       )
                                      //     : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              spacing: 7,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OwnerShipFeature2(
                                  icon: "assets/icons/sar.svg",
                                  title: S
                                      .of(context)
                                      .opportunity_price
                                      .replaceAll(":", ""),
                                  subtitle: "${product.opportunity_price}",
                                ),
                                OwnerShipFeature2(
                                  icon: "assets/icons/calendar.svg",
                                  title: S
                                      .of(context)
                                      .opportunityduration
                                      .replaceAll(":", ""),
                                  subtitle:
                                      " ${product.project_duration} ${local.month}",
                                ),
                                OwnerShipFeature2(
                                  icon: "assets/icons/opportunity.svg",
                                  title: S
                                      .of(context)
                                      .remainingopportunities
                                      .replaceAll(":", ""),
                                  subtitle:
                                      "${(int.tryParse(product.opportunity_count)! - int.tryParse(product.number_opportunity_pay)!)}",
                                ),
                                OwnershipFeature(
                                  icon: "assets/images/percentage.png",
                                  title: product.type == "Existing Property" ||
                                          product.type == "عقار قائم"
                                      ? S.of(context).monthly_return
                                      : S.of(context).final_return,
                                  subtitle: "${product.percent_number} %",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          /*  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  // child: Image.asset(
                                  //     "assets/images/hand-holding-usd-2 1.png"),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      local.opportunityPrice,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      "${product.opportunity_price}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),*/
                          /*Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  // child:
                                  //     Image.asset("assets/images/tax-alt-6 1.png"),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      local.financialrevenue,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      " ${product.percent_number}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      "%",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),*/
                          /* Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  // child: Image.asset(
                                  //     "assets/images/duration-alt 1.png"),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      local.opportunityduration,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      " ${product.number_time}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      local.month,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),*/
                          /* Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  // child: Image.asset(
                                  //     "assets/images/checklist-task-budget 1.png"),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      local.remainingopportunities,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      "${product.opportunity_count}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),*/
                          const SizedBox(
                            height: 9,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  local.discreption,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 7),
                            child: Text(
                              "${product.description}",
                              style: const TextStyle(
                                color: Color(0xFF20262F),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (product.file != null &&
                                      product.file != '') {
                                    print(product.file);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFViewerPage(
                                          pdfUrl: product.file!,
                                        ),
                                      ),
                                    );

                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(S.of(context).file_not_found),
                                      ),
                                    );
                                  }

                                },
                                child: CustomProjectDetailsWidget(
                                  image: "assets/icons/pdf.svg",
                                  title: S.of(context).open_project_file,
                                  height: 16,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  openGoogleMaps(
                                      double.parse(
                                          product.lat.toString() ?? ''),
                                      double.parse(
                                          product.long.toString() ?? ''),
                                      label: product.name);
                                },
                                child: CustomProjectDetailsWidget(
                                  image: "assets/icons/locationMap.svg",
                                  title: S.of(context).open_project_location,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            GestureDetector(
                              onTap: () {
                                product.opportunity_count != 0
                                    ? setState(() {
                                        if (countofchances <
                                            (int.tryParse(product
                                                    .opportunity_count)! -
                                                int.tryParse(product
                                                    .number_opportunity_pay)!))
                                          countofchances++;

                                        price = double.tryParse(product
                                            .opportunity_price
                                            .toString());

                                        if (price != null) {
                                          double totalCost = price! *
                                              countofchances; // Multiply before formatting
                                          print("Raw Total Cost: $totalCost");

                                          formattedCost = NumberFormat('#,###')
                                              .format(totalCost);
                                          print(
                                              "Formatted Total Cost: $formattedCost");
                                        } else {
                                          formattedCost = '0';
                                        }

                                        print(
                                            "Count of chances: $countofchances");

                                        print(formattedCost);
                                        print(countofchances);
                                        print(price);
                                      })
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              textAlign: TextAlign.center,
                                              local.alert,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            content: Text(
                                              textAlign: TextAlign.center,
                                              local.theopportunityiscomplete,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ), // Display the login message
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  MainButton(
                                                    width: 100,
                                                    text: local.ok,
                                                    fontSize: 12,
                                                    textColor: Colors.white,
                                                    backGroundColor:
                                                        primaryColor,
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xff20262F),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              countofchances.toString(),
                              style: TextStyle(
                                color: Color(0xff20262F),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  setState(() {
                                    if (countofchances > 0) countofchances--;

                                    if (price != null) {
                                      double totalCost = price! *
                                          countofchances; // Multiply before formatting
                                      print("Raw Total Cost: $totalCost");

                                      formattedCost = NumberFormat('#,###')
                                          .format(totalCost);
                                      print(
                                          "Formatted Total Cost: $formattedCost");
                                    } else {
                                      formattedCost = '0';
                                    }

                                    print("Count of chances: $countofchances");
                                  });
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.remove,
                                    size: 24,
                                    color: Color(0xff20262F),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        if ((int.tryParse(product.opportunity_count)! -
                                int.tryParse(
                                    product.number_opportunity_pay)!) !=
                            0)
                          GestureDetector(
                            onTap: () async {
                              String loginMessage =
                                  local.pleaselogin; // Custom message
                              bool isLoggedIn =
                                  await checkLoginStatus(); // Check if the user is logged in
                              print("id: ${widget.id}");
                              if (isLoggedIn) {
                                // If logged in, navigate !to the ChooseBuildingType screen
                                (int.tryParse(product.opportunity_count)! -
                                            int.tryParse(product
                                                .number_opportunity_pay)!) !=
                                        0
                                    ? {
                                        if (countofchances > 0)
                                          {
                                            if (product.city_name == "" &&
                                                product.district_name == "")
                                              {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PostUserDetails(
                                                      id: widget.id,
                                                      countofchances:
                                                          countofchances,
                                                      totalPrice: price! *
                                                          countofchances,
                                                      city: product.location,
                                                      district:
                                                          product.location,
                                                    ),
                                                  ),
                                                )
                                              }
                                            else
                                              {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PostUserDetails(
                                                      id: widget.id,
                                                      countofchances:
                                                          countofchances,
                                                      totalPrice: price! *
                                                          countofchances,
                                                      city: product.city_name,
                                                      district:
                                                          product.district_name,
                                                    ),
                                                  ),
                                                )
                                              }
                                          }
                                        else
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  S
                                                      .of(context)
                                                      .choose_num_opportunity,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          }
                                      }
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              textAlign: TextAlign.center,
                                              local.alert,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            content: Text(
                                              textAlign: TextAlign.center,
                                              local.theopportunityiscomplete,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ), // Display the login message
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  MainButton(
                                                    width: 100,
                                                    text: local.ok,
                                                    fontSize: 12,
                                                    textColor: Colors.white,
                                                    backGroundColor:
                                                        primaryColor,
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        });
                              } else {
                                // Show dialog if the user is not logged in
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          textAlign: TextAlign.center,
                                          local.alert,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        content: Text(
                                          textAlign: TextAlign.center,
                                          loginMessage,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ), // Display the login message
                                        actions: [
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text(
                                                  local.cancel,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                  // Navigate to the login screen
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SendOtp()), // Replace with your actual login screen
                                                  );
                                                },
                                                child: Text(
                                                  local.login,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                            child: Container(
                              height: 55.h,
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight:
                                          CacheHelper.getData(key: "lang") ==
                                                  "ar"
                                              ? Radius.circular(30)
                                              : Radius.circular(0),
                                      topLeft:
                                          CacheHelper.getData(key: "lang") ==
                                                  "en"
                                              ? Radius.circular(30)
                                              : Radius.circular(0)),
                                  color: Color(0xff20262F)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).share_now,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // bottomSheet:
        ),
      ),
    );
  }

  void _showImageDialog(
      List<String> imageUrls, int initialIndex, BuildContext context) {
    PageController pageController = PageController(initialPage: initialIndex);
    ValueNotifier<bool> isZoomed = ValueNotifier(false); // Track zoom state

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevents unnecessary expansion
              children: [
                // Image Viewer with Zoom Support
                SizedBox(
                  width: 300,
                  height: 400,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isZoomed,
                    builder: (context, zoomed, child) {
                      return PageView.builder(
                        controller: pageController,
                        physics: zoomed
                            ? NeverScrollableScrollPhysics() // Disable swipe if zooming
                            : AlwaysScrollableScrollPhysics(),
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onScaleStart: (_) => isZoomed.value = true,
                            onScaleEnd: (_) => isZoomed.value = false,
                            child: InteractiveViewer(
                              panEnabled: true, // Enable panning (dragging)
                              boundaryMargin: EdgeInsets.all(20),
                              minScale: 1.0,
                              maxScale: 3.0, // Allows zoom up to 3x
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),

                // Smooth Page Indicator
                SmoothPageIndicator(
                  controller: pageController,
                  count: imageUrls.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.black,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
