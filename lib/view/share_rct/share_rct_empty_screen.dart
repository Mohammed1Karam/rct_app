import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';

class ShareRctEmptyScreen extends StatelessWidget {
  const ShareRctEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);


    return Scaffold(
      appBar: BackButtonAppBar(context),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(local.service_not_found, style:  TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w600,
        fontFamily: "URW-DIN-Arabic",
        fontSize: 14.sp,
      ),),
      ),
    );
  }
}
