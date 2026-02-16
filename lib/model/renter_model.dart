import 'package:flutter/cupertino.dart';

class RenterModel extends ChangeNotifier {
   int? id;
   String? title;
   String? city;
   String? lat;
   String? long;
   String? district;
   int? age;
   int? rooms;
   int? bathrooms;
   int? area;
   String? firstPayment;
   int? units;
   int? paymentPlan;
   String? paymentDuration;
   String? price;
   String? description;
   String? images1;
   String? images2;
   String? images3;
   String? images4;
   String? file;
   DateTime? createdAt;

  RenterModel({
    this.id,
    this.title,
    this.city,
    this.lat,
    this.long,
    this.district,
    this.age,
    this.rooms,
    this.bathrooms,
    this.area,
    this.firstPayment,
    this.units,
    this.paymentPlan,
    this.paymentDuration,
    this.price,
    this.description,
    this.images1,
    this.images2,
    this.images3,
    this.images4,
    this.file,
   this.createdAt,
  });

  factory RenterModel.fromMap(Map<String, dynamic> json) => RenterModel(
    id: json["id"],
    title: json["title"],
    city: json["city"],
    lat: json["lat"],
    long: json["long"],
    district: json["district"],
    age: json["age"],
    rooms: json["rooms"],
    bathrooms: json["bathrooms"],
    area: json["area"],
    firstPayment: json["first_payment"],
    units: json["units"],
    paymentPlan: json["payment_plan"],
    paymentDuration: json["payment_duration"],
    price: json["price"],
    description: json["description"],
    images1: json["image1"],
    images2: json["image2"],
    images3: json["image3"],
    images4: json["image4"],
    file: json["file"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "city": city,
    "lat": lat,
    "long": long,
    "district": district,
    "age": age,
    "rooms": rooms,
    "bathrooms": bathrooms,
    "area": area,
    "first_payment": firstPayment,
    "units": units,
    "payment_plan": paymentPlan,
    "payment_duration": paymentDuration,
    "price": price,
    "description": description,
    "image1": images1,
    "image2": images2,
    "image3": images3,
    "image4": images4,
    "file": file,
    "created_at": createdAt?.toIso8601String(),
  };
}
