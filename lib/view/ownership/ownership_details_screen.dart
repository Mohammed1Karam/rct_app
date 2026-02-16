import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rct/model/renter_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/view-model/functions/file_picker.dart';
import 'package:rct/view/google%20maps/open_in_maps.dart';
import 'package:rct/view/ownership/OwnerShipFeature2.dart';
import 'package:rct/view/ownership/contract_screen.dart';
import 'package:rct/view/ownership/renters_cubit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common copounents/custom_project_datails_widget.dart';
import '../../common copounents/pdf_viewer_view.dart';
import '../../constants/linkapi.dart';
import '../../generated/l10n.dart';
import '../auth/sendotp.dart';
import '../home_screen.dart';

class OwnershipDetailsScreen extends StatefulWidget {
  OwnershipDetailsScreen({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<OwnershipDetailsScreen> createState() => _OwnershipDetailsScreenState();
}

class _OwnershipDetailsScreenState extends State<OwnershipDetailsScreen> {
  int ind = 0;
  final PageController _pageController = PageController();
  int quantity = 0;
  dynamic renterModel;

  void initState() {
    checkLoginStatus();
    List<RenterModel>? data = context.read<RentersCubit>().allRenterList;
    print(data.length);
    renterModel = data.firstWhere(
        (element) => element.id.toString() == widget.id,
        orElse: () => data.first);

    super.initState();
  }

  fetchRenterData() async {
    await RentersCubit.get(context)
        .fetchUnAuthData("$linkServerName/api/renters");
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                child:
                    Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Spacer(),
            IconButton(
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Icon(
                  Icons.share,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                if (renterModel.id != null) {
                  String deepLink = "$linkServerName/details/${renterModel.id}";
                  Share.share(
                    "$deepLink : ${local.renter}",
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .47,
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
                                      "${renterModel.images1 ?? ''}",
                                      if (renterModel.images2 != null)
                                        "${renterModel.images2}",
                                      if (renterModel.images3 != null)
                                        "${renterModel.images3}",
                                      if (renterModel.images4 != null)
                                        "${renterModel.images4}",
                                    ],
                                    0, // This should match the index of the tapped image
                                    context,
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(40),
                                      bottomLeft: Radius.circular(40)),
                                  child: renterModel.images1 != null
                                      ? Image.network(
                                          "${renterModel.images1 ?? ''}",
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                        )
                                      : const Icon(
                                          Icons.image,
                                          size: 120,
                                        ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showImageDialog(
                                    [
                                      "${renterModel.images1 ?? ''}",
                                      if (renterModel.images2 != null)
                                        "${renterModel.images2}",
                                      if (renterModel.images3 != null)
                                        "${renterModel.images3}",
                                      if (renterModel.images4 != null)
                                        "${renterModel.images4}",
                                    ],
                                    1, // This should match the index of the tapped image
                                    context,
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(40),
                                      bottomLeft: Radius.circular(40)),
                                  child: renterModel.images1 != null
                                      ? Image.network(
                                          renterModel.images2 == null
                                              ? "${renterModel.images1 ?? ''}"
                                              : "${renterModel.images2}",
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                        )
                                      : const Icon(
                                          Icons.image,
                                          size: 120,
                                        ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showImageDialog(
                                    [
                                      "${renterModel.images1 ?? ''}",
                                      if (renterModel.images2 != null)
                                        "${renterModel.images2}",
                                      if (renterModel.images3 != null)
                                        "${renterModel.images3}",
                                      if (renterModel.images4 != null)
                                        "${renterModel.images4}",
                                    ],
                                    2, // This should match the index of the tapped image
                                    context,
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(40),
                                      bottomLeft: Radius.circular(40)),
                                  child: renterModel.images1 != null
                                      ? Image.network(
                                          (renterModel.images3 == null
                                              ? "${renterModel.images1 ?? ''}"
                                              : "${renterModel.images3}"),
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                        )
                                      : const Icon(
                                          Icons.image,
                                          size: 120,
                                        ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showImageDialog(
                                    [
                                      "${renterModel.images1 ?? ''}",
                                      if (renterModel.images2 != null)
                                        "${renterModel.images2}",
                                      if (renterModel.images3 != null)
                                        "${renterModel.images3}",
                                      if (renterModel.images4 != null)
                                        "${renterModel.images4}",
                                    ],
                                    2, // This should match the index of the tapped image
                                    context,
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(40),
                                      bottomLeft: Radius.circular(40)),
                                  child: renterModel.images1 != null
                                      ? Image.network(
                                          (renterModel.images4 == null
                                              ? "${renterModel.images1 ?? ''}"
                                              : "${renterModel.images4}"),
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                        )
                                      : const Icon(
                                          Icons.image,
                                          size: 120,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          /*PositionedDirectional(
                            top: 30,
                            start: 5.w,
                            child: IconButton(
                              icon: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 15.h),
                                child: Icon(Icons.arrow_back_ios_new_sharp,
                                    color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: const ExpandingDotsEffect(
                          dotWidth: 10,
                          dotHeight: 8,
                          dotColor: Colors.grey,
                          activeDotColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            renterModel.title ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          // Image.asset(
                          //   "assets/images/location.png",
                          //   scale: 1.2,
                          // ),
                          SvgPicture.asset("assets/icons/location.svg",
                              width: 16, height: 17),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text.rich(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${renterModel.city! ?? ''}",
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
                                    text: renterModel.district ?? '',
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
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          // Image.asset(
                          //   "assets/images/locationMap.png",
                          //   scale: 1.5,
                          // ),
                          /*SvgPicture.asset("assets/icons/locationMap.svg",width: 15,height: 20),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              openGoogleMaps(
                                  double.parse(widget.renterModel.lat ?? ''),
                                  double.parse(widget.renterModel.long ?? ''),
                                  label: widget.renterModel.title);
                            },
                            child: Text(local.view_on_map,
                                style: const TextStyle(
                                  color: Color(0xFF20262F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                )),
                          ),*/
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    /* Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/home.png",
                            scale: 1.3,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            S.of(context).renter_age,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            "${widget.renterModel.age ?? ''}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),*/
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/homeSize.svg",
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${renterModel.area ?? ''} م²",
                            style: const TextStyle(
                              color: Color(0xFF20262F),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset(
                            "assets/icons/bed.svg",
                            width: 18,
                            height: 22,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${renterModel.rooms ?? ''}",
                            style: const TextStyle(
                              color: Color(0xFF20262F),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset(
                            "assets/icons/bath.svg",
                            width: 18,
                            height: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${renterModel.bathrooms ?? ''}",
                            style: const TextStyle(
                              color: Color(0xFF20262F),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        spacing: 7,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OwnerShipFeature2(
                            icon: "assets/icons/chart.svg",
                            title: S.of(context).payment_plan,
                            subtitle:
                                '${renterModel.paymentPlan ?? ''} ${local.year}',
                          ),
                          OwnerShipFeature2(
                            icon: "assets/icons/calendar.svg",
                            title: S.of(context).payment_duration,
                            subtitle:
                                '${double.tryParse(renterModel.paymentDuration.toString())!.round() ?? ''} ${local.month}',
                          ),
                          OwnerShipFeature2(
                            icon: "assets/icons/sides.svg",
                            title: S.of(context).num_of_units,
                            subtitle: '${renterModel.units ?? ''}',
                          ),
                          OwnerShipFeature2(
                            icon: "assets/icons/sar.svg",
                            title: S.of(context).first_batch,
                            subtitle: '${renterModel.firstPayment ?? ''}',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Color(0xff3F342B).withValues(alpha: 0.25),
                                spreadRadius: 0,
                                blurRadius: 6,
                                offset:
                                    Offset(0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CacheHelper.getData(key: "lang") == "en"
                                    // ? Image.asset(
                                    //     "assets/images/sar.png",
                                    //     height: 23,
                                    //     width: 23,
                                    //     color: Color(0xff7E7E7E),
                                    //   )
                                    ? SvgPicture.asset(
                                        "assets/icons/sar.svg",
                                        width: 23,
                                        height: 23,
                                      )
                                    : Container(),
                                Text(
                                  S.of(context).renter_value + ' ',
                                  style: const TextStyle(
                                    color: Color(0xFF20262F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  "${NumberFormat('#,###').format(double.tryParse(renterModel.price ?? ''))} ",
                                  style: const TextStyle(
                                    color: Color(0xFF20262F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                CacheHelper.getData(key: "lang") == "ar"
                                    // ? Image.asset(
                                    //     "assets/images/sar.png",
                                    //     height: 23,
                                    //     width: 23,
                                    //     color: Color(0xff7E7E7E),
                                    //   )
                                    ? SvgPicture.asset(
                                        "assets/icons/sar.svg",
                                        width: 23,
                                        height: 23,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            S.of(context).renter_details,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        renterModel.description ?? '',
                        style: const TextStyle(
                          color: Color(0xFF263238),
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
                            if (renterModel.file != null &&
                                renterModel.file != '') {
                              print(renterModel.file);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PDFViewerPage(
                                    pdfUrl: renterModel.file!,
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
                            openGoogleMaps(double.parse(renterModel.lat ?? ''),
                                double.parse(renterModel.long ?? ''),
                                label: renterModel.title);
                          },
                          child: CustomProjectDetailsWidget(
                            image: "assets/icons/locationMap.svg",
                            title: S.of(context).open_project_location,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
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
                          if (quantity >= 0 &&
                              quantity < (renterModel.units ?? 0)) {
                            quantity++;
                            setState(() {});
                          }
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
                        quantity.toString(),
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
                          if (quantity > 0) {
                            quantity--;
                            setState(() {});
                          }
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
                  GestureDetector(
                    onTap: () async {
                      String loginMessage = local.pleaselogin;
                      bool isLoggedIn = await checkLoginStatus();
                      if (isLoggedIn) {
                        if (quantity == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(S.of(context).choose_num_unit)),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContractScreen(
                                    renterModel: renterModel,
                                    numOfUnits: quantity,
                                  )),
                        );
                      } else {
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
                                      fontSize: 12, color: Colors.black),
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
                              topRight: CacheHelper.getData(key: "lang") == "ar"
                                  ? Radius.circular(30)
                                  : Radius.circular(0),
                              topLeft: CacheHelper.getData(key: "lang") == "en"
                                  ? Radius.circular(30)
                                  : Radius.circular(0)),
                          color: Color(0xff20262F)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).own_now,
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

class OwnershipFeature extends StatelessWidget {
  const OwnershipFeature({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0xff3F342B).withValues(alpha: 0.25),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 10,
            ),
            Image.asset(
              icon,
              width: 20,
              height: 25,
              fit: BoxFit.scaleDown,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF20262F),
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF20262F),
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
