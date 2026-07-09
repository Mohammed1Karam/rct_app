import 'package:flutter/services.dart';

class NumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Regex to allow only English and Arabic digits
    final RegExp regex = RegExp(r'^[\u0660-\u0669\u0030-\u0039]*$');
    if (regex.hasMatch(newValue.text)) {
      return newValue; // Accept new value if it matches the regex
    }
    return oldValue; // Revert to the old value if the input is invalid
  }
}
