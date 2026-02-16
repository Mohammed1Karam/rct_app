import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/view/home_screen.dart';
import 'package:rct/view/payment/payment_recipt_screen.dart';

import 'package:rct/l10n/app_localizations.dart';

class NotifiContainer extends StatelessWidget {
  final String blackText;
  final String blueText;
  final String time;
  final String type;
  const NotifiContainer(
      {super.key,
      required this.blackText,
      required this.blueText,
      required this.time,
      required this.type});

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Center(
            child: Text.rich(
              style: Theme.of(context).textTheme.bodyMedium,
              TextSpan(
                children: [
                  TextSpan(
                    text: "$blackText ",
                  ),
                  TextSpan(
                      text: blueText,
                      style: const TextStyle(
                        color: Colors.blue,
                      )),
                ],
              ),
            ),
          ),
          titleAlignment: ListTileTitleAlignment.center,
          minVerticalPadding: 10,
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => type == "payment"
                    ? Navigator.pushNamed(
                        context, PaymentReciptScreen().screenId)
                    : showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ShowPopUp(
                            title: Center(
                              child: Image.asset(
                                "assets/icons/popUp-icon.png",
                                height: 50.h,
                                width: 50.w,
                              ),
                            ),
                            content: ListTile(
                              titleAlignment: ListTileTitleAlignment.center,
                              title: Text(local.replySentSuccessfully),
                              subtitle: Text(local.paymentNotification),
                            ),
                            ontap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen())),
                          );
                        }),
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                  Colors.green,
                )),
                child: Text(local.accept),
              ),
              TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ShowPopUp(
                        title: Text(
                          local.cancelRequestConfirmation,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(local.reject),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                primaryColor,
                              )),
                              onPressed: () =>
                                  Navigator.pushNamed(context, HomeScreen.id),
                              child: Text(
                                local.ok,
                                style: TextStyle(
                                  color: whiteBackGround,
                                ),
                              ),
                            )
                          ],
                        ),
                        ontap: () => Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                                HomeScreen.id, (route) => false),
                        showbutton: false,
                      );
                    }),
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                  Colors.red,
                )),
                child: Text(local.reject),
              ),
            ],
          ),
          trailing: Text(
            time,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.blue,
                ),
          ),
        ),
      ),
    );
  }
}
