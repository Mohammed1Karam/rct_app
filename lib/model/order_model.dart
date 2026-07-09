import 'dart:math';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class OrderModel extends ChangeNotifier {
  dynamic streetDetails;
  dynamic main_type;
  dynamic typePrice;
  dynamic finalForm;
  dynamic cost = 0.0;
  dynamic floorcount;
  dynamic lat = "";
  dynamic long = "";
  dynamic location = "";
  dynamic status = "pending";
  dynamic agreement = "yes";
  dynamic landCheckImage;
  dynamic electronicimage;
  dynamic nationalidimage;
  late dynamic number;
  dynamic user_id = 0;
  dynamic areaspace_id = 0;
  double areaspace = 0.0;
  dynamic type_id = 0;
  dynamic design_id = 0;
  dynamic sketch_id = 0;
  dynamic preferable_id = 0;
  dynamic receipt_id = 0;
  dynamic build_types_price = 0;
  dynamic build_price = 0;
  dynamic SwimmingPool = 0;
  dynamic has_pool;
  dynamic islandChecked;
  dynamic image;
  dynamic buildtype_id;
  dynamic unitNumber = 0;
  List floorDetails = [];
  List<String> orderNumbers = [];
  dynamic birthDate;
  dynamic nationalIdNumber;
  static final Set<int> _usedNumbers = {};

  OrderModel() {
    number = _generateUniqueRandomNumber().toString();
  }

  int _generateUniqueRandomNumber() {
    final random = Random();
    int generatedNumber;

    do {
      generatedNumber = random.nextInt(10000) + 1;
    } while (_usedNumbers.contains(generatedNumber));

    _usedNumbers.add(generatedNumber); // Track the new unique number
    return generatedNumber;
  }
}
