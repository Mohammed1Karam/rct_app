import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/real_estate/real_estate_cubit.dart';
import 'package:rct/view/home_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common copounents/custom_project_datails_widget.dart';
import '../../common copounents/pdf_viewer_view.dart';
import '../../common copounents/sar_image.dart';
import '../google maps/open_in_maps.dart';

class DetailsScreen extends StatefulWidget {
  String? id;

  DetailsScreen({super.key, required this.id, required bool isdeeplink});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int ind = 0;
  String phoneNumber = "+966569988788";

  final PageController _pageController = PageController();
  double? price;
  dynamic product;
  String? formattedCost;

  void initState() {
    checkLoginStatus();
    // if (context.read<DataCubit>().checkproduct(widget.id!) == false) {
    //   _fetchInitialData();
    // }
    List<Modelget> getdata = DataCubit.get(context).allDataList;

    product = getdata.firstWhere(
      (element) => element.id == widget.id,
      orElse: () => Modelget(id: ''),
    );
    price = double.tryParse(product.price.toString()) ?? 0.0;
    formattedCost = NumberFormat('#,###').format(price);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    await context.read<DataCubit>().fetchid("$linkHouses/${widget.id}");
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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
                                    "$linkServerName/${product.image1}",
                                    if (product.image2 != null)
                                      "$linkServerName/${product.image2}",
                                    if (product.image3 != null)
                                      "$linkServerName/${product.image3}",
                                    if (product.image4 != null)
                                      "$linkServerName/${product.image4}",
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
                                  "$linkServerName/${product.image1}",
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showImageDialog(
                                  [
                                    "$linkServerName/${product.image1}",
                                    if (product.image2 != null)
                                      "$linkServerName/${product.image2}",
                                    if (product.image3 != null)
                                      "$linkServerName/${product.image3}",
                                    if (product.image4 != null)
                                      "$linkServerName/${product.image4}",
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
                                      ? "$linkServerName/${product.image1}"
                                      : "$linkServerName/${product.image2}",
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showImageDialog(
                                  [
                                    "$linkServerName/${product.image1}",
                                    if (product.image2 != null)
                                      "$linkServerName/${product.image2}",
                                    if (product.image3 != null)
                                      "$linkServerName/${product.image3}",
                                    if (product.image4 != null)
                                      "$linkServerName/${product.image4}",
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
                                      ? "$linkServerName/${product.image1}"
                                      : "$linkServerName/${product.image3}",
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showImageDialog(
                                  [
                                    "$linkServerName/${product.image1}",
                                    if (product.image2 != null)
                                      "$linkServerName/${product.image2}",
                                    if (product.image3 != null)
                                      "$linkServerName/${product.image3}",
                                    if (product.image4 != null)
                                      "$linkServerName/${product.image4}",
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
                                      ? "$linkServerName/${product.image1}"
                                      : "$linkServerName/${product.image4}",
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                        PositionedDirectional(
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 4,
                      effect: const ExpandingDotsEffect(
                        dotWidth: 15,
                        dotHeight: 12,
                        dotColor: Colors.grey,
                        activeDotColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          "${product.house_type}",
                          style: const TextStyle(
                            color: Color(0xFF20262F),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        // Image.asset(
                        //   "assets/images/location.png",
                        //   scale: 1.2,
                        // ),
                        SvgPicture.asset("assets/icons/location.svg",width: 15,height: 15,),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          " ${product.city_name} - ",
                          style: const TextStyle(
                            color: Color(0xFF20262F),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "${product.district_name}",
                          style: const TextStyle(
                            color: Color(0xFF20262F),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            children: [
                              CacheHelper.getData(key: "lang") == "ar"
                                  ? SarImage(
                                height: 14,
                                color: primaryColor,
                              )
                                  : Container(),
                              Text(
                                "$formattedCost",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              CacheHelper.getData(key: "lang") == "en"
                                  ? SarImage(
                                height: 14,
                                color: primaryColor,
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                 /* const SizedBox(
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
                        SvgPicture.asset("assets/icons/locationMap.svg",width: 15,height: 20,),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap:
                              () {
                            openGoogleMaps(
                                double.parse(product.location.toString().split(',').first ?? ''),
                                double.parse(product.location.toString().split(',').last?? ''),
                                label:product.name);
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
                  ),*/
                  const SizedBox(
                    height: 9,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text.rich(
                      TextSpan(
                        text: local.license_number,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                          TextSpan(
                            text: " : "
                          ),
                          TextSpan(
                            text: product.real_estate_authority,
                            style: TextStyle(
                              color: Color(0xFF20262F),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ]
                      )
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          local.discreption,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "${product.description}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF20262F),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Image.network(
                          "$linkServerName/${product.barcode}",
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(

                            onTap: () async {
                              final Uri url = Uri.parse(
                                  "${product.real_estate_authority_link}");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text(
                              local.show_details,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
                              double.parse(product.location.toString().split(',').first ?? ''),
                              double.parse(product.location.toString().split(',').last?? ''),
                              label:product.name);
                        },
                        child: CustomProjectDetailsWidget(
                          image: "assets/icons/locationMap.svg",
                          title: S.of(context).open_project_location,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () async {
                      String deepLink =
                          "$linkServerName/product/${product.id}";
                      String message = " عرض عقاري: $deepLink";
                      final Uri whatsappUri = Uri(
                        scheme: 'https',
                        host: 'wa.me',
                        path: phoneNumber.replaceFirst('+', ''),
                        queryParameters: {
                          'text': message,
                        },
                      );

                      await launch(whatsappUri.toString());
                    },
                    child: Center(
                      child: Container(
                        height: 44.h,
                        width: MediaQuery.of(context).size.width/1.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xff20262F)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(local.contact_via_whatsapp,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Center(
                              child: Image.asset(
                                "assets/images/watsap222222.png",
                                height: 23,
                                width: 23,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
