import 'dart:convert';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/locale_provider.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/orders%20list/orders_list_cubit.dart';
import 'package:rct/view-model/cubits/real_estate/real_estate_cubit.dart';
import 'package:rct/view-model/functions/check_token.dart';
import 'package:rct/view/auth/sendotp.dart';

import 'package:rct/view/calculations%20and%20projects/measurment_of%20_villa.dart';
import 'package:rct/view/common_questions.dart';
import 'package:rct/view/favorite/main_favourite.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/aboutUs.dart';
import 'package:rct/view/final_orders/final-orders.dart';
import 'package:rct/main.dart';
import 'package:rct/view/CooperationandPartnership/choose_building_type.dart';
import 'package:rct/view/RealEstate/final_offers.dart';
import 'package:rct/view/calculations%20and%20projects/measurment_of_field_screen.dart';
import 'package:rct/view/designs%20and%20sketches/designs_and_screen.dart';
import 'package:rct/view/auth/edit_profile_screen.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_cubit.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_states.dart';
import 'package:rct/view/language_screen.dart';
import 'package:rct/view/notification/get_read%20count.dart';
import 'package:rct/view/notification/notifications_screen.dart';
import 'package:rct/view/notification/notifycubit.dart';
import 'package:rct/view/ownership/ownership_details_screen.dart';
import 'package:rct/view/ownership/ownership_screen.dart';
import 'package:rct/view/partener_success/cubit.dart';
import 'package:rct/view/partener_success/partners_screen.dart';
import 'package:rct/view/privacy_screen.dart';
import 'package:rct/view/share_rct/cubit.dart';
import 'package:rct/view/share_rct/details.dart';
import 'package:rct/view/share_rct/share_rct_empty_screen.dart';
import 'package:rct/view/share_rct/share_rct_home.dart';
import 'package:rct/view/support_screen.dart';
import 'package:rct/view/terms_conditions_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common copounents/custom_dialog.dart';
import '../generated/l10n.dart';
import 'package:rct/model/investor_status_model.dart';
import 'package:rct/view/share_rct/qualified_investor_bottom_sheet.dart';

