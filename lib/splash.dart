import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/ownership/renters_cubit.dart';
import 'package:rct/view/share_rct/cubit.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rct/view/home_screen.dart';
import 'package:rct/view/onboarding/onboarding_screen_1.dart';

class SplashScreen extends StatefulWidget {
  static String id = "SplashScreen";

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasCompletedOnboarding = false;

  @override
  void initState() {
    super.initState();

    // Delay heavy operations to prevent initial jank
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<ShareCubit>()
            .fetchShare('$linkServerName/api/opportunities');
        context
            .read<RentersCubit>()
            .fetchUnAuthData("$linkServerName/api/renters");
        FirebaseMessaging.instance.requestPermission();
      }
    });

    reDirect();
  }

  Future<void> reDirect() async {
    await checkOnboardingStatus();
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    if (kDebugMode) {
      print("Onboarding status: $hasCompletedOnboarding");
    }

    // Navigation logic
    if (hasCompletedOnboarding) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        hasCompletedOnboarding =
            prefs.getBool('hasCompletedOnboarding') ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20262f),
      body: Image.asset(
        "assets/images/splash.png",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class IOSSplashScreen extends StatefulWidget {
  static String id = "IOSSplashScreen";

  const IOSSplashScreen({super.key});

  @override
  _IOSSplashScreenState createState() => _IOSSplashScreenState();
}

class _IOSSplashScreenState extends State<IOSSplashScreen> {
  bool hasCompletedOnboarding = false;

  @override
  void initState() {
    super.initState();

    // Delay heavy operations to prevent initial jank
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<ShareCubit>()
            .fetchShare('$linkServerName/api/opportunities');
        context
            .read<RentersCubit>()
            .fetchUnAuthData("$linkServerName/api/renters");
        FirebaseMessaging.instance.requestPermission();
      }
    });

    reDirect();
  }

  Future<void> reDirect() async {
    await checkOnboardingStatus();
    // await Future.delayed( Duration(milliseconds: 0));
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    if (kDebugMode) {
      print("Onboarding status: $hasCompletedOnboarding");
    }

    // Navigation logic
    if (hasCompletedOnboarding) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        hasCompletedOnboarding =
            prefs.getBool('hasCompletedOnboarding') ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20262f),
      body: Image.asset(
        "assets/images/splash.png",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  }
}
