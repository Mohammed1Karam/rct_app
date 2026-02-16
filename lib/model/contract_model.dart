class ContractModel {
  final int id;
  final int renterId;
  final int userId;
  final DateTime startDate;
  final DateTime endDate;
  final String totalAmount;
  final String totalContractAmount;
  final String downPayment;
  final String totalDownPayment;
  final String monthlyAmount;
  final String totalMonthlyAmount;
  final int numberOfInstallments;
  final int unitsCount;
  final String status;
  final String agreementNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Renter renter;
  final List<Installment> installments;

  ContractModel({
    required this.id,
    required this.renterId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.totalContractAmount,
    required this.downPayment,
    required this.totalDownPayment,
    required this.monthlyAmount,
    required this.totalMonthlyAmount,
    required this.numberOfInstallments,
    required this.unitsCount,
    required this.status,
    required this.agreementNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.renter,
    required this.installments,
  });

  factory ContractModel.fromMap(Map<String, dynamic> json) => ContractModel(
    id: json["id"],
    renterId: json["renter_id"],
    userId: json["user_id"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    totalAmount: json["total_amount"],
    totalContractAmount: json["total_contract_amount"],
    downPayment: json["down_payment"],
    totalDownPayment: json["total_down_payment"],
    monthlyAmount: json["monthly_amount"],
    totalMonthlyAmount: json["total_monthly_amount"],
    numberOfInstallments: json["number_of_installments"],
    unitsCount: json["units_count"],
    status: json["status"],
    agreementNumber: json["agreement_number"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    renter: Renter.fromMap(json["renter"]),
    installments: List<Installment>.from(json["installments"].map((x) => Installment.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "renter_id": renterId,
    "user_id": userId,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "total_amount": totalAmount,
    "total_contract_amount": totalContractAmount,
    "down_payment": downPayment,
    "total_down_payment": totalDownPayment,
    "monthly_amount": monthlyAmount,
    "total_monthly_amount": totalMonthlyAmount,
    "number_of_installments": numberOfInstallments,
    "units_count": unitsCount,
    "status": status,
    "agreement_number": agreementNumber,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "renter": renter.toMap(),
    "installments": List<dynamic>.from(installments.map((x) => x.toMap())),
  };
}

class Installment {
  final int id;
  final int renterContractId;
  final int installmentNumber;
  final DateTime dueDate;
  final String amount;
  final String baseAmount;
  final int unitsCount;
  final bool isPaid;
  final dynamic paidAt;
  final dynamic paymentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Installment({
    required this.id,
    required this.renterContractId,
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
    required this.baseAmount,
    required this.unitsCount,
    required this.isPaid,
    required this.paidAt,
    required this.paymentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Installment.fromMap(Map<String, dynamic> json) => Installment(
    id: json["id"],
    renterContractId: json["renter_contract_id"],
    installmentNumber: json["installment_number"],
    dueDate: DateTime.parse(json["due_date"]),
    amount: json["amount"],
    baseAmount: json["base_amount"],
    unitsCount: json["units_count"],
    isPaid: json["is_paid"],
    paidAt: json["paid_at"],
    paymentId: json["payment_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "renter_contract_id": renterContractId,
    "installment_number": installmentNumber,
    "due_date": dueDate.toIso8601String(),
    "amount": amount,
    "base_amount": baseAmount,
    "units_count": unitsCount,
    "is_paid": isPaid,
    "paid_at": paidAt,
    "payment_id": paymentId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Renter {
  final int id;
  final City title;
  final City city;
  final String lat;
  final String long;
  final City district;
  final int age;
  final int rooms;
  final int bathrooms;
  final int area;
  final String firstPayment;
  final int units;
  final int paymentPlan;
  final String paymentDuration;
  final String price;
  final City description;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final dynamic userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Renter({
    required this.id,
    required this.title,
    required this.city,
    required this.lat,
    required this.long,
    required this.district,
    required this.age,
    required this.rooms,
    required this.bathrooms,
    required this.area,
    required this.firstPayment,
    required this.units,
    required this.paymentPlan,
    required this.paymentDuration,
    required this.price,
    required this.description,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Renter.fromMap(Map<String, dynamic> json) => Renter(
    id: json["id"],
    title: City.fromMap(json["title"]),
    city: City.fromMap(json["city"]),
    lat: json["lat"],
    long: json["long"],
    district: City.fromMap(json["district"]),
    age: json["age"],
    rooms: json["rooms"],
    bathrooms: json["bathrooms"],
    area: json["area"],
    firstPayment: json["first_payment"],
    units: json["units"],
    paymentPlan: json["payment_plan"],
    paymentDuration: json["payment_duration"],
    price: json["price"],
    description: City.fromMap(json["description"]),
    image1: json["image1"],
    image2: json["image2"],
    image3: json["image3"],
    image4: json["image4"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title.toMap(),
    "city": city.toMap(),
    "lat": lat,
    "long": long,
    "district": district.toMap(),
    "age": age,
    "rooms": rooms,
    "bathrooms": bathrooms,
    "area": area,
    "first_payment": firstPayment,
    "units": units,
    "payment_plan": paymentPlan,
    "payment_duration": paymentDuration,
    "price": price,
    "description": description.toMap(),
    "image1": image1,
    "image2": image2,
    "image3": image3,
    "image4": image4,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class City {
  final String ar;
  final String en;

  City({
    required this.ar,
    required this.en,
  });

  factory City.fromMap(Map<String, dynamic> json) => City(
    ar: json["ar"],
    en: json["en"],
  );

  Map<String, dynamic> toMap() => {
    "ar": ar,
    "en": en,
  };
}
