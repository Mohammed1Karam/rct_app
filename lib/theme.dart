import 'package:flutter/material.dart';
import 'package:rct/constants/constants.dart';

ThemeData theme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      background: whiteBackGround,
      primary: primaryColor,
    ),
    useMaterial3: true,
    fontFamily: "URW-DIN-Arabic",
    textTheme: TextTheme(
      bodySmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        // height: 1.5, // Leading point of 24px (24/16)
      ),
      // Label Medium
      labelMedium: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        // height: 1.29, // Leading point of 18px (18/14)
      ),
      // Label Small.
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        //   height: 1.33, // Leading point of 16px (16/12)
      ),
    ),
  );
}
