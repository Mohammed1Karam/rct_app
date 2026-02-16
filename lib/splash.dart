import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/RealEstate/details_screen.dart';
import 'package:rct/view/ownership/renters_cubit.dart';
import 'package:rct/view/share_rct/cubit.dart';
import 'package:rct/view/share_rct/details.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rct/view/home_screen.dart';
import 'package:rct/view/onboarding/onboarding_screen_1.dart';
// حُذفت: import 'package:uni_links/uni_links.dart';

class SplashScreen extends StatefulWidget {
  static String id = "SplashScreen";

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasCompletedOnboarding = false;
  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<ShareCubit>().fetchShare('$linkServerName/api/opportunities');
    context.read<RentersCubit>().fetchUnAuthData("$linkServerName/api/renters");

    FirebaseMessaging.instance.requestPermission();

    // استدعاء التوجيه مباشرةً عوضًا عن handleInitialUri()
    reDirect();
  }

  @override
  void dispose() {
    // تم حذف أي ارتباط بـ StreamSubscription (Deep Link) لعدم استخدام uni_links
    super.dispose();
  }

  reDirect() {
    checkOnboardingStatus();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (kDebugMode) {
        print("Onboarding status: $hasCompletedOnboarding");
      }

      // في الكود الأصلي، شرط (if false) يوضح مثالًا لمكان استقبال deep link
      // هنا لن يعمل؛ لذا يبقى كعرض فقط
      if (false) {
       /* AppPreferences.removeDate(key: "deepLink");
        Navigator.push(
          Get.context!,
          MaterialPageRoute(builder: (context) => ShareDetails(house: "deepLink")),
        );*/
      } else {
        // التوجيه بناء على حالة Onboarding
        hasCompletedOnboarding
            ? Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()))
            : Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
    });
  }

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //hasCompletedOnboarding = false;
      hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
