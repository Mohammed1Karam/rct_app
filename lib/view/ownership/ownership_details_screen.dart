import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rct/model/renter_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/functions/file_picker.dart';
import 'package:rct/view/ownership/OwnerShipFeature2.dart';
import 'package:rct/view/ownership/contract_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../common copounents/custom_project_datails_widget.dart';
import '../../common copounents/pdf_viewer_view.dart';
import '../../constants/linkapi.dart';
import '../../generated/l10n.dart';
import '../auth/sendotp.dart';
import '../google maps/open_in_maps.dart';
import '../home_screen.dart';
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

class OwnershipDetailsScreen extends StatefulWidget {
  const OwnershipDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<OwnershipDetailsScreen> createState() => _OwnershipDetailsScreenState();
}

class _OwnershipDetailsScreenState extends State<OwnershipDetailsScreen> {
  final PageController _pageController = PageController();
  late final OwnershipDetailsCubit _cubit;
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _cubit = OwnershipDetailsCubit(OwnershipDetailsRepository());
    _cubit.getRenterDetails(widget.id);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<OwnershipDetailsCubit, OwnershipDetailsState>(
        builder: (context, state) {
          if (state is OwnershipDetailsInitial || state is OwnershipDetailsLoading) {
            return const Scaffold(backgroundColor: Colors.white,body: Center(child: CircularProgressIndicator()));
          }

          if (state is OwnershipDetailsError) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              ),
            );
          }

          if (state is OwnershipDetailsSuccess) {
            return _buildContent(context, state.renter);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, RenterModel renterModel) {
    final local = S.of(context);
    final images = _images(renterModel);
    final maxUnits = renterModel.units ?? 0;
    final formattedPrice =
        NumberFormat('#,###').format(double.tryParse(renterModel.price ?? '0') ?? 0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
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
                child: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            const Spacer(),
            IconButton(
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: const Icon(Icons.share, color: Colors.black),
              ),
              onPressed: () {
                if (renterModel.id != null) {
                  final deepLink = "$linkServerName/details/${renterModel.id}";
                  Share.share("$deepLink : ${local.renter}");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error: Unable to fetch product details")),
                  );
                }
              },
            ),
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
                          PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () => _showImageDialog(images, index, context),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(40),
                                    bottomLeft: Radius.circular(40),
                                  ),
                                  child: Image.network(
                                    images[index],
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: images.length,
                        effect: const ExpandingDotsEffect(
                          dotWidth: 10,
                          dotHeight: 8,
                          dotColor: Colors.grey,
                          activeDotColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        renterModel.title ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/icons/location.svg", width: 16, height: 17),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              "${renterModel.city ?? ''} - ${renterModel.district ?? ''}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF20262F),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/icons/homeSize.svg", width: 15, height: 15),
                          const SizedBox(width: 5),
                          Text(
                            "${renterModel.area ?? 0} م²",
                            style: const TextStyle(
                              color: Color(0xFF20262F),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset("assets/icons/bed.svg", width: 18, height: 22),
                          const SizedBox(width: 5),
                          Text(
                            "${renterModel.rooms ?? 0}",
                            style: const TextStyle(
                              color: Color(0xFF20262F),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset("assets/icons/bath.svg", width: 18, height: 20),
                          const SizedBox(width: 5),
                          Text(
                            "${renterModel.bathrooms ?? 0}",
                            style: const TextStyle(
                              color: Color(0xFF20262F),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OwnerShipFeature2(
                            icon: "assets/icons/chart.svg",
                            title: local.payment_plan,
                            subtitle: '${renterModel.paymentPlan ?? 0} ${local.year}',
                          ),
                          OwnerShipFeature2(
                            icon: "assets/icons/calendar.svg",
                            title: local.payment_duration,
                            subtitle: '${renterModel.paymentDuration ?? 0} ${local.month}',
                          ),
                          OwnerShipFeature2(
                            icon: "assets/icons/sides.svg",
                            title: local.num_of_units,
                            subtitle: '${renterModel.units ?? 0}',
                          ),
                          OwnerShipFeature2(
                            icon: "assets/icons/sar.svg",
                            title: local.first_batch,
                            subtitle: '${renterModel.firstPayment ?? 0}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff3F342B).withValues(alpha: 0.25),
                                spreadRadius: 0,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                if (CacheHelper.getData(key: "lang") == "en")
                                  SvgPicture.asset("assets/icons/sar.svg", width: 23, height: 23),
                                Text(
                                  '${local.renter_value} ',
                                  style: const TextStyle(
                                    color: Color(0xFF20262F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  "$formattedPrice ",
                                  style: const TextStyle(
                                    color: Color(0xFF20262F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                if (CacheHelper.getData(key: "lang") == "ar")
                                  SvgPicture.asset("assets/icons/sar.svg", width: 23, height: 23),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        local.renter_details,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((renterModel.file ?? '').isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PDFViewerPage(pdfUrl: renterModel.file!),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(local.file_not_found)),
                              );
                            }
                          },
                          child: CustomProjectDetailsWidget(
                            image: "assets/icons/pdf.svg",
                            title: local.open_project_file,
                            height: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            openGoogleMaps(
                              double.tryParse(renterModel.lat ?? '0') ?? 0,
                              double.tryParse(renterModel.long ?? '0') ?? 0,
                              label: renterModel.title,
                            );
                          },
                          child: CustomProjectDetailsWidget(
                            image: "assets/icons/locationMap.svg",
                            title: local.open_project_location,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (quantity >= 0 && quantity < maxUnits) {
                            setState(() => quantity++);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff20262F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(Icons.add, size: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          color: Color(0xff20262F),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          if (quantity > 0) {
                            setState(() => quantity--);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(Icons.remove, size: 24, color: Color(0xff20262F)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final isLoggedIn = await checkLoginStatus();
                      if (isLoggedIn) {
                        if (quantity == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(local.choose_num_unit)),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ContractScreen(
                              renterModel: renterModel,
                              numOfUnits: quantity,
                            ),
                          ),
                        );
                      } else {
                        _showLoginDialog(context, local);
                      }
                    },
                    child: Container(
                      height: 55.h,
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: CacheHelper.getData(key: "lang") == "ar"
                              ? const Radius.circular(30)
                              : Radius.zero,
                          topLeft: CacheHelper.getData(key: "lang") == "en"
                              ? const Radius.circular(30)
                              : Radius.zero,
                        ),
                        color: const Color(0xff20262F),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            local.own_now,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context, S local) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            local.alert,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
          content: Text(
            local.pleaselogin,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(local.cancel, style: const TextStyle(fontSize: 12, color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => SendOtp()),
                );
              },
              child: Text(local.login, style: const TextStyle(fontSize: 12, color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  List<String> _images(RenterModel model) {
    final values = [model.images1, model.images2, model.images3, model.images4]
        .where((e) => (e ?? '').toString().isNotEmpty)
        .map((e) => e.toString())
        .toList();
    return values.isEmpty ? ['https://via.placeholder.com/600x400'] : values;
  }

  void _showImageDialog(List<String> imageUrls, int initialIndex, BuildContext context) {
    final pageController = PageController(initialPage: initialIndex);
    final isZoomed = ValueNotifier(false);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 300,
                  height: 400,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isZoomed,
                    builder: (_, zoomed, __) {
                      return PageView.builder(
                        controller: pageController,
                        physics: zoomed
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        itemCount: imageUrls.length,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onScaleStart: (_) => isZoomed.value = true,
                            onScaleEnd: (_) => isZoomed.value = false,
                            child: InteractiveViewer(
                              panEnabled: true,
                              boundaryMargin: const EdgeInsets.all(20),
                              minScale: 1.0,
                              maxScale: 3.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(imageUrls[index], fit: BoxFit.fill),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SmoothPageIndicator(
                  controller: pageController,
                  count: imageUrls.length,
                  effect: const ExpandingDotsEffect(
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