import 'ownership/renters_cubit.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";

  const HomeScreen({Key? key, this.onInitDeepLink}) : super(key: key);

  final Function? onInitDeepLink;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  dynamic number = 0;
  dynamic image;
  bool isQualifiedInvestor = false;
  InvestorStatusModel? investorStatus;
  double hight = 130;
  String whatsapUrl = "https://wa.me/+966569988788";
  String emailUrl = "support@apprct.info";
  String twitterLink = "https://x.com/rctapplication";

  Future<void> _initializeOtherTasks() async {
    // _loadNameandiamge();
    checkLoginStatus();
    // _fetchUnreadCount();
    _checkLoginStatus();
    if (await checkLoginStatus()) {
      context.read<FinalOrdersCubit>().fetchInvestorStatus();
    }
  }

  void initState() {
    context.read<FinalOrdersCubit>().Users();
    context.read<ParetenerCubit>().fetchData();
    if (isLoggedIn) {
      context.read<DataCubit>().fetchData(linkHouses); // Fetch data
    } else {
      context.read<DataCubit>().fetchUnAuthData("$linkServerName/api/houses");
    }
    context.read<FinalOrdersCubit>().RawLand();
    FinalOrdersCubit.get(context).RealOrders();
    context.read<OrdersListCubit>().fetchOrderList();
    // fetchAboutUs();
    context.read<ShareCubit>().fetchAboutUs();
    context.read<ShareCubit>().fetchTermsConditions();
    context.read<ShareCubit>().fetchPrivacyList();

    context.read<FinalOrdersCubit>().DesignsAndScketches();

    context.read<FinalOrdersCubit>().stream.listen((state) {
      if (state is UserSucess) {
        setState(() {
          name = state.myName ?? '';
          image = state.myImage ??
              'https://via.placeholder.com/150';
          isQualifiedInvestor = state.isQualifiedInvestor ?? false;
        });
      } else if (state is InvestorStatusSuccess) {
        setState(() {
          investorStatus = state.investorStatus;
          isQualifiedInvestor = state.investorStatus.isQualifiedInvestor;
        });
      }
    });

    context.read<FinalOrdersCubit>().stream.listen((state) {
      if (state is UserSucess) {
        _loadNameandiamge();
      }
    });
    _initializeOtherTasks();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        int notificationId = Random().nextInt(1000000) + 10;
        debugPrint('$notificationId');
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: notificationId,
            channelKey: 'local notification key',
            displayOnBackground: true,
            displayOnForeground: true,
            title: message.notification!.title,
            body: message.notification!.body,
          ),
        );
      });
    });
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    context.read<FinalOrdersCubit>().Users();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AwesomeNotifications().setListeners(
          onActionReceivedMethod: (receivedAction) {
        ////here                  Routes.teacherNavbarPageRoute
        return Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      });
      // Ensure a Future<void> is returned
    });
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.getToken().then((token) {
      deviceToken = token;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.onInitDeepLink != null) {
        widget.onInitDeepLink!();
      }
    });

    final appLinks = AppLinks(); // AppLinks is singleton

    final sub = appLinks.uriLinkStream.listen((uri) {
      // Do something (navigation, ...)
      print('got uri: $uri');
      String id = uri.toString().split('/').last;
      String page = uri
          .toString()
          .split('/')
          .elementAt(uri.toString().split('/').length - 2);
      print('page: $page');
      if (page == "share") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ShareDetails(id: id)));
      } else if (page == "details") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OwnershipDetailsScreen(id: id)));
      }
    });
    super.initState();
  }

  bool isLoggedIn = false;

  Future<void> _loadNameandiamge() async {
    isLoggedIn = await checkLoginStatus();
    setState(() {
      name = AppPreferences.getData(key: 'myname') ?? '';
      image = AppPreferences.getData(key: 'myimage') ??
          'https://images.app.goo.gl/nZvnQQ58zj1YKVNu9';
      isQualifiedInvestor = AppPreferences.getData(key: 'is_qualified_investor') ?? false;

      // Provide a default name if none is saved
    });
  }

  bool loged = false;

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await checkLoginStatus();

    setState(() {
      loged = isLoggedIn;
    });
  }

  Future<void> _fetchUnreadCount() async {
    final count = await NotificationService().getUnreadCount();
    setState(() {
      number = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) => InkWell(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Image.asset(
                CacheHelper.getData(key: "lang") == "ar"
                    ? "$iconsPath/drawer-icon.png"
                    : "assets/images/drawewr2.png",
              ),
            ),
            onTap: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(" ${local.welcome} ${isLoggedIn ? name : ""}",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white)),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                number = 0;
              });
              context.read<NotificationCubit>().resetUnreadCount();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            child: loged
                ? Stack(
                    children: [
                      Icon(
                        number == 0 || number == "" || number == null
                            ? Icons.notifications_none
                            : Icons.notifications,
                        color: whiteBackGround,
                      ),
                      if (number != 0 && number != "" && number != null)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: const BoxConstraints(minWidth: 12),
                            child: Text(
                              "$number", // Ensure the number is a string
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight
                                    .w900, // Adjusted the font size for visibility
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  )
                : Container(),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      drawer: Drawer(
        backgroundColor: whiteBackGround,
        surfaceTintColor: whiteBackGround,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w, top: 50.h, bottom: 20.h),
              child: loged
                  ? BlocConsumer<FinalOrdersCubit, FinalOrdersStates>(
                      listener: (context, state) {
                        if (state is UserSucess) {
                          setState(() {
                            print(
                                "name -------------------------${state.users.first.name}");
                            name = state.users.first.name ?? "";
                            AppPreferences.saveData(
                                key: 'username',
                                value: state.users.first.name ?? "");
                            AppPreferences.saveData(
                                key: 'userIdentityNumber',
                                value: state.users.first.identity_number ?? "");
                            image =
                                "$linkServerName/${state.users.first.image}" ??
                                    "https://example.com/default-image.png";
                            isQualifiedInvestor = state.isQualifiedInvestor ?? false;
                          });
                        } else if (state is InvestorStatusSuccess) {
                          setState(() {
                            investorStatus = state.investorStatus;
                            isQualifiedInvestor = state.investorStatus.isQualifiedInvestor;
                          });
                        } else if (state is UserFaild) {
                          setState(() {
                            name = 'Default Name';
                            image = 'https://example.com/default-image.png';
                          });
                        }
                      },
                      builder: (context, state) {
                        if (state is UserLoading) {
                          return const Center();
                        }
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(image ?? ""),
                                radius: 40,
                              ),
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                  ),
                                  if (isQualifiedInvestor) ...[
                                    SizedBox(width: 5.w),
                                    SvgPicture.asset(
                                      "assets/icons/verifyIcon.svg",
                                      width: 7.w,
                                      height: 7.h,
                                    ),
                                  ]
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (investorStatus?.requestStatus == "pending")
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text(
                                        local.investor_request_pending,
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EditProfileScreen()),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text(
                                        local.editFile,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 13,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SendOtp()),
                          );
                        },
                        child: Text(
                          local.login,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(
                height: 1,
                thickness: .2,
                color: Colors.grey.shade400,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            loged == true
                ? Column(
                    children: [
                      ListTile(
                        leading: SizedBox(
                          width: 30.sp,
                          child: Center(
                            child: SvgPicture.asset("$iconsPath/3d-cube.svg"),
                          ),
                        ),
                        title: Text(
                          local.orders,
                          style: TextStyle(color: Color(0xFF20262F), fontSize: 10, fontWeight: FontWeight.w900),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FinalOrdersScreen(initialIndex: 0)));
                        },
                      ),
                      ListTile(
                        leading: SizedBox(
                          width: 30.sp,
                          child: Center(
                            child: SvgPicture.asset("$iconsPath/heart.svg"),
                          ),
                        ),
                        title: Text(
                          local.favorites,
                          style: TextStyle(fontSize: 10, color: Color(0xFF20262F), fontWeight: FontWeight.w900),
                        ),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainFavourites())),
                      ),
                    ],
                  )
                : Container(),
            ListTile(
              leading: SizedBox(
                width: 30.sp,
                child: Center(
                  child: SvgPicture.asset("$iconsPath/aboutUsIcon.svg"),
                ),
              ),
              title: Text(
                local.aboutUs,
                style: TextStyle(fontSize: 10, color: Color(0xFF20262F), fontWeight: FontWeight.w900),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUsScreen())),
            ),
            ListTile(
              leading: SizedBox(
                width: 30.sp,
                child: Center(
                  child: SvgPicture.asset("$iconsPath/lock.svg"),
                ),
              ),
              title: Text(
                local.privacyPolicy,
                style: TextStyle(fontSize: 10, color: Color(0xFF20262F), fontWeight: FontWeight.w900),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrivacysScreen())),
            ),
            ListTile(
              leading: SizedBox(
                width: 30.sp,
                child: Center(
                  child: SvgPicture.asset("$iconsPath/writing.svg"),
                ),
              ),
              title: Text(
                local.termsConditions,
                style: TextStyle(fontSize: 10, color: Color(0xFF20262F), fontWeight: FontWeight.w900),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen())),
            ),
            ListTile(
              leading: SizedBox(
                width: 30.sp,
                child: Center(
                  child: SvgPicture.asset("$iconsPath/customer-support.svg"),
                ),
              ),
              title: Text(
                local.support,
                style: TextStyle(fontSize: 10, color: Color(0xFF20262F), fontWeight: FontWeight.w900),
              ),
              onTap: () async {
                customDialog(
                  isDismissible: true,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /*Text(
                            local.support_time,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey),
                          ),*/
                          InkWell(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.call,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  local.call,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                            onTap: () async {
                              await launchUrl(Uri.parse('tel:+966569988788'));
                            },
                          ),
                          Divider(),
                          InkWell(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.email,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  local.email,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                            onTap: () async {
                              await launchUrl(Uri.parse('mailto:$emailUrl'));
                            },
                          ),
                          Divider(),
                          InkWell(
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/watsap222222.png",
                                  width: 25.w,
                                  height: 25.h,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  local.whatsapp_contact,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                            onTap: () async {
                              await launchUrlString(whatsapUrl);
                            },
                          ),
                          Divider(),
                          InkWell(
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/bx_support.png",
                                  width: 27.w,
                                  height: 27.h,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  local.support_and_assist,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SupportScreen(),
                                  ));
                            },
                          ),
                          Divider(),
                          InkWell(
                            child: Row(
                              children: [
                                Image.asset(
                                  "$iconsPath/icons8-twitter-50 (1).png",
                                  width: 25.w,
                                  height: 22.h,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  local.x,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                            onTap: () async {
                              await launchUrlString(twitterLink);
                            },
                          ),
                          Divider(),
                          InkWell(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.question_answer,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  local.common_questions,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommonQuestions(),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  context: context,
                );
              },
            ),
            ListTile(
              leading: SizedBox(
                width: 30.sp,
                child: Center(
                  child: SvgPicture.asset("$iconsPath/internet.svg"),
                ),
              ),
              title: Text(
                local.language,
                style: TextStyle(fontSize: 10, color: Color(0xFF20262F), fontWeight: FontWeight.w900),
              ),
              onTap: () async {
                if (CacheHelper.getData(key: "lang") == 'ar') {
                  await provider.setLocale(const Locale('en', 'US'));
                  appLocale.value = 'en';
                } else {
                  await provider.setLocale(const Locale('ar', 'SA'));
                  appLocale.value = 'ar';
                }

                // Refresh data for ShareRct and OwnershipScreen
                context
                    .read<ShareCubit>()
                    .fetchShare('$linkServerName/api/opportunities');
                context
                    .read<RentersCubit>()
                    .fetchUnAuthData("$linkServerName/api/renters");

                context.read<ShareCubit>().fetchAboutUs();
                context.read<ShareCubit>().fetchTermsConditions();
                context.read<ShareCubit>().fetchPrivacyList();
                context.read<FinalOrdersCubit>().Users();
                context.read<FinalOrdersCubit>().ShareRct();
                context
                    .read<ShareCubit>()
                    .fetchShare('$linkServerName/api/opportunities');
                if (isLoggedIn) {
                  context.read<DataCubit>().fetchData(linkHouses); // Fetch data
                } else {
                  context
                      .read<DataCubit>()
                      .fetchUnAuthData("$linkServerName/api/houses");
                }

                context.read<FinalOrdersCubit>().RawLand();
                FinalOrdersCubit.get(context).RealOrders();
                context.read<OrdersListCubit>().fetchOrderList();
                context.read<ParetenerCubit>().fetchData();
              },
            ),
            loged
                ? Column(
              children: [
                ListTile(
                  leading: SizedBox(
                    width: 30.sp,
                    child: Center(
                      child: SvgPicture.asset("${iconsPath}/delete_account.svg"),
                    ),
                  ),
                  title: Text(
                    local.deleteAccount,
                    style: TextStyle(color: Color(0xFFFF0000), fontSize: 10, fontWeight: FontWeight.w900),
                  ),
                  onTap: () async {
                    await deleteAccount(context);
                  },
                ),
              ],
            )
                : Container(),
            loged
                ? Column(
                    children: [
                      ListTile(
                        leading: SizedBox(
                          width: 30.sp,
                          child: Center(
                            child: SvgPicture.asset("$iconsPath/logout.svg"),
                          ),
                        ),
                        title: Text(
                          local.logout,
                          style: TextStyle(color: Color(0xFFFF0000), fontSize: 10, fontWeight: FontWeight.w900),
                        ),
                        onTap: () async {
                          setState(() { name = ""; });
                          await AppPreferences.saveData(key: 'myname', value: "");
                          await secureStorage.deleteAll();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                        },
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),

      //************************************************ */
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(
                        30,
                      ),
                      bottomLeft: Radius.circular(
                        30,
                      )),
                  color: primaryColor),
            ),
          ),
          Positioned.fill(
            top: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      "$iconsPath/logo_without_text-icon.png",
                      height: 130.h,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: () async {
                              try {
                                bool isLoggedIn = await checkLoginStatus();
                                print(isLoggedIn);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OwnershipScreen(),
                                  ),
                                );
                              } on Exception catch (e) {
                                print(e);
                              }
                            },
                            child: SizedBox(
                              height:
                                  hight, // Ensure 'height' is correctly defined
                              child: Card(
                                color: whiteBackGround,
                                margin: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      S.of(context).renter,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    leading: SvgPicture.asset(
                                      "assets/images/icon-06-2.svg",
                                      width: 50,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              bool isLoggedIn = await checkLoginStatus();
                              print(isLoggedIn);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ShareRct(
                                    url: '$linkServerName/api/opportunities',
                                    isLoggedIn: isLoggedIn,
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height:
                                  hight, // Ensure 'height' is correctly defined
                              child: Card(
                                color: whiteBackGround,
                                margin: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      local.joinRCT,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    leading: Image.asset(
                                      "assets/images/pana.jpg",
                                      width: 50,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          /*InkWell(
                            onTap: () async {
                              // If logged in, navigate to the ChooseBuildingType screen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ChooseBuildingType(),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: hight, // Ensure 'height' is correctly defined
                              child: Card(
                                color: whiteBackGround,
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      local.cooperationAndPartnership,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                                    ),
                                    leading: Image.asset(
                                      "assets/images/CooperationandPartnership.png",
                                      width: 50,
                                    ),
                                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),*/
                          InkWell(
                            onTap: () async {
                              try {
                                bool isLoggedIn = await checkLoginStatus();
                                print(isLoggedIn);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FinalOffers(
                                          url: isLoggedIn
                                              ? linkHouses
                                              : "$linkServerName/api/houses",
                                        )));
                              } on Exception catch (e) {
                                print(e);
                              }
                            },
                            child: SizedBox(
                              height: hight,
                              child: Card(
                                color: whiteBackGround,
                                margin: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      local.realestate,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    leading: Image.asset(
                                      "assets/images/cuate.png",
                                      width: 50,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),

// Replace with actual logic to check if the user is logged in

                          SizedBox(
                            height: hight,
                            child: Card(
                              color: whiteBackGround,
                              margin: const EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: ListTile(
                                    title: Text(
                                      local.calculatorProjects,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    leading: Image.asset(
                                      "$iconsPath/projectsAndCalc-icon.png",
                                      width: 50,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.all(20),
                                            backgroundColor: Colors.white,
                                            title: Center(
                                              child: Text(
                                                local.pleaseSelectBuilingType,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ),
                                            content: Container(
                                              width: double.infinity,
                                              height: 90,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    child: MainButton(
                                                      fontSize: 11,
                                                      text: local.complex,
                                                      textColor: Colors.white,
                                                      backGroundColor:
                                                          primaryColor,
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close first dialog
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ShowPopUp(
                                                              ontap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              title: Text(
                                                                local
                                                                    .pleasecontacttheRCTteam,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                              content: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    local
                                                                        .tocontactviaWhatsApp,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          20),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      await launchUrlString(
                                                                          whatsapUrl
                                                                              .toString());
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          25,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/watsap222222.png",
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    child: MainButton(
                                                        fontSize: 11,
                                                        text: local.villa,
                                                        textColor: Colors.white,
                                                        backGroundColor:
                                                            primaryColor,
                                                        onTap: () async {
                                                          String loginMessage =
                                                              local
                                                                  .pleaselogin; // Custom message
                                                          bool isLoggedIn =
                                                              await checkLoginStatus(); // Check if the user is logged in

                                                          if (isLoggedIn) {
                                                            // If logged in, navigate to the ChooseBuildingType screen
                                                            orderModel
                                                                    .main_type =
                                                                local.villa;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const MeasurmentOfVilla(),
                                                              ),
                                                            );
                                                          } else {
                                                            // Show dialog if the user is not logged in
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      local
                                                                          .alert,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w900),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      loginMessage,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    // Display the login message
                                                                    actions: [
                                                                      Row(
                                                                        children: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(); // Close the dialog
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              local.cancel,
                                                                              style: TextStyle(fontSize: 12, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(); // Close the dialog
                                                                              // Navigate to the login screen
                                                                              Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => SendOtp()), // Replace with your actual login screen
                                                                              );
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              local.login,
                                                                              style: TextStyle(fontSize: 12, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          }
                                                        }),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    child: MainButton(
                                                        fontSize: 11,
                                                        text: local.building,
                                                        textColor: Colors.white,
                                                        backGroundColor:
                                                            primaryColor,
                                                        onTap: () async {
                                                          String loginMessage =
                                                              local
                                                                  .pleaselogin; // Custom message
                                                          bool isLoggedIn =
                                                              await checkLoginStatus(); // Check if the user is logged in

                                                          if (isLoggedIn) {
                                                            // If logged in, navigate to the ChooseBuildingType screen
                                                            local.building;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const MeasurmentOfFieldScreen(),
                                                              ),
                                                            );
                                                          } else {
                                                            // Show dialog if the user is not logged in
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      local
                                                                          .alert,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w900),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      loginMessage,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    // Display the login message
                                                                    actions: [
                                                                      Row(
                                                                        children: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(); // Close the dialog
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              local.cancel,
                                                                              style: TextStyle(fontSize: 12, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop(); // Close the dialog
                                                                              // Navigate to the login screen
                                                                              Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => SendOtp()), // Replace with your actual login screen
                                                                              );
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              local.login,
                                                                              style: TextStyle(fontSize: 12, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          }
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              // If logged in, navigate to the DesignAndScreen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const DesignAndScreen(),
                                ),
                              );
                            },
                            child: SizedBox(
                              height:
                                  hight, // Ensure 'height' is correctly defined
                              child: Card(
                                color: whiteBackGround,
                                margin: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      local.plansDesigns,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    leading: Image.asset(
                                      "$iconsPath/rafiki.png",
                                      width: 50,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2

                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PartnersScreen())),
                            child: SizedBox(
                              height: hight,
                              child: Card(
                                color: whiteBackGround,
                                margin: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      local.successPartners,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    leading: Image.asset(
                                      "$iconsPath/rafiki2.png",
                                      width: 50,
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool? isLoggedIn;

// Function to check login status
Future<bool> checkLoginStatus() async {
  isLoggedIn =
      await Checktoken().hasToken(); // Ensure Checktoken is correctly defined
  return isLoggedIn ?? false; // Return false if isLoggedIn is null
}

Future<void> deleteAccount(BuildContext context) async {
  var local = S.of(context);
  final url = Uri.parse('$linkServerName/api/account/delete');

  // Show a confirmation dialog
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          local.areyousureyouwanttodeleteAcc,
          style: TextStyle(fontSize: 12),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MainButton(
                backGroundColor: Colors.green,
                width: 100,
                onTap: () async {
                  Navigator.pop(context);
                },
                text: local.cancel,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              MainButton(
                backGroundColor: Colors.red,
                width: 100,
                onTap: () async {
                  Navigator.pop(context, true);
                  try {
                    final token =
                        await _getAuthToken(); // Replace with your method to get the token

                    // Create a DELETE request with body data
                    var request = http.Request('DELETE', url);
                    request.headers.addAll({
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $token',
                      "Accept-Language": CacheHelper.getData(key: "lang"),
                    });
                    request.body = jsonEncode({
                      'key': 'value', // Replace with your actual data
                    });

                    // Send the request
                    var response = await request.send();
                    var responseBody = await response.stream.bytesToString();

                    // Handle the response
                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            local.accDeletedSuccess,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                      // Navigate or perform further actions as needed
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          '${local.errorPleaseTryAgain} ${response.reasonPhrase}',
                          style: TextStyle(fontSize: 14),
                        )),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                        '${local.errorPleaseTryAgain}: $e',
                        style: TextStyle(fontSize: 14),
                      )),
                    );
                  }
                  await secureStorage.deleteAll();
                },
                text: local.yes,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<String?> _getAuthToken() async {
  return AppPreferences.getData(key: 'loginToken');
}

// void launchEmail(String email) async {
//   final Uri emailUri = Uri(
//     scheme: 'mailto',
//     path: email,
//     queryParameters: {
//       'subject': '',
//       'body': '',
//     },
//   );
//
//   await launchUrl(emailUri);
// }

void launchEmail(String email) async {
  // ننشئ URI بدون query لكي لا يكون هناك subject أو body مرفوع مسبقاً
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    // لا تضيف query أو queryParameters
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    // يمكنك إظهار رسالة خطأ هنا إذا فشل الإطلاق
    debugPrint('Could not launch $emailUri');
  }
}
