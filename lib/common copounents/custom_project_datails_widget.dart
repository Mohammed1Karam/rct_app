import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomProjectDetailsWidget extends StatelessWidget {
  const CustomProjectDetailsWidget({
    super.key,
    required this.image,
    required this.title,
    this.height = 20,
  });
  final String image;
  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff3F342B).withValues(alpha: 0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            image,
            width: 16,
            height: height,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF20262F),
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
