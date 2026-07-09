import 'package:flutter/material.dart';

PreferredSize BackButtonAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: AppBar(
      elevation: 0.0, scrolledUnderElevation: 0.0,
      centerTitle: true,
      title: Image.asset(
        "assets/images/photo_2024-09-16_00-14-11.jpg",
        fit: BoxFit.contain,
        width: 100,
        height: 100,
      ),
      // backgroundColor: primaryColor,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
