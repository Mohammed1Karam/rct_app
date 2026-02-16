import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/designs/designs_cubit.dart';
import 'package:rct/view-model/cubits/order%20number/order_number_cubit.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';
import 'package:rct/view-model/cubits/sketches/sketches_cubit.dart';
import 'package:rct/view/auth/sendotp.dart';
import 'package:rct/view/designs%20and%20sketches/custom_designs_and_diagrams_screen.dart';
import 'package:rct/view/designs%20and%20sketches/designs_screen.dart';
import 'package:rct/view/designs%20and%20sketches/details_of_Sketch_Screen.dart';
import 'package:rct/view/designs%20and%20sketches/details_of_designs.dart';
import 'package:rct/view/designs%20and%20sketches/sketches_screen.dart';
import 'package:rct/view-model/cubits/favourite/favourite_cubit.dart';
import 'package:rct/view/home_screen.dart';

class DesignAndScreen extends StatefulWidget {
  const DesignAndScreen({super.key});

  @override
  State<DesignAndScreen> createState() => _DesignAndScreenState();
}

class _DesignAndScreenState extends State<DesignAndScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SketchesCubit>().loadSketches(context);
    context.read<DesignsCubit>().loadDesigns(context);
    context.read<FavouriteCubit>().getDesign();
    context.read<FavouriteCubit>().getSchema();
    context.read<FavouriteCubit>().fetchCombinedList();
  }

  Widget build(BuildContext context) {
    var local = S.of(context);
    List<String> items = [];
    var data = [];

    context.read<OrderNumberCubit>().fetchOrders();
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);

    return BlocConsumer<OrderNumberCubit, OrderNumberState>(
      listener: (context, state) {
        if (state is OrderNumberFailure) {
          // showSnackBar(context, state.errMessage, redColor);
        } else if (state is OrderNumberSuccess) {
          if (state.orderNumber.isEmpty) {
            // showSnackBar(context, local.noRequests, redColor);
          } else {
            data = state.orderNumber;
            items = data.map((map) => map["number"].toString()).toList();
            orderModel.orderNumbers = items;
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: BackButtonAppBar(context),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(constHorizontalPadding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              Container(
                                  width: double.infinity,
                                  child: Image.asset(
                                    "$imagePath/banner-photo.jpeg",
                                    fit: BoxFit.fill,
                                  )),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    CacheHelper.getData(key: "lang") == "en"
                                        ? "The best new designs and schemes with high quality"
                                        : "أفضل التصاميم والمخططات الجديدة وبجودة عالية",
                                    style: TextStyle(
                                        fontSize: 16.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(height: constVerticalPadding),
                    Text(
                      local.categories,
                      style: TextStyle(
                        fontSize: 12,
                        color: blackColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: constVerticalPadding),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              String loginMessage =
                                  local.pleaselogin; // Custom message
                              bool isLoggedIn =
                                  await checkLoginStatus(); // Check if the user is logged in

                              if (isLoggedIn) {
                                // If logged in, navigate to the ChooseBuildingType screen

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SketchesScreen(),
                                  ),
                                );
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(
                                          textAlign: TextAlign.center,
                                          loginMessage,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 109, 106, 106)),
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
                                              Spacer(),
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
                              decoration: BoxDecoration(
                                color: const Color(0xFF747171).withOpacity(0.3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      local.plans,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: blackColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Image.asset(
                                  "$iconsPath/fluent_building-home-24-regular.png",
                                  width: 30.w,
                                  height: 30.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constHorizontalPadding),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              String loginMessage =
                                  local.pleaselogin; // Custom message
                              bool isLoggedIn =
                                  await checkLoginStatus(); // Check if the user is logged in

                              if (isLoggedIn) {
                                // If logged in, navigate to the ChooseBuildingType screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DesignsScreen(),
                                  ),
                                );
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(
                                          textAlign: TextAlign.center,
                                          loginMessage,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 109, 106, 106)),
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
                                              Spacer(),
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
                              decoration: BoxDecoration(
                                color: const Color(0xFF0661E9).withOpacity(0.3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  local.designs,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(0xFF0661E9),
                                  ),
                                ),
                                leading: Image.asset(
                                  "$iconsPath/material-symbols_add-home-work.png",
                                  width: 30.w,
                                  height: 30.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: constVerticalPadding),
                    InkWell(
                      onTap: () async {
                        String loginMessage =
                            "يرجى تسجيل الدخول ."; // Custom message
                        bool isLoggedIn =
                            await checkLoginStatus(); // Check if the user is logged in

                        if (isLoggedIn) {
                          // If logged in, navigate to the ChooseBuildingType screen

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomDesignAndDiagramsScreen(),
                            ),
                          );
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                    textAlign: TextAlign.center,
                                    loginMessage,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: const Color.fromARGB(
                                            255, 109, 106, 106)),
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
                                        Spacer(),
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
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D8386).withOpacity(0.3),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Center(
                          child: ListTile(
                            titleAlignment: ListTileTitleAlignment.center,
                            title: Text(
                              local.customPlansAndDesigns,
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF2D8386),
                              ),
                            ),
                            leading: Image.asset(
                              "$iconsPath/Vector.png",
                              width: 30.w,
                              height: 30.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: constVerticalPadding),
                    Text(
                      local.favourite,
                      style: TextStyle(
                        fontSize: 13,
                        color: blackColor.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: constVerticalPadding),
                    if (isLoggedIn!)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: BlocBuilder<FavouriteCubit, DataState>(
                          builder: (context, state) {
                            return state is FavouriteLoading ||
                                    context
                                            .read<FavouriteCubit>()
                                            .favoritesModel ==
                                        null
                                ? SizedBox()
                                : context
                                            .read<FavouriteCubit>()
                                            .favoritesModel!
                                            .data!
                                            .sketch!
                                            .isEmpty &&
                                        context
                                            .read<FavouriteCubit>()
                                            .favoritesModel!
                                            .data!
                                            .design!
                                            .isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(50),
                                          child: Text(
                                            local.nospecial,
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          if (context
                                              .read<FavouriteCubit>()
                                              .favoritesModel!
                                              .data!
                                              .sketch!
                                              .isNotEmpty)
                                            GridView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: context
                                                  .read<FavouriteCubit>()
                                                  .favoritesModel!
                                                  .data!
                                                  .sketch!
                                                  .length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 8.0,
                                                mainAxisSpacing: 8.0,
                                                childAspectRatio: 0.8,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final item = context
                                                    .read<FavouriteCubit>()
                                                    .favoritesModel!
                                                    .data!
                                                    .sketch![index];
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsOfScetches(
                                                                productId: item
                                                                    .id
                                                                    .toString()),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 5,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            Expanded(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                                child: Image
                                                                    .network(
                                                                  "$linkServerName/${item.image}",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return const Icon(
                                                                      Icons
                                                                          .image,
                                                                      size: 50,
                                                                      color: Colors
                                                                          .grey,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                CacheHelper.getData(
                                                                            key:
                                                                                "lang") ==
                                                                        "ar"
                                                                    ? item.name!
                                                                            .ar ??
                                                                        ""
                                                                    : item.name!
                                                                            .en ??
                                                                        "",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          if (context
                                              .read<FavouriteCubit>()
                                              .favoritesModel!
                                              .data!
                                              .design!
                                              .isNotEmpty)
                                            GridView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: context
                                                  .read<FavouriteCubit>()
                                                  .favoritesModel!
                                                  .data!
                                                  .design!
                                                  .length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 8.0,
                                                mainAxisSpacing: 8.0,
                                                childAspectRatio: 0.8,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final item = context
                                                    .read<FavouriteCubit>()
                                                    .favoritesModel!
                                                    .data!
                                                    .design![index];
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsOfDesignsScreen(
                                                                productId: item
                                                                    .id
                                                                    .toString()),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 5,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            Expanded(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                                child: Image
                                                                    .network(
                                                                  "$linkServerName/${item.image}",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return const Icon(
                                                                      Icons
                                                                          .image,
                                                                      size: 50,
                                                                      color: Colors
                                                                          .grey,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                CacheHelper.getData(
                                                                            key:
                                                                                "lang") ==
                                                                        "ar"
                                                                    ? item.name!
                                                                            .ar ??
                                                                        ""
                                                                    : item.name!
                                                                            .en ??
                                                                        "",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                        ],
                                      );
                          },
                        ),
                      ),
                  ]),
            ),
//
          ),
        );
      },
    );
  }
}
