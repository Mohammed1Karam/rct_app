// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class HouseModel extends ChangeNotifier {
  double cost = 0.0;
  dynamic lat = "";
  dynamic long = "";
  dynamic location = "";
  dynamic status = "";
  dynamic orderNumber;
  dynamic agreement = "yes";
  dynamic image1;
  dynamic image;
  dynamic image2;
  dynamic image3;
  dynamic image4;
  dynamic phone;
  late File? electronic_instrument;
  dynamic house_space;
  dynamic price;
  dynamic city_name;
  dynamic house_type;
  dynamic house_name;
  dynamic district_name;
  dynamic description;
  File? identity;
  late dynamic number;
  dynamic user_id = 0;
  dynamic areaspace_id = 0;
  double areaspace = 0.0;
  dynamic type_id = 0;
  dynamic design_id;
  dynamic sketch_id = 0;
  dynamic preferable_id = 0;
  dynamic receipt_id = 0;
  dynamic build_types_price = 0;
  dynamic build_price = 0;
  List floorDetails = [];
  List<dynamic> orderNumbers = [];

  HouseModel() {
    number = generateRandomNumber().toString();
  }

  dynamic generateRandomNumber() {
    final random = Random();
    return random.nextInt(10000) +
        1; // nextInt(10000) generates a number between 0 and 9999, so we add 1 to get a range from 1 to 10000
  }
}
