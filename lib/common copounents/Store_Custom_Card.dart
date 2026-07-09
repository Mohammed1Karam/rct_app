import 'package:flutter/material.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';

// ignore: must_be_immutable
class StoreCard extends StatelessWidget {
  StoreCard({
    super.key,
    this.image,
    this.price,
    this.text2,
    this.city,
    this.neighborhood,
    this.buttonText,
    this.name,
  });
  dynamic image;
  dynamic name;
  dynamic city;
  dynamic neighborhood;
  dynamic text2;
  dynamic price;
  dynamic buttonText;
  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  image ??
                      "https://th.bing.com/th/id/OIP.9hetfdrodOfI9KzE_g_dDAAAAA?rs=1&pid=ImgDetMain",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name ?? "",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                "${city ?? ""} - ${neighborhood ?? ""}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                price ?? "",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w900),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: MainButton(
                      width: 100,
                      height: 30,
                      text: local.visitStore,
                      fontSize: 10,
                      textColor: Colors.white,
                      backGroundColor: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ));
  }
}
