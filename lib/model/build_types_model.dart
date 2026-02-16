import 'package:flutter/material.dart';

class BuildTypesModel extends ChangeNotifier {
  String? name;
  String? price;
  dynamic id;

  BuildTypesModel({
    this.name,
    this.price,
    this.id,
  });

  factory BuildTypesModel.fromJson(Map<String, dynamic> json) {
    return BuildTypesModel(
      name: json['name'],
      price: json['price'],
      id: json['id'],
    );
  }
}
