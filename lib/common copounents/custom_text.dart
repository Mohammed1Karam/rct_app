import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final TextAlign? textAlign;
  final TextStyle? style;

  const CustomText({super.key, this.text, this.textAlign, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        textAlign: textAlign, overflow: TextOverflow.clip, style: style);
  }
}
