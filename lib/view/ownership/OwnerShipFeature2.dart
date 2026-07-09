import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OwnerShipFeature2 extends StatelessWidget {
  const OwnerShipFeature2({
    super.key,
    this.icon,
    this.image,
    required this.title,
    required this.subtitle,
  });

  final String? icon, image;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: 105.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0xff3F342B).withValues(alpha: 0.25),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              icon != null
                  ? SvgPicture.asset(
                      icon!,
                      width: 25.w,
                      height: 25.h,
                      fit: BoxFit.scaleDown,
                    )
                  : image != null
                      ? Image.asset(
                          image!,
                          width: 25.w,
                          height: 25.h,
                          fit: BoxFit.scaleDown,
                        )
                      : const SizedBox(),
              SizedBox(
                height: 5.h,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(
                  color: Color(0xFF20262F),
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(
                  color: Color(0xFF20262F),
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
