import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rct/common%20copounents/checkLanguage.dart';

import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:rct/constants/constants.dart';
import 'package:rct/view/home_screen.dart';
import 'dart:ui' as ui;

import '../../generated/l10n.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = "OnboardingScreen";

  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FirebaseMessaging.instance.requestPermission();

  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                OnboardingPage(
                  imagePath: 'assets/images/onboarding1.png',
                  title: local.page1Title,
                  description: local.page1Description,
                ),
                OnboardingPage(
                  imagePath: 'assets/images/onboarding2.png',
                  title: local.page2Title,
                  description: local.page2Description,
                ),
                OnboardingPage(
                  imagePath: 'assets/images/onboarding3.png',
                  title: local.page3Title,
                  description: local.page3Description,
                ),

                // Second Container for Title and Description
                /* Stack(
                  children: [
                    ClipPath(
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            0.6, // Adjust this as needed
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/onboardingFinal4.png"),
                            fit: BoxFit
                                .cover, // Fit the image properly in the space
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50, // Position it at the bottom
                      left: 0,
                      right: 0,
                      child: ClipPath(
                        // Optional: You can use a different clipper if desired
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: getDynamicBorderRadius(),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          height: MediaQuery.of(context).size.height *
                              0.35, // Adjusted height for the t   ext container
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                local.page4Title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                local.page4Description,
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),*/

                OnboardingPage(
                  imagePath: "assets/images/onboarding4.png",
                  title: local.page4Title,
                  description: local.page4Description,
                ),
                OnboardingPage(
                  imagePath: "assets/images/onboarding5.png",
                  title: local.page5Title,
                  description: local.page5Description,
                ),
                OnboardingPage(
                  imagePath: "assets/images/onboarding6.png",
                  title: local.page6Title,
                  description: local.page6Description,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  GestureDetector(
                    onTap:(){
                      if (_currentPage == 5) {
                        completeOnboarding();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => HomeScreen()));
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Image.asset(
                        width: 58.w,
                        height: 58.h,
                        "assets/images/Loader.png"),
                  ),
                  /* TextButton(
                    onPressed: () {
                      // Next or Done button action

                    },
                    child: Text(
                      _currentPage == 5 ? local.done : local.next,
                      selectionColor: primaryColor,
                      style: TextStyle(color: primaryColor),
                    ),
                  ),*/
                  /*TextButton(
                    onPressed: () {
                      // Skip button action
                      // _pageController.jumpToPage(4);
                      completeOnboarding();
                      // Navigate to the main app or home screen
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomeScreen()));
                    },
                    child: Text(
                      local.skip,
                      style: TextStyle(color: primaryColor),
                    ),
                  ),*/
                  Spacer(),
                  Row(
                    children: List.generate(
                      6,
                          (index) => buildDot(index, context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),)
    );
  }

  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'hasCompletedOnboarding', true); // Save the completion status
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 16 : 8,
      height: _currentPage == index ? 8 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.black : Colors.grey,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // First Container for the Image
        ClipPath(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.61,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 60, // Position it at the bottom
          left: 0,
          right: 0,
          child: ClipPath(
            // Optional: You can use a different clipper if desired
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: getDynamicBorderRadius(),
                // border: Border.all(
                //     color: Colors.black, width: 1), // Add border here
              ),
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height *
                  0.31, // Adjusted height for the t   ext container
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
