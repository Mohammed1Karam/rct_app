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
        context.read<ShareCubit>().fetchShare('$linkServerName/api/opportunities');
        context.read<RentersCubit>().fetchUnAuthData("$linkServerName/api/renters");
        FirebaseMessaging.instance.requestPermission();
      }
    });

    reDirect();
  }

  Future<void> reDirect() async {
    await checkOnboardingStatus();
    await Future.delayed(const Duration(seconds: 3));

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
        hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        "assets/images/splash.png",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  }
}

/*
class SplashScreen extends StatefulWidget {
  static String id = "SplashScreen";

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool hasCompletedOnboarding = false;
  final _scaffoldKey = GlobalKey();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -190, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Delay heavy operations to prevent initial jank
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ShareCubit>().fetchShare('$linkServerName/api/opportunities');
        context.read<RentersCubit>().fetchUnAuthData("$linkServerName/api/renters");
        FirebaseMessaging.instance.requestPermission();
      }
    });

    reDirect();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> reDirect() async {
    await checkOnboardingStatus();
    await Future.delayed(const Duration(seconds: 3));
    // await Future.delayed(Duration.zero);

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
        hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            "assets/images/splashBackground.png",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),

          // 4. Centered Logo with Animation
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: RepaintBoundary(child: child),
                );
              },
              child: SvgPicture.asset(
                "assets/icons/splashLogo.svg",
                width: 100.w,
                height: 100.h,
              ),
            ),
          )
        ],
      ),
    );
  }
}
*/
