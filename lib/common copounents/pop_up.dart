import 'package:flutter/material.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';

// ignore: must_be_immutable
class ShowPopUp extends StatelessWidget {
  final Widget title;
  final Widget content;
  void Function()? ontap;
  bool? showbutton;

  ShowPopUp({
    super.key,
    required this.title,
    required this.content,
    this.ontap,
    this.showbutton = true,
  });

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: title),
      content: content,
      actions: showbutton!
          ? [
              Center(
                child: Container(
                  width: 100,
                  child: MainButton(
                    text: local.ok,
                    backGroundColor: primaryColor,
                    onTap: ontap,
                  ),
                ),
              ),
            ]
          : null,
    );
  }
}
