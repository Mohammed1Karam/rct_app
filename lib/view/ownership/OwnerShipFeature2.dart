import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OwnerShipFeature2 extends StatelessWidget {
  const OwnerShipFeature2({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 95,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 10,
            ),
            // Image.asset(
            //   icon,
            //   width: 25,
            //   height: 25,
            //   fit: BoxFit.scaleDown,
            // ),
            SvgPicture.asset(icon,width: 25,height: 25, fit: BoxFit.scaleDown,),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF20262F),
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF20262F),
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}