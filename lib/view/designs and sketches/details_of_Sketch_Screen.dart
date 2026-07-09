import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/sketches/sketches_state.dart';
import 'package:rct/view/designs%20and%20sketches/sketches_form_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rct/l10n/app_localizations.dart';
import '../../view-model/cubits/sketches/sketches_cubit.dart';

// ignore: must_be_immutable
class DetailsOfScetches extends StatefulWidget {
  String? productId;

  DetailsOfScetches({super.key, required this.productId});

  @override
  State<DetailsOfScetches> createState() => _DetailsOfScetchesState();
}

class _DetailsOfScetchesState extends State<DetailsOfScetches> {
  int ind = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  dynamic product;

  @override
  void initState() {
    super.initState();
    var data = context.read<SketchesCubit>().sketchesList;
    product = data.firstWhere(
      (element) => element["id"].toString() == widget.productId,
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

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .45,
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
                        _buildImageView(
                            "$linkServerName/${product["image"]}", 0),
                        _buildImageView(
                          product["image1"] != null
                              ? "$linkServerName/${product["image1"]}"
                              : "$linkServerName/${product["image"]}",
                          1,
                        ),
                        _buildImageView(
                          product["image2"] != null
                              ? "$linkServerName/${product["image2"]}"
                              : "$linkServerName/${product["image"]}",
                          2,
                        ),
                        _buildImageView(
                          product["image3"] != null
                              ? "$linkServerName/${product["image3"]}"
                              : "$linkServerName/${product["image"]}",
                          3,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 25,
                      right:
                          CacheHelper.getData(key: "lang") == "ar" ? 4 : null,
                      left: CacheHelper.getData(key: "lang") == "ar" ? null : 4,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_sharp,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
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
              const SizedBox(height: 15),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            "${product['name']}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            local.discreption,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            maxLines: 2,
                            "${product["description"]}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Center(
                child: SafeArea(
                  child: MainButton(
                    text: local.completeRequest,
                    backGroundColor: primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SketchForm(
                            id: product["id"],
                            price: product["price"],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageView(String imageUrl, int index) {
    return GestureDetector(
      onTap: () => _showImageDialog(
        [
          "$linkServerName/${product["image"]}",
          product["image1"] != null
              ? "$linkServerName/${product["image1"]}"
              : "$linkServerName/${product["image"]}",
          product["image2"] != null
              ? "$linkServerName/${product["image2"]}"
              : "$linkServerName/${product["image"]}",
          product["image3"] != null
              ? "$linkServerName/${product["image3"]}"
              : "$linkServerName/${product["image"]}",
        ],
        index,
        context,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      ),
    );
  }
}
