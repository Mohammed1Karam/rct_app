class RawLandsModel {
  List<OldBuildings>? oldBuildings;
  List<Schema>? rawLands;
  List<Schema>? schema;

  RawLandsModel({this.oldBuildings, this.rawLands, this.schema});

  RawLandsModel.fromJson(Map<String, dynamic> json) {
    if (json['oldBuildings'] != null) {
      oldBuildings = <OldBuildings>[];
      json['oldBuildings'].forEach((v) {
        oldBuildings!.add(new OldBuildings.fromJson(v));
      });
    }
    if (json['rawLands'] != null) {
      rawLands = <Schema>[];
      json['rawLands'].forEach((v) {
        rawLands!.add(new Schema.fromJson(v));
      });
    }
    if (json['Schema'] != null) {
      schema = <Schema>[];
      json['Schema'].forEach((v) {
        schema!.add(new Schema.fromJson(v));
      });
    }
  }
}

class OldBuildings {
  int? id;
  int? userId;
  String? type;
 dynamic identity;
 dynamic identityNumber;
 dynamic clientBirth;
  String? electronicInstrument;
  String? cityName;
  String? districtName;
  String? price;
  String? location;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? userStatus;
  int? agreedTerms;


  OldBuildings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    identity = json['identity'];
    identityNumber = json['identity_number'];
    clientBirth = json['client_birth'];
    electronicInstrument = json['electronic_instrument'];
    cityName = json['city_name'];
    districtName = json['district_name'];
    price = json['price'];
    location = json['location'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userStatus = json['user_status'];
    agreedTerms = json['agreed_terms'];
  }
}

class Schema {
  int? id;
  int? userId;
  String? type;
  String? identity;
  dynamic identityNumber;
  dynamic clientBirth;
  String? electronicInstrument;
  String? schema;
  String? cityName;
  String? districtName;
  String? price;
  String? location;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? userStatus;
  int? agreedTerms;

  Schema.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    identity = json['identity'];
    identityNumber = json['identity_number'];
    clientBirth = json['client_birth'];
    electronicInstrument = json['electronic_instrument'];
    schema = json['schema'];
    cityName = json['city_name'];
    districtName = json['district_name'];
    price = json['price'];
    location = json['location'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userStatus = json['user_status'];
    agreedTerms = json['agreed_terms'];
  }
}
