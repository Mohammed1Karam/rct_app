import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/sar_image.dart';
import 'package:rct/model/renter_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/functions/check_token.dart';
import 'package:rct/view/ownership/contract_screen.dart';

import '../../common copounents/custom_text.dart';
import '../../common copounents/pdf_viewer_view.dart';
import '../../generated/l10n.dart';
import '../auth/sendotp.dart';
import '../google maps/open_in_maps.dart';
import 'ownership_details_cubit.dart';
import 'ownership_details_repository.dart';
import 'ownership_details_state.dart';

/*
 Legacy implementation kept as comments (as requested).
 It was based on `RentersCubit` local list lookup, then rendered the same UI.
 The new active implementation below fetches by endpoint `/api/renters/{id}`.
*/

// class OwnershipDetailsScreen extends StatefulWidget {
//   OwnershipDetailsScreen({
//     super.key,
//     required this.id,
//   });
//   final String id;
//
//   @override
//   State<OwnershipDetailsScreen> createState() => _OwnershipDetailsScreenState();
// }
//
// class _OwnershipDetailsScreenState extends State<OwnershipDetailsScreen> {
//   int ind = 0;
//   final PageController _pageController = PageController();
//   int quantity = 0;
//   dynamic renterModel;
//
//   void initState() {
//     checkLoginStatus();
//     List<RenterModel>? data = context.read<RentersCubit>().allRenterList;
//     renterModel = data.firstWhere(
//       (element) => element.id.toString() == widget.id,
//       orElse: () => data.first,
//     );
//     super.initState();
//   }
//
//   fetchRenterData() async {
//     await RentersCubit.get(context).fetchUnAuthData("$linkServerName/api/renters");
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   // Legacy build had same layout:
//   // - top image PageView + SmoothPageIndicator
//   // - title, location, features, price card, description
//   // - file/map actions
//   // - quantity controls and own-now CTA
//   // - share and back actions
//   //
//   // NOTE:
//   // This block is intentionally left commented to preserve old logic.
//   // Active implementation starts below and uses OwnershipDetailsCubit + repository.
// }

/*
 Previous implementation commented out as requested.
*/

// class OwnershipDetailsScreen extends StatefulWidget {
//   const OwnershipDetailsScreen({super.key, required this.id});
//
//   final String id;
//
//   @override
//   State<OwnershipDetailsScreen> createState() => _OwnershipDetailsScreenState();
// }
//
// class _OwnershipDetailsScreenState extends State<OwnershipDetailsScreen> {
//   final PageController _pageController = PageController();
//   late final OwnershipDetailsCubit _cubit;
//   int quantity = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     checkLoginStatus();
//     _cubit = OwnershipDetailsCubit(OwnershipDetailsRepository());
//     _cubit.getRenterDetails(widget.id);
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _cubit.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _cubit,
//       child: BlocBuilder<OwnershipDetailsCubit, OwnershipDetailsState>(
//         builder: (context, state) {
//           if (state is OwnershipDetailsInitial || state is OwnershipDetailsLoading) {
//             return const Scaffold(backgroundColor: Colors.white,body: Center(child: CircularProgressIndicator()));
//           }
//
//           if (state is OwnershipDetailsError) {
//             return Scaffold(
//               body: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(state.message, textAlign: TextAlign.center),
//                 ),
//               ),
//             );
//           }
//
//           if (state is OwnershipDetailsSuccess) {
//             return _buildContent(context, state.renter);
//           }
//
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
//
//   Widget _buildContent(BuildContext context, RenterModel renterModel) {
//     final local = S.of(context);
//     final images = _images(renterModel);
//     final maxUnits = renterModel.units ?? 0;
//     final formattedPrice =
//         NumberFormat('#,###').format(double.tryParse(renterModel.price ?? '0') ?? 0);
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//         statusBarBrightness: Brightness.light,
//         systemNavigationBarColor: Colors.white,
//         systemNavigationBarIconBrightness: Brightness.dark,
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
//         floatingActionButton: Row(
//           children: [
//             IconButton(
//               icon: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
//                 child: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//             const Spacer(),
//             IconButton(
//               icon: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
//                 child: const Icon(Icons.share, color: Colors.black),
//               ),
//               onPressed: () {
//                 if (renterModel.id != null) {
//                   final deepLink = "$linkServerName/details/${renterModel.id}";
//                   Share.share("$deepLink : ${local.renter}");
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Error: Unable to fetch product details")),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * .47,
//                       child: Stack(
//                         children: [
//                           PageView.builder(
//                             controller: _pageController,
//                             itemCount: images.length,
//                             itemBuilder: (_, index) {
//                               return GestureDetector(
//                                 onTap: () => _showImageDialog(images, index, context),
//                                 child: ClipRRect(
//                                   borderRadius: const BorderRadius.only(
//                                     bottomRight: Radius.circular(40),
//                                     bottomLeft: Radius.circular(40),
//                                   ),
//                                   child: Image.network(
//                                     images[index],
//                                     fit: BoxFit.fill,
//                                     width: double.infinity,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Center(
//                       child: SmoothPageIndicator(
//                         controller: _pageController,
//                         count: images.length,
//                         effect: const ExpandingDotsEffect(
//                           dotWidth: 10,
//                           dotHeight: 8,
//                           dotColor: Colors.grey,
//                           activeDotColor: Colors.black,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Text(
//                         renterModel.title ?? '',
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Row(
//                         children: [
//                           SvgPicture.asset("assets/icons/location.svg", width: 16, height: 17),
//                           const SizedBox(width: 5),
//                           Flexible(
//                             child: Text(
//                               "${renterModel.city ?? ''} - ${renterModel.district ?? ''}",
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 color: Color(0xFF20262F),
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Row(
//                         children: [
//                           SvgPicture.asset("assets/icons/homeSize.svg", width: 15, height: 15),
//                           const SizedBox(width: 5),
//                           Text(
//                             "${renterModel.area ?? 0} م²",
//                             style: const TextStyle(
//                               color: Color(0xFF20262F),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w300,
//                               ),
//                           ),
//                           const SizedBox(width: 5),
//                           SvgPicture.asset("assets/icons/bed.svg", width: 18, height: 22),
//                           const SizedBox(width: 5),
//                           Text(
//                             "${renterModel.rooms ?? 0}",
//                             style: const TextStyle(
//                               color: Color(0xFF20262F),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w300,
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           SvgPicture.asset("assets/icons/bath.svg", width: 18, height: 20),
//                           const SizedBox(width: 5),
//                           Text(
//                             "${renterModel.bathrooms ?? 0}",
//                             style: const TextStyle(
//                               color: Color(0xFF20262F),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w300,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           OwnerShipFeature2(
//                             icon: "assets/icons/chart.svg",
//                             title: local.payment_plan,
//                             subtitle: '${renterModel.paymentPlan ?? 0} ${local.year}',
//                           ),
//                           OwnerShipFeature2(
//                             icon: "assets/icons/calendar.svg",
//                             title: local.payment_duration,
//                             subtitle: '${renterModel.paymentDuration ?? 0} ${local.month}',
//                           ),
//                           OwnerShipFeature2(
//                             icon: "assets/icons/sides.svg",
//                             title: local.num_of_units,
//                             subtitle: '${renterModel.units ?? 0}',
//                           ),
//                           OwnerShipFeature2(
//                             icon: "assets/icons/sar.svg",
//                             title: local.first_batch,
//                             subtitle: '${renterModel.firstPayment ?? 0}',
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color(0xff3F342B).withValues(alpha: 0.25),
//                                 spreadRadius: 0,
//                                 blurRadius: 6,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 if (CacheHelper.getData(key: "lang") == "en")
//                                   SvgPicture.asset("assets/icons/sar.svg", width: 23, height: 23),
//                                 Text(
//                                   '${local.renter_value} ',
//                                   style: const TextStyle(
//                                     color: Color(0xFF20262F),
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                 ),
//                                 Text(
//                                   "$formattedPrice ",
//                                   style: const TextStyle(
//                                     color: Color(0xFF20262F),
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                 ),
//                                 if (CacheHelper.getData(key: "lang") == "ar")
//                                   SvgPicture.asset("assets/icons/sar.svg", width: 23, height: 23),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Text(
//                         local.renter_details,
//                         style: const TextStyle(
//                           color: Colors.blue,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Text(
//                         renterModel.description ?? '',
//                         style: const TextStyle(
//                           color: Color(0xFF263238),
//                           fontSize: 10,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             if ((renterModel.file ?? '').isNotEmpty) {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => PDFViewerPage(pdfUrl: renterModel.file!),
//                                 ),
//                               );
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text(local.file_not_found)),
//                               );
//                             }
//                           },
//                           child: CustomProjectDetailsWidget(
//                             image: "assets/icons/pdf.svg",
//                             title: local.open_project_file,
//                             height: 16,
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             openGoogleMaps(
//                               double.tryParse(renterModel.lat ?? '0') ?? 0,
//                               double.tryParse(renterModel.long ?? '0') ?? 0,
//                               label: renterModel.title,
//                             );
//                           },
//                           child: CustomProjectDetailsWidget(
//                             image: "assets/icons/locationMap.svg",
//                             title: local.open_project_location,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//             SafeArea(
//               top: false,
//               child: Row(
//                 children: [
//                   const SizedBox(width: 15),
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           if (quantity >= 0 && quantity < maxUnits) {
//                             setState(() => quantity++);
//                           }
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: const Color(0xff20262F),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child: Icon(Icons.add, size: 24, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         quantity.toString(),
//                         style: const TextStyle(
//                           color: Color(0xff20262F),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       GestureDetector(
//                         onTap: () {
//                           if (quantity > 0) {
//                             setState(() => quantity--);
//                           }
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: const Color(0xffF8F8F8),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child: Icon(Icons.remove, size: 24, color: Color(0xff20262F)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () async {
//                       final isLoggedIn = await checkLoginStatus();
//                       if (isLoggedIn) {
//                         if (quantity == 0) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(local.choose_num_unit)),
//                           );
//                           return;
//                         }
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => ContractScreen(
//                               renterModel: renterModel,
//                               numOfUnits: quantity,
//                             ),
//                           ),
//                         );
//                       } else {
//                         _showLoginDialog(context, local);
//                       }
//                     },
//                     child: Container(
//                       height: 55.h,
//                       padding: EdgeInsets.symmetric(horizontal: 30.w),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topRight: CacheHelper.getData(key: "lang") == "ar"
//                               ? const Radius.circular(30)
//                               : Radius.zero,
//                           topLeft: CacheHelper.getData(key: "lang") == "en"
//                               ? const Radius.circular(30)
//                               : Radius.zero,
//                         ),
//                         color: const Color(0xff20262F),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             local.own_now,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showLoginDialog(BuildContext context, S local) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: Text(
//             local.alert,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
//           ),
//           content: Text(
//             local.pleaselogin,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 12, color: Colors.black),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(),
//               child: Text(local.cancel, style: const TextStyle(fontSize: 12, color: Colors.black)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => SendOtp()),
//                 );
//               },
//               child: Text(local.login, style: const TextStyle(fontSize: 12, color: Colors.black)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   List<String> _images(RenterModel model) {
//     final values = [model.images1, model.images2, model.images3, model.images4]
//         .where((e) => (e ?? '').toString().isNotEmpty)
//         .map((e) => e.toString())
//         .toList();
//     return values.isEmpty ? ['https://via.placeholder.com/600x400'] : values;
//   }
//
//   void _showImageDialog(List<String> imageUrls, int initialIndex, BuildContext context) {
//     final pageController = PageController(initialPage: initialIndex);
//     final isZoomed = ValueNotifier(false);
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   width: 300,
//                   height: 400,
//                   child: ValueListenableBuilder<bool>(
//                     valueListenable: isZoomed,
//                     builder: (_, zoomed, __) {
//                       return PageView.builder(
//                         controller: pageController,
//                         physics: zoomed
//                             ? const NeverScrollableScrollPhysics()
//                             : const AlwaysScrollableScrollPhysics(),
//                         itemCount: imageUrls.length,
//                         itemBuilder: (_, index) {
//                           return GestureDetector(
//                             onScaleStart: (_) => isZoomed.value = true,
//                             onScaleEnd: (_) => isZoomed.value = false,
//                             child: InteractiveViewer(
//                               panEnabled: true,
//                               boundaryMargin: const EdgeInsets.all(20),
//                               minScale: 1.0,
//                               maxScale: 3.0,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(15),
//                                 child: Image.network(imageUrls[index], fit: BoxFit.fill),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 SmoothPageIndicator(
//                   controller: pageController,
//                   count: imageUrls.length,
//                   effect: const ExpandingDotsEffect(
//                     dotColor: Colors.grey,
//                     activeDotColor: Colors.black,
//                     dotHeight: 8,
//                     dotWidth: 8,
//                     expansionFactor: 3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

/*
 New Implementation matching ShareDetails design.
*/

class OwnershipDetailsScreen extends StatefulWidget {
  final String id;
  static String ScreenId = "/ownership-details";

  const OwnershipDetailsScreen({super.key, required this.id});

  @override
  State<OwnershipDetailsScreen> createState() => _OwnershipDetailsScreenState();
}

class _OwnershipDetailsScreenState extends State<OwnershipDetailsScreen> {
  int quantity = 1;
  int _selectedTabIndex = 0;
  int _currentImagePage = 0;
  late final OwnershipDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OwnershipDetailsCubit(OwnershipDetailsRepository());
    _cubit.getRenterDetails(widget.id);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocProvider.value(
          value: _cubit,
          child: BlocBuilder<OwnershipDetailsCubit, OwnershipDetailsState>(
            builder: (context, state) {
              if (state is OwnershipDetailsLoading || state is OwnershipDetailsInitial) {
                return const Center(child: CircularProgressIndicator(color: Colors.black));
              } else if (state is OwnershipDetailsSuccess) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _displayImageSlider(MediaQuery.of(context).size.width, 320.h, state.renter),
                      SizedBox(height: 20.h),
                      _displayDetails(state.renter)
                    ],
                  ),
                );
              } else if (state is OwnershipDetailsError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(state.message, textAlign: TextAlign.center),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _displayImageSlider(double width, double height, RenterModel renter) {
    final images = [renter.images1, renter.images2, renter.images3, renter.images4]
        .where((e) => (e ?? '').toString().isNotEmpty)
        .map((e) => e.toString())
        .toList();

    if (images.isEmpty) images.add('https://via.placeholder.com/600x400');

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          CarouselSlider(
            items: images.map((image) {
              return SizedBox(
                width: width,
                height: height,
                child: Image.network(image, fit: BoxFit.fill),
              );
            }).toList(),
            options: CarouselOptions(
              height: height,
              autoPlay: false,
              viewportFraction: 1,
              onPageChanged: (page, _) {
                setState(() => _currentImagePage = page);
              },
            ),
          ),
          PositionedDirectional(
            bottom: 20,
            start: 0,
            end: 0,
            child: DotsIndicator(
              dotsCount: images.length,
              position: _currentImagePage.toDouble(),
              decorator: DotsDecorator(
                size: const Size.square(8.0),
                activeSize: const Size(40.0, 9.0),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                activeColor: Colors.white,
                color: const Color(0xFFE0E0E0),
              ),
            ),
          ),
          PositionedDirectional(
            top: 20,
            start: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayDetails(RenterModel renter) {
    final local = S.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: renter.title,
            style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              SvgPicture.asset("assets/icons/location.svg",
                  width: 18.w, height: 18.h, colorFilter: const ColorFilter.mode(Color(0xFF494949), BlendMode.srcIn)),
              SizedBox(width: 6.w),
              Expanded(
                child: CustomText(
                  text: "${renter.city ?? ''} - ${renter.district ?? ''}",
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF494949)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Stats Row: Area, Bathrooms, Rooms
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("${renter.area ?? 0} م²", "assets/icons/homeSize.svg"),
              _buildStatItem("${renter.bathrooms ?? 0} حمام", "assets/icons/bath.svg"),
              _buildStatItem("${renter.rooms ?? 0} غرف", "assets/icons/bed.svg"),
            ],
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: local.description,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: const Color(0xFF20262F)),
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: renter.description,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF494949), height: 1.5),
          ),
          _buildTabs(),
          _buildTabContent(renter),
          _buildGuaranteesSection(),
          SizedBox(height: 24.h),
          _buildInvestmentSection(renter),
          SizedBox(height: 32.h),
          _buildOwnNowButton(renter),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildGuaranteesSection() {
    final local = S.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: const Color(0xFF3B82F6),
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: local.ownership_guarantees_title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF20262F),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: local.ownership_guarantees_description,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF494949),
              height: 1.6,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            alignment: WrapAlignment.start,
            children: [
              _buildGuaranteeChip(local.direct_ownership),
              _buildGuaranteeChip(local.full_transparency),
              _buildGuaranteeChip(local.no_hidden_fees),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, color: const Color(0xFF3B82F6), size: 14.sp),
          SizedBox(width: 4.w),
          CustomText(
            text: text,
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xFF3B82F6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String text, String iconPath) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, width: 16.w, height: 16.h, colorFilter: const ColorFilter.mode(Color(0xFF494949), BlendMode.srcIn)),
        SizedBox(width: 4.w),
        CustomText(text: text, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF494949))),
      ],
    );
  }

  Widget _buildTabs() {
    final local = S.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          _buildTabItem(0, local.overview),
          _buildTabItem(1, local.documents),
          _buildTabItem(2, local.location),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: BorderDirectional(end: BorderSide(color: isSelected?Color(0xFF0A3444):Colors.transparent,width: 2.sp)),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
          child: Center(
            child: CustomText(
              text: title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? const Color(0xFF20262F) : const Color(0xFF8A8A8A),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(RenterModel renter) {
    switch (_selectedTabIndex) {
      case 0: return _buildOverviewTab(renter);
      case 1: return _buildDocumentsTab(renter);
      case 2: return _buildLocationTab(renter);
      default: return _buildOverviewTab(renter);
    }
  }

  Widget _buildOverviewTab(RenterModel renter) {
    final local = S.of(context);
    final formattedPrice = NumberFormat('#,###').format(double.tryParse(renter.price ?? '0') ?? 0);
    final formattedFirstPayment = NumberFormat('#,###').format(double.tryParse(renter.firstPayment ?? '0') ?? 0);
    final formattedPlan = NumberFormat('#,###').format(renter.paymentPlan ?? 0);

    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1.8,
      ),
      children: [
        _buildDetailCard(
          title: local.first_batch,
          value: formattedFirstPayment,
          iconPath: "assets/icons/money-recive.svg",
          showSar: true,
        ),
        _buildDetailCard(
          title: CacheHelper.getData(key: "lang") == "ar" ? "خطة السداد" : local.payment_plan,
          value: "$formattedPlan ${CacheHelper.getData(key: "lang") == "ar" ? "شهرياً" : "Monthly"}",
          iconPath: "assets/icons/calendar.svg",
        ),
        _buildDetailCard(
          title: CacheHelper.getData(key: "lang") == "ar" ? "مدة السداد" : local.payment_duration,
          value: "${renter.paymentDuration ?? 0} ${local.year}",
          iconPath: "assets/icons/timer.svg",
        ),
        _buildDetailCard(
          title: local.renter_value,
          value: formattedPrice,
          iconPath: "assets/icons/pocketMoney.svg",
          showSar: true,
        ),

      ],
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String value,
    required String iconPath,
    bool showSar = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(Color(0xFF20262F), BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: title,
                  style: TextStyle(fontSize: 10.sp, color: const Color(0xFF8A8A8A)),
                ),
                SizedBox(height: 2.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      if (showSar && CacheHelper.getData(key: "lang") == "en") ...[
                        SarImage(color: const Color(0xFF20262F), height: 12.h),
                        SizedBox(width: 4.w),
                      ],
                      CustomText(
                        text: value,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF20262F),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (showSar && CacheHelper.getData(key: "lang") != "en") ...[
                        SizedBox(width: 4.w),
                        SarImage(color: const Color(0xFF20262F), height: 12.h),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(RenterModel renter) {
    final local = S.of(context);
    return Column(
      children: [
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: () {
            if (renter.file != null && renter.file != '') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PDFViewerPage(pdfUrl: renter.file!)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(local.file_not_found)));
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: const Color(0xFFEEEEEE))),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/pdf.svg", width: 24.w, height: 24.h),
                SizedBox(width: 12.w),
                CustomText(text: local.open_project_file, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF20262F))),
                const Spacer(),
                Icon(Icons.file_download_outlined, color: const Color(0xFF8A8A8A), size: 24.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationTab(RenterModel renter) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        SizedBox(
          height: 200.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(double.tryParse(renter.lat ?? '0') ?? 0, double.tryParse(renter.long ?? '0') ?? 0), zoom: 15),
              markers: {Marker(markerId: const MarkerId('property_location'), position: LatLng(double.tryParse(renter.lat ?? '0') ?? 0, double.tryParse(renter.long ?? '0') ?? 0))},
              myLocationButtonEnabled: false, zoomControlsEnabled: false,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: () => openGoogleMaps(double.tryParse(renter.lat ?? '0') ?? 0, double.tryParse(renter.long ?? '0') ?? 0, label: renter.title),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(text: S.of(context).open_project_location, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6))),
              SizedBox(width: 6.w),
              Icon(Icons.open_in_new, color: const Color(0xFF3B82F6), size: 18.sp),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentSection(RenterModel renter) {
    final local = S.of(context);
    final maxUnits = renter.units ?? 0;
    final price = double.tryParse(renter.price ?? '0') ?? 0;
    final totalAmount = quantity * price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: local.num_of_units, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF20262F))),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(color: const Color(0xFFFBFBFB), borderRadius: BorderRadius.circular(16.r)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCounterButton(icon: Icons.remove, onTap: () { if (quantity > 1) setState(() => quantity--); }),
                  Column(
                    children: [
                      CustomText(text: quantity.toString().padLeft(2, '0'), style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: const Color(0xFF20262F))),
                      CustomText(text: local.num_of_units, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF8A8A8A))),
                    ],
                  ),
                  _buildCounterButton(icon: Icons.add, onTap: () { if (quantity < maxUnits) setState(() => quantity++); }),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: local.total_value, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF20262F))),
            Row(
              children: [
                CustomText(text: NumberFormat('#,###').format(totalAmount), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF20262F))),
                SizedBox(width: 4.w),
                SarImage(color: const Color(0xFF20262F), height: 16.h),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w, height: 48.h,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Icon(icon, color: const Color(0xFF20262F), size: 24.sp),
      ),
    );
  }

  Widget _buildOwnNowButton(RenterModel renter) {
    final local = S.of(context);
    return MainButton(
      width: double.infinity,
      height: 56,
      radius: 12,
      fontSize: 14.sp,
      backGroundColor: const Color(0xFF20262F),
      text: local.own_now,
      onTap: () async {
        final isLoggedIn = await Checktoken().hasToken();
        if (isLoggedIn) {
          if (quantity > 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ContractScreen(renterModel: renter, numOfUnits: quantity)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(local.choose_num_unit)));
          }
        } else {
          _showLoginDialog();
        }
      },
    );
  }

  void _showLoginDialog() {
    final local = S.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(local.alert, textAlign: TextAlign.center),
        content: Text(local.pleaselogin, textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(local.cancel, style: const TextStyle(color: Colors.black))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SendOtp()));
            },
            child: Text(local.login, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
