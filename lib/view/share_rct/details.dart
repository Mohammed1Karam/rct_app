import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/sar_image.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view-model/functions/check_token.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/view/auth/sendotp.dart';
import 'package:rct/view/share_rct/userdetails.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:share_plus/share_plus.dart';

import '../../common copounents/custom_text.dart';
import '../../common copounents/pdf_viewer_view.dart';
import '../../generated/l10n.dart';
import '../google maps/open_in_maps.dart';
import 'package:rct/shared_pref.dart';

import 'details_cubit.dart';
import 'details_repository.dart';
import 'details_state.dart';
import 'qualified_investor_bottom_sheet.dart';

class ShareDetails extends StatefulWidget {
  final String id;
  final bool isdeeplink;
  static String ScreenId = "/details";

  const ShareDetails({super.key, required this.id, this.isdeeplink = false});

  @override
  State<ShareDetails> createState() => _ShareDetailsState();
}

class _ShareDetailsState extends State<ShareDetails> {
  int countofchances = 0;
  int _selectedTabIndex = 0;
  int _currentImagePage = 0;
  bool? isLoggedIn;
  bool isQualifiedInvestor = false;
  late final ShareDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    countofchances = 1;
    isQualifiedInvestor = AppPreferences.getData(key: 'is_qualified_investor') ?? false;
    _cubit = ShareDetailsCubit(ShareDetailsRepository());
    _cubit.getOpportunityDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<ShareDetailsCubit, ShareDetailsState>(
            bloc: _cubit,
            builder: (context, state) {
              if (state is ShareDetailsSuccess) {
                return IconButton(
                  icon:  SvgPicture.asset("assets/icons/shareIcoin.svg"),
                  onPressed: () {
                    final deepLink = "$linkServerName/details/${state.product.id}";
                    Share.share("$deepLink : ${state.product.name}");
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: SafeArea(
        child: BlocProvider.value(
          value: _cubit,
          child: BlocListener<ShareDetailsCubit, ShareDetailsState>(
            listener: (context, state) {
              if (state is ShareDetailsInterestLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF20262F)),
                  ),
                );
              } else if (state is ShareDetailsInterestSuccess) {
                Navigator.pop(context); // Close loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is ShareDetailsInterestError) {
                Navigator.pop(context); // Close loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is ShareDetailsError) {
                if (state.message.contains('Unauthorized')) {
                  _showLoginDialog();
                }
              }
            },
            child: BlocBuilder<ShareDetailsCubit, ShareDetailsState>(
              builder: (context, state) {
                if (state is ShareDetailsLoading || state is ShareDetailsInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                } else if (state is ShareDetailsSuccess ||
                    state is ShareDetailsInterestLoading ||
                    state is ShareDetailsInterestSuccess ||
                    state is ShareDetailsInterestError) {
                  return BlocBuilder<ShareDetailsCubit, ShareDetailsState>(
                    buildWhen: (previous, current) => current is ShareDetailsSuccess,
                    builder: (context, state) {
                      if (state is ShareDetailsSuccess) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _displayImageSlider(MediaQuery.of(context).size.width,
                                  320.h, state.product),
                              SizedBox(
                                height: 20.h,
                              ),
                              _displayDetails(state.product)
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                } else if (state is ShareDetailsError) {
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
      ),
    );
  }

  Widget _displayImageSlider(double width, double height, Modelget product) {
    final images = [
      product.image1,
      if (product.image2 != null && product.image2 != "") product.image2,
      if (product.image3 != null && product.image3 != "") product.image3,
      if (product.image4 != null && product.image4 != "") product.image4,
    ].where((img) => img != null).toList();

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
                    child: Image.network(
                      image,
                      fit: BoxFit.fill,
                    ));
              }).toList(),
              options: CarouselOptions(
                  height: height,
                  autoPlay: false,
                  viewportFraction: 1,
                  onPageChanged: (page, _) {
                    setState(() {
                      _currentImagePage = page;
                    });
                  })),
          PositionedDirectional(
              bottom: 20,
              start: 0,
              end: 0,
              child: DotsIndicator(
                  dotsCount: images.isEmpty ? 1 : images.length,
                  position: _currentImagePage.toDouble(),
                  decorator: DotsDecorator(
                      size: const Size.square(8.0),
                      activeSize: const Size(40.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      activeColor: Colors.white,
                      color: const Color(0xFFE0E0E0)))),
          PositionedDirectional(
              top: 20,
              end: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 8.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: Colors.white),
                child: CustomText(
                  text: S.of(context).existing,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF20262F),
                      fontWeight: FontWeight.w600),
                ),
              ))
        ],
      ),
    );
  }

  Widget _displayDetails(Modelget product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: product.name,
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/location.svg",
                        width: 18.w,
                        height: 18.h,
                        colorFilter: const ColorFilter.mode(
                            Color(0xFF494949), BlendMode.srcIn)),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: CustomText(
                        text: product.location,
                        style: TextStyle(
                            fontSize: 12.sp, color: const Color(0xFF494949)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/opportunityHomeIcon.svg",
                        width: 18.w,
                        height: 18.h,
                        colorFilter: const ColorFilter.mode(
                            Color(0xFF494949), BlendMode.srcIn)),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: CustomText(
                        text: S.of(context).property_age_years(product.age.toString()),
                        style: TextStyle(
                            fontSize: 12.sp, color: const Color(0xFF494949)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 16.h),
          GridView(
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
                title: S.of(context).opportunity_price.replaceAll(":", ""),
                value: NumberFormat('#,###').format(
                    int.tryParse(product.opportunity_price ?? '0') ?? 0),
                iconPath: "assets/icons/tag.svg",
                showSar: true,
              ),
              _buildDetailCard(
                title: S.of(context).monthly_return,
                value: "${product.percent_number} %",
                iconPath: "assets/icons/discount-circle.svg",
                isSvg: true,
              ),
              _buildDetailCard(
                title: S.of(context).opportunityduration.replaceAll(":", ""),
                value: "${product.project_duration} ${S.of(context).month}",
                iconPath: "assets/icons/timer.svg",
              ),
              _buildDetailCard(
                title: S.of(context).total_value,
                value: NumberFormat('#,###')
                    .format(int.tryParse(product.total_price ?? '0') ?? 0),
                iconPath: "assets/icons/pocketMoney.svg",
                showSar: true,
              ),
            ],
          ),
          _buildOpportunityStatusBar(product),
          _buildTabs(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabContent(product),
              _buildGuaranteesSection(),
              _buildInvestmentSection(product),
              SizedBox(height: 32.h),
              _buildJoinNowButton(product),
              SizedBox(height: 32.h),
            ],
          ),
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
                text: local.guarantees_title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF20262F),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: local.guarantees_description,
            style: TextStyle(
              fontSize: 10.sp,
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
              _buildGuaranteeChip(local.guaranteed_returns),
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
              fontSize: 8.sp,
              color: const Color(0xFF3B82F6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinNowButton(Modelget product) {
    final local = S.of(context);
    final price = double.tryParse(product.opportunity_price.toString()) ?? 0;
    int remaining = (int.tryParse(product.opportunity_count.toString()) ?? 0) -
        (int.tryParse(product.number_opportunity_pay.toString()) ?? 0);
    bool isPending = product.status == "pending";
    double totalAmount = countofchances * price;
    bool isUpgradeRequired = totalAmount > 30000 && !isQualifiedInvestor;

    if (remaining <= 0) {
      return GestureDetector(
        onTap: () async {
          String? name = AppPreferences.getData(key: 'username');
          String? phone = AppPreferences.getData(key: 'phone');

          if (name != null && phone != null) {
            _cubit.registerInterest(name: name, phone: phone);
          } else {
            bool logged = await Checktoken().hasToken();
            if (logged) {
              // If logged in but data missing, maybe something is wrong or keys are different
              // But based on login.dart, these keys should be there.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(local.pleaselogin)),
              );
            } else {
              _showLoginDialog();
            }
          }
        },
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: const Color(0xFF20262F),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: CustomText(
              text: local.notify_me_future_opportunities,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: isPending && remaining > 0
          ? () async {
              if (isUpgradeRequired) {
                _showUpgradeBottomSheet(product);
                return;
              }
              bool logged = await Checktoken().hasToken();
              if (logged) {
                if (countofchances > 0 || isQualifiedInvestor) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostUserDetails(
                        id: widget.id,
                        countofchances: countofchances,
                        totalPrice: price * countofchances,
                        city: product.city_name != "" ? product.city_name : product.location,
                        district: product.district_name != "" ? product.district_name : product.location,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(local.choose_num_opportunity)),
                  );
                }
              } else {
                _showLoginDialog();
              }
            }
          : null,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: isPending && remaining > 0 ? const Color(0xFF20262F) : Colors.grey,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: CustomText(
            text: isUpgradeRequired
                ? local.upgrade_request
                : local.share_now,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void _showUpgradeBottomSheet(Modelget product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: QualifiedInvestorBottomSheet(
          opportunityId: widget.id,
          count: countofchances,
        ),
      ),
    );
  }

  void _showLoginDialog() {
    final local = S.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: Text(local.cancel, style: const TextStyle(fontSize: 12, color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SendOtp()));
            },
            child: Text(local.login, style: const TextStyle(fontSize: 12, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final local = S.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
      ),
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
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: BorderDirectional(
              end: BorderSide(color: isSelected?Color(0xFF0A3444):Colors.transparent,width: 2.sp)
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
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

  Widget _buildTabContent(Modelget product) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab(product);
      case 1:
        return _buildDocumentsTab(product);
      case 2:
        return _buildLocationTab(product);
      default:
        return _buildOverviewTab(product);
    }
  }

  Widget _buildOverviewTab(Modelget product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: product.description,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF494949),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsTab(Modelget product) {
    final local = S.of(context);
    return Column(
      children: [
        SizedBox(height: 20.h),
        if (product.file != null && product.file != '')
          _buildDocumentRow(local.executive_summary, product.file!),
        if (product.file2 != null && product.file2 != '')
          _buildDocumentRow(local.offering_document, product.file2!),
        if (product.file3 != null && product.file3 != '')
          _buildDocumentRow(local.open_project_file, product.file3!),
        if ((product.file == null || product.file == '') &&
            (product.file2 == null || product.file2 == '') &&
            (product.file3 == null || product.file3 == ''))
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: CustomText(
                text: local.file_not_found,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDocumentRow(String title, String url) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerPage(pdfUrl: url),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/document-text.svg",
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomText(
                  text: title,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF20262F),
                  ),
                ),
              ),
              Icon(
                Icons.file_download_outlined,
                color: const Color(0xFF8A8A8A),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationTab(Modelget product) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        SizedBox(
          height: 200.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(product.lat ?? 0, product.long ?? 0),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('property_location'),
                  position: LatLng(product.lat ?? 0, product.long ?? 0),
                ),
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: () {
            openGoogleMaps(
              product.lat ?? 0,
              product.long ?? 0,
              label: product.name,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                text: S.of(context).open_project_location,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3B82F6),
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.open_in_new,
                color: const Color(0xFF3B82F6),
                size: 18.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String value,
    required String iconPath,
    bool isSvg = true,
    bool showSar = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: isSvg
                ? SvgPicture.asset(
                    iconPath,
                    width: 20.w,
                    height: 20.h,
                    colorFilter: const ColorFilter.mode(Color(0xFF20262F), BlendMode.srcIn),
                  )
                : Image.asset(
                    iconPath,
                    width: 20.w,
                    height: 20.h,
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
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF8A8A8A),
                    fontWeight: FontWeight.w400,
                  ),
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
                          fontSize: 10.sp,
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

  Widget _buildOpportunityStatusBar(Modelget product) {
    final local = S.of(context);
    int total = int.tryParse(product.opportunity_count.toString()) ?? 0;
    int paid = int.tryParse(product.number_opportunity_pay.toString()) ?? 0;
    double progress = total > 0 ? paid / total : 0.0;
    int percent = (progress * 100).toInt();
    int remaining = total - paid;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: local.opportunity_status_title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF272727),
                ),
              ),
              CustomText(
                text: "$paid ${local.of_text} $total",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF272727),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white,
              color: const Color(0xFFFF8C00), // Orange
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "${local.remainingopportunities} $remaining",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color(0xFF494949),
                ),
              ),
              CustomText(
                text: "$percent% ${local.completed}",
                style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color(0xFF494949),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentSection(Modelget product) {
    final local = S.of(context);
    int total = int.tryParse(product.opportunity_count.toString()) ?? 0;
    int paid = int.tryParse(product.number_opportunity_pay.toString()) ?? 0;
    int remaining = total - paid;
    double oppPrice =
        double.tryParse(product.opportunity_price.toString()) ?? 0;
    double percent = double.tryParse(product.percent_number.toString()) ?? 0;

    bool isCompleted = remaining == 0;
    double totalAmount = isCompleted ? 0 : countofchances * oppPrice;
    double estimatedProfit = isCompleted
        ? 0
        : (totalAmount * (percent / 100)) *
            double.parse(product.project_duration.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: local.determine_investment_size,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF20262F),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFB),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCounterButton(
                    icon: Icons.remove,
                    onTap: isCompleted
                        ? null
                        : () {
                            if (countofchances > 1) {
                              setState(() {
                                countofchances--;
                              });
                            }
                          },
                  ),
                  Column(
                    children: [
                      CustomText(
                        text: isCompleted
                            ? "00"
                            : countofchances.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: isCompleted
                              ? const Color(0xFF8A8A8A)
                              : const Color(0xFF20262F),
                        ),
                      ),
                      CustomText(
                        text: local.opportunity,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF8A8A8A),
                        ),
                      ),
                    ],
                  ),
                  _buildCounterButton(
                    icon: Icons.add,
                    onTap: isCompleted
                        ? null
                        : () {
                            if (countofchances < remaining) {
                              setState(() {
                                countofchances++;
                              });
                            }
                          },
                  ),
                ],
              ),
              if (isCompleted)
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: CustomText(
                    text: local.investment_covered,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              SizedBox(height: 16.h),
             totalAmount > 30000
                 ? Padding(
                     padding: EdgeInsets.only(top: 16.h),
                     child: Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: EdgeInsets.only(top: 2.h),
                           child: SvgPicture.asset(
                             "assets/icons/warningIcon.svg",
                             width: 18.w,
                             height: 18.h,
                           ),
                         ),
                         SizedBox(width: 10.w),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               CustomText(
                                 text: local.max_investment_limit_q,
                                 style: TextStyle(
                                   fontSize: 10.sp,
                                   color: const Color(0xFFFF8C00),
                                   fontWeight: FontWeight.w600,
                                 ),
                                 textAlign: TextAlign.start,
                               ),
                               SizedBox(height: 4.h),
                               CustomText(
                                 text: local.max_investment_limit_info,
                                 style: TextStyle(
                                   fontSize: 8.sp,
                                   color: const Color(0xFF8A8A8A),
                                   fontWeight: FontWeight.w400,
                                 ),
                                 textAlign: TextAlign.start,
                               ),
                             ],
                           ),
                         ),
                       ],
                     ),
                   )
                 : const SizedBox(),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        _buildSummaryRow(
          title: local.total_amount,
          value: NumberFormat('#,###').format(totalAmount),
          textColor:
              isCompleted ? const Color(0xFF8A8A8A) : const Color(0xFF20262F),
        ),
        SizedBox(height: 16.h),
        _buildSummaryRow(
          title: local.total_profit,
          subtitle: local.during_months(product.project_duration.toString()),
          value: NumberFormat('#,###').format(estimatedProfit),
          textColor:
              isCompleted ? const Color(0xFF8A8A8A) : const Color(0xFF2E7D32),
          showTrend: !isCompleted,
        ),
      ],
    );
  }

  Widget _buildCounterButton({required IconData icon, VoidCallback? onTap}) {
    bool isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : const Color(0xFFF5F5F5),
          shape: BoxShape.circle,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Icon(icon,
            color: isEnabled ? const Color(0xFF20262F) : const Color(0xFFBDBDBD),
            size: 24.sp),
      ),
    );
  }

  Widget _buildSummaryRow({
    required String title,
    String? subtitle,
    required String value,
    required Color textColor,
    bool showTrend = false,
  }) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF20262F),
              ),
            ),
            if (subtitle != null)
              CustomText(
                text: subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8A8A8A),
                ),
              ),
          ],
        ),
        const Spacer(),
        if (showTrend) ...[
          Icon(Icons.trending_up, color: textColor, size: 20.sp),
          SizedBox(width: 8.w),
        ],
        CustomText(
          text: value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        SizedBox(width: 4.w),
        SarImage(color: textColor, height: 16.h),
      ],
    );
  }
}
