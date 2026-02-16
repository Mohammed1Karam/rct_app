import 'package:flutter/material.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';

class ConfirmRequest extends StatefulWidget {
  final VoidCallback onTap;
  const ConfirmRequest({super.key, required this.onTap});

  @override
  State<ConfirmRequest> createState() => _ConfirmRequestState();
}

class _ConfirmRequestState extends State<ConfirmRequest> {
  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/Group 469356 (1).png"),
              SizedBox(
                height: 20,
              ),
              Center(child: Text(local.confirmRequest)),
              SizedBox(
                height: 40,
              ),
              MainButton(
                  text: local.ok,
                  backGroundColor: primaryColor,
                  onTap: widget.onTap)
            ],
          ),
        ),
      ),
    );
  }
}
