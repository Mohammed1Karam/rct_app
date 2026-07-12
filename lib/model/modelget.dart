import 'package:flutter/foundation.dart';

class Modelget extends ChangeNotifier {
  dynamic house_type;
  dynamic type;
  double? lat;
  double? long;
  dynamic age;
  dynamic house_space;
  dynamic description;
  String? name;
  dynamic district_name;
  final dynamic price;
  dynamic is_in_goodlist;
  dynamic goodlist_id;
  String? real_estate_authority_link;
  String? real_estate_authority;
  String? licence_value;
  dynamic opportunity_count;
  dynamic number_opportunity_pay;
  dynamic image1;
  String? number;
  String? barcode;
  dynamic city_name;
  dynamic isfavorit;
  String? opportunity_price;
  dynamic image2;
  dynamic image;
  dynamic image3;
  dynamic image4;
  dynamic identity;
  dynamic id;
  dynamic status;
  dynamic created_at;
  dynamic orderNumber;
  String? total_price;
  dynamic identity_number;
  dynamic number_time;
  dynamic location;
  dynamic birthdate;
  String? percent_number;
  dynamic project_duration;
  dynamic electronic_instrument;
  String? file;
  String? file2;
  String? file3;
  bool? is_qualified_investor;

  Modelget({
    this.opportunity_price,
    this.name,
    this.lat,
    this.long,
    this.age,
    this.number_time,
    this.house_type,
    this.opportunity_count,
    this.total_price,
    this.percent_number,
    this.orderNumber,
    this.project_duration,
    this.location,
    this.birthdate,
    this.identity_number,
    this.type,
    this.isfavorit,
    this.house_space,
    this.electronic_instrument,
    this.description,
    this.district_name,
    this.price,
    this.image1,
    this.image,
    this.number,
    this.city_name,
    this.image2,
    this.image3,
    this.image4,
    this.identity,
    this.id,
    this.number_opportunity_pay,
    this.status,
    this.is_in_goodlist,
    this.created_at,
    this.goodlist_id,
    this.real_estate_authority_link,
    this.licence_value,
    this.real_estate_authority,
    this.barcode,
    this.file,
    this.file2,
    this.file3,
    this.is_qualified_investor,
  });

  factory Modelget.fromJson(Map<String, dynamic> json) {
    return Modelget(
      house_type: _toString(json['house_type']),
      goodlist_id: json['goodlist_id'],
      lat: _toDouble(json['lat']),
      long: _toDouble(json['long']),
      age: _toString(json['oper_age']),
      is_in_goodlist: _toString(json["is_in_goodlist"]),
      project_duration: _toString(json['project_duration']),
      isfavorit: json['isfavorit'],
      number_time: json['number_time'],
      opportunity_count: _toString(json['opportunity_count']),
      percent_number: _toString(json['percent_number']),
      number_opportunity_pay: _toString(json['number_opportunity_pay']),
      opportunity_price: _toString(json['opportunity_price']),
      total_price: _toString(json['total_price']),
      name: _toString(json['name']),
      type: _toString(json['type']),
      status: _toString(json['status']),
      real_estate_authority_link: _toString(json['real_estate_authority_link']),
      real_estate_authority: _toString(json['real_estate_authority']),
      licence_value:_toString(json['val_license']) ,
      city_name: _toString(json['city_name']),
      house_space: _toString(json['house_space']),
      description: _toString(json['description']),
      created_at: _toString(json['created_at']),
      district_name: _toString(json['district_name']),
      price: json['price'],
      barcode: _toString(json['barcode']),
      id: _toString(json['id']),
      orderNumber: _toString(json['orderNumber']),
      number: _toString(json['number']),
      image1: _toString(json['image1']),
      identity: _toString(json['identity']),
      electronic_instrument: _toString(json['electronic_instrument']),
      image2: _toString(json['image2']),
      image3: _toString(json['image3']),
      image4: _toString(json['image4']),
      image: _toString(json['image']),
      location: _toString(json['location']),
      identity_number: _toString(json['identity_number']),
      birthdate: _toString(json['client_birth']),
      file: _toString(json['file']),
      file2: _toString(json['file2']),
      file3: _toString(json['file3']),
      is_qualified_investor: json['is_qualified_investor'],
    );
  }

  // Helper method to safely convert any type to String
  static String? _toString(dynamic value) {
    if (value == null) return "";
    return value.toString();
  }

  // Helper method to safely convert any type to double
  static double? _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'house_type': house_type,
      'image': image,
      'type': type,
      'house_space': house_space,
      'description': description,
      'district_name': district_name,
      'price': price,
      'image1': image1,
      'order_number': number,
      'city_name': city_name,
      'project_duration': project_duration,
      'real_estate_authority_link': real_estate_authority_link,
      'image2': image2,
      'image3': image3,
      'number_opportunity_pay': number_opportunity_pay,
      'image4': image4,
      'identity': identity,
      'barcode': barcode,
      'id': id,
      'status': status,
      'created_at': created_at,
      'opportunity_price': opportunity_price,
      'total_price': total_price,
      'opportunity_count': opportunity_count,
      'is_in_goodlist': is_in_goodlist,
      'goodlist_id': goodlist_id,
      'real_estate_authority': real_estate_authority,
      'licence_value': licence_value,
      'lat': lat,
      'long': long,
      'age': age,
      'number_time': number_time,
      'location': location,
      'birthdate': birthdate,
      'percent_number': percent_number,
      'electronic_instrument': electronic_instrument,
      'file': file,
      'file2': file2,
      'file3': file3,
      'is_qualified_investor': is_qualified_investor,
    };
  }
}