import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Color backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
    ),
  );
}
