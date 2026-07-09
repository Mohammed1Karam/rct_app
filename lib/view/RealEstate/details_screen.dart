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
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common copounents/custom_project_datails_widget.dart';
import '../../common copounents/pdf_viewer_view.dart';
import '../../common copounents/sar_image.dart';
import '../google maps/open_in_maps.dart';
import 'details_cubit.dart';
import 'details_repository.dart';
import 'details_state.dart';

/*
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
  final String? id;
  final bool isdeeplink;

  DetailsScreen({super.key, required this.id, required this.isdeeplink});

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

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    _initData();
  }

  void _initData() async {
    final dataCubit = context.read<DataCubit>();
    if (dataCubit.checkproduct(widget.id ?? '')) {
      await _fetchInitialData();
    }
    _updateProductData();
  }

  void _updateProductData() {
    List<Modelget> getdata = DataCubit.get(context).allDataList;

    setState(() {
      product = getdata.firstWhere(
        (element) => element.id == widget.id,
        orElse: () => Modelget(id: ''),
      );
      price = double.tryParse(product.price.toString()) ?? 0.0;
      formattedCost = NumberFormat('#,###').format(price);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    await context.read<DataCubit>().fetchid("$linkServerName/api/houses/${widget.id}");
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
    if (product == null || product.id == '') {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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
                                  0,
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
                                  1,
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
                                  2,
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
                                  3,
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
                ],
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
    ValueNotifier<bool> isZoomed = ValueNotifier(false);

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
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 300,
                  height: 400,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isZoomed,
                    builder: (context, zoomed, child) {
                      return PageView.builder(
                        controller: pageController,
                        physics: zoomed
                            ? NeverScrollableScrollPhysics()
                            : AlwaysScrollableScrollPhysics(),
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onScaleStart: (_) => isZoomed.value = true,
                            onScaleEnd: (_) => isZoomed.value = false,
                            child: InteractiveViewer(
                              panEnabled: true,
                              boundaryMargin: EdgeInsets.all(20),
                              minScale: 1.0,
                              maxScale: 3.0,
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
*/




//new
class DetailsScreen extends StatefulWidget {
  final String? id;
  final bool isdeeplink;

  const DetailsScreen({super.key, required this.id, required this.isdeeplink});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final PageController _pageController = PageController();
  late final RealEstateDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = RealEstateDetailsCubit(RealEstateDetailsRepository());
    final id = widget.id ?? '';
    if (id.isNotEmpty) {
      _cubit.getPropertyDetails(id);
    }
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
      child: BlocBuilder<RealEstateDetailsCubit, RealEstateDetailsState>(
        builder: (context, state) {
          if (state is RealEstateDetailsLoading || state is RealEstateDetailsInitial) {
            return const Scaffold(backgroundColor: Colors.white,body: Center(child: CircularProgressIndicator()));
          }
          if (state is RealEstateDetailsError) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              ),
            );
          }
          if (state is RealEstateDetailsSuccess) {
            return _buildContent(context, state.product);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Modelget product) {
    final local = S.of(context);
    final images = _images(product);
    final rawPrice = product.price ?? product.total_price ?? '0';
    final formattedCost = NumberFormat('#,###').format(int.tryParse(rawPrice.toString()) ?? 0);

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
        body: SingleChildScrollView(
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
                            child: Image.network(images[index], fit: BoxFit.fill, width: double.infinity),
                          ),
                        );
                      },
                    ),
                    PositionedDirectional(
                      top: 30,
                      start: 5.w,
                      child: IconButton(
                        icon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                          child: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: images.length,
                  effect: const ExpandingDotsEffect(
                    dotWidth: 15,
                    dotHeight: 12,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "${product.house_type ?? product.name ?? ''}",
                  style: const TextStyle(
                    color: Color(0xFF20262F),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/location.svg", width: 15, height: 15),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "${product.city_name ?? ''} - ${product.district_name ?? ''}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF20262F),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          if (CacheHelper.getData(key: "lang") == "ar")
                            SarImage(height: 14, color: primaryColor),
                          Text(
                            formattedCost,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          if (CacheHelper.getData(key: "lang") == "en")
                            SarImage(height: 14, color: primaryColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text.rich(
                  TextSpan(
                    text: local.license_number,
                    style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w800),
                    children: [
                      const TextSpan(text: " : "),
                      TextSpan(
                        text: product.real_estate_authority ?? '',
                        style: const TextStyle(
                          color: Color(0xFF20262F),
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  local.discreption,
                  style: const TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "${product.description ?? ''}",
                  style: const TextStyle(color: Color(0xFF20262F), fontSize: 10, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((product.file ?? '').isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PDFViewerPage(pdfUrl: product.file!)),
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
                        double.tryParse(product.lat.toString()) ?? 0,
                        double.tryParse(product.long.toString()) ?? 0,
                        label: product.name,
                      );
                    },
                    child: CustomProjectDetailsWidget(
                      image: "assets/icons/locationMap.svg",
                      title: local.open_project_location,
                    ),
                  ),
                ],
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () async {
                      final deepLink = "$linkServerName/product/${product.id}";
                      final message = " عرض عقاري: $deepLink";
                      final uri = Uri(
                        scheme: 'https',
                        host: 'wa.me',
                        path: '966569988788',
                        queryParameters: {'text': message},
                      );
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    child: Center(
                      child: Container(
                        height: 44.h,
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xff20262F),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              local.contact_via_whatsapp,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(width: 10),
                            Image.asset(
                              "assets/images/watsap222222.png",
                              height: 23,
                              width: 23,
                              color: Colors.white,
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

  List<String> _images(Modelget product) {
    final values = [product.image1, product.image2, product.image3, product.image4]
        .where((e) => (e ?? '').toString().isNotEmpty)
        .map((e) => _normalizeUrl(e.toString()))
        .toList();
    return values.isEmpty ? ['https://via.placeholder.com/600x400'] : values;
  }

  String _normalizeUrl(String value) {
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return '$linkServerName/$value';
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
