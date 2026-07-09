import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class CooperativeModel extends ChangeNotifier {
  double cost = 0.0;
  String lat = "";
  String long = "";
  dynamic location;
  String status = "pending";
  String agreement = "yes";
  dynamic nationalIdNumber;
  dynamic birthDate;
  late File? electronic_instrument;
  File? identity;
  File? schema;
  dynamic type_id = 0;
  dynamic price;
  String? city_name;
  String? district_name;
}
