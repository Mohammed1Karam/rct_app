import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/constants/constants.dart';

// ignore: must_be_immutable
class TextFormFieldCustom extends StatelessWidget {
  final BuildContext context;
  final String labelText;
  final void Function(String) onChanged;
  final TextEditingController controller;
  // final String? validatorErrorMessage;
  final String? Function(String?)? validator;

  bool? border = true;
  bool? enabled;
  bool? number = false;
  bool? password = false;
  String? value;
  double length;
  List<TextInputFormatter>? inputFormatters;
  String? Text;
  TextInputType? inputType;
  dynamic numberofdigits;
  String? prefix;
  TextFormFieldCustom({
    super.key,
    this.inputFormatters,
    required this.context,
    required this.labelText,
    required this.onChanged,
    required this.controller,
    // this.validatorErrorMessage,
    this.border,
    this.inputType,
    this.numberofdigits,
    this.Text,
    this.enabled,
    this.value,
    this.number,
    this.password,
    this.length = 0,
    this.validator,
    this.prefix
  });

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);

    return TextFormField(
        inputFormatters: inputFormatters,
        maxLength: numberofdigits,
        controller: value == null ? controller : null,
        initialValue: value,
        validator: (value) {
          if (value!.isEmpty) {
            return local.pleaseEnterRequiredInformation;
          }
          return null;
        },
        onChanged: (value) => onChanged(value),
        enabled: enabled,
        keyboardType: inputType,
        decoration: InputDecoration(
          suffixText: Text,
          suffixStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),

          hintText: labelText,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          fillColor: grey.withOpacity(0.5),
          filled: true,
          prefixText: prefix,
          prefixStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: darkGrey, overflow: TextOverflow.clip, fontSize: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          // labelStyle: const TextStyle(color: Colors.black45),
          hintStyle: TextStyle(color: Colors.black, fontSize: 10),
          iconColor: Colors.grey,
        ));
  }
}
