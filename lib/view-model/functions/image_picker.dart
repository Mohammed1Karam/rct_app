import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:rct/constants/constants.dart';
// import 'package:rct/view-model/functions/snackbar.dart';

Future pickImageFromGallery(BuildContext context) async {
  final returnedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);

  if (returnedImage == null) {
    // showSnackBar(context, "لم يتم رفع الصوره بنجاح", redColor);
  } else {
    // showSnackBar(context, "تم رفع الصوره بنجاح", primaryColor);
    return File(returnedImage.path);
  }
}
