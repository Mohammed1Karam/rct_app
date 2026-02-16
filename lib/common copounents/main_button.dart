import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rct/common%20copounents/custom_text.dart';

// ignore: must_be_immutable
class MainButton extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final double? width;
  final double? radius;
  final Color? backGroundColor;
  final double? height;
  final void Function()? onTap;
  final Color textColor;
  final double fontSize;
  BoxBorder? border;

  MainButton(
      {super.key,
      this.text,
      this.border,
      this.radius = 10,
      this.style,
      this.width = 335,
      this.backGroundColor,
      this.height = 45,
      this.textColor = Colors.white,
      this.fontSize = 12,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: height!.h,
          width: width!,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius!),
              color: backGroundColor,
              border: border
              // boxShadow: const [
              //   // BoxShadow(
              //   //     blurStyle: BlurStyle.outer,
              //   //     blurRadius: 5,
              //   //     color: blackShadowButton)
              // ],
              ),
          child: Center(
            child: CustomText(
              text: text!,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize, fontWeight: FontWeight.bold,
                // fontWeight: mainFontWeight,
              ),
            ),
          )),
    );
  }
}
