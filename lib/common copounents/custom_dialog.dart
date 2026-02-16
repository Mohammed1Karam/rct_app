import 'dart:ui';

import 'package:flutter/material.dart';

Future customDialog({
  required context,
  required child,
  backGroundColor = Colors.white,
  isDismissible = true,
}) => showGeneralDialog(
  context: context,
  barrierDismissible: isDismissible,
  barrierLabel: "Dismiss",
  barrierColor: Colors.black.withValues(alpha: 0.2),
  pageBuilder: (_, __, ___) {
    return const SizedBox.shrink();
  },
  transitionBuilder: (context, animation, secondaryAnimation, child1) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: FadeTransition(
        opacity: animation,
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: child,
            ),
          ),
        ),
      ),
    );
  },
);
