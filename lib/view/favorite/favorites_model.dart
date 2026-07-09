class FavoritesModel {
  Data? data;

  FavoritesModel({this.data});

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<House>? house;
  List<Seller>? sellers;

  List<Design>? design;
  List<Design>? sketch;
  List<Opportunity>? opportunity;
  List<Other>? other;
  List<Product>? product;
  Data(
      {this.house,
      this.design,
      this.sketch,
      this.opportunity,
      this.other,
      this.product});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['House'] != null) {
      house = <House>[];
      json['House'].forEach((v) {
        house!.add(new House.fromJson(v));
      });
    }
    if (json['Design'] != null) {
      design = <Design>[];
      json['Design'].forEach((v) {
        design!.add(new Design.fromJson(v));
      });
    }
    if (json['Sketch'] != null) {
      sketch = <Design>[];
      json['Sketch'].forEach((v) {
        sketch!.add(new Design.fromJson(v));
      });
    }
    if (json['Opportunity'] != null) {
      opportunity = <Opportunity>[];
      json['Opportunity'].forEach((v) {
        opportunity!.add(new Opportunity.fromJson(v));
      });
    }
    if (json['Product'] != null) {
      product = <Product>[];
      json['Product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
    if (json['Seller'] != null) {
      sellers = <Seller>[];
      json['Seller'].forEach((v) {
        sellers!.add(new Seller.fromJson(v));
      });
    }
    if (json['Other'] != null) {
      other = <Other>[];
      json['Other'].forEach((v) {
        other!.add(new Other.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.house != null) {
      data['House'] = this.house!.map((v) => v.toJson()).toList();
    }
    if (this.design != null) {
      data['Design'] = this.design!.map((v) => v.toJson()).toList();
    }
    if (this.sketch != null) {
      data['Sketch'] = this.sketch!.map((v) => v.toJson()).toList();
    }
    if (this.opportunity != null) {
      data['Opportunity'] = this.opportunity!.map((v) => v.toJson()).toList();
    }
    if (this.other != null) {
      data['Other'] = this.other!.map((v) => v.toJson()).toList();
    }
    if (this.product != null) {
      data['Product'] = this.other!.map((v) => v.toJson()).toList();
    }
    if (this.product != null) {
      data['Seller'] = this.other!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class House {
  int? id;
  int? userId;
  String? type;
  String? identity;
  String? electronicInstrument;
  HouseType? houseType;
  HouseType? houseName;
  HouseType? cityName;
  dynamic identityNumber;
  dynamic clientBirth;
  String? clientPhone;
  String? houseSpace;
  HouseType? districtName;
  HouseType? description;
  String? location;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? status;
  dynamic price;
  String? statusUpdatedAt;
  String? createdAt;
  String? updatedAt;
  String? userStatus;
  int? agreedTerms;
  int? goodListId;

  House(
      {this.id,
      this.userId,
      this.type,
      this.identity,
      this.electronicInstrument,
      this.houseType,
      this.houseName,
      this.cityName,
      this.identityNumber,
      this.clientBirth,
      this.clientPhone,
      this.houseSpace,
      this.districtName,
      this.description,
      this.location,
      this.image1,
      this.image2,
      this.image3,
      this.image4,
      this.status,
      this.price,
      this.statusUpdatedAt,
      this.createdAt,
      this.updatedAt,
      this.userStatus,
      this.agreedTerms,
      this.goodListId});

  House.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    identity = json['identity'];
    electronicInstrument = json['electronic_instrument'];
    houseType = json['house_type'] != null
        ? new HouseType.fromJson(json['house_type'])
        : null;
    houseName = json['house_name'] != null
        ? new HouseType.fromJson(json['house_name'])
        : null;
    cityName = json['city_name'] != null
        ? new HouseType.fromJson(json['city_name'])
        : null;
    identityNumber = json['identity_number'];
    clientBirth = json['client_birth'];
    clientPhone = json['client_phone'];
    houseSpace = json['house_space'];
    districtName = json['district_name'] != null
        ? new HouseType.fromJson(json['district_name'])
        : null;
    description = json['description'] != null
        ? new HouseType.fromJson(json['description'])
        : null;
    location = json['location'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    image4 = json['image4'];
    status = json['status'];
    price = json['price'];
    statusUpdatedAt = json['status_updated_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userStatus = json['user_status'];
    agreedTerms = json['agreed_terms'];
    goodListId = json['good_list_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['identity'] = this.identity;
    data['electronic_instrument'] = this.electronicInstrument;
    if (this.houseType != null) {
      data['house_type'] = this.houseType!.toJson();
    }
    if (this.houseName != null) {
      data['house_name'] = this.houseName!.toJson();
    }
    if (this.cityName != null) {
      data['city_name'] = this.cityName!.toJson();
    }
    data['identity_number'] = this.identityNumber;
    data['client_birth'] = this.clientBirth;
    data['client_phone'] = this.clientPhone;
    data['house_space'] = this.houseSpace;
    if (this.districtName != null) {
      data['district_name'] = this.districtName!.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    data['location'] = this.location;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['image4'] = this.image4;
    data['status'] = this.status;
    data['price'] = this.price;
    data['status_updated_at'] = this.statusUpdatedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_status'] = this.userStatus;
    data['agreed_terms'] = this.agreedTerms;
    data['good_list_id'] = this.goodListId;
    return data;
  }
}

class HouseType {
  String? ar;
  String? en;

  HouseType({this.ar, this.en});

  HouseType.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }
}

class Design {
  int? id;
  HouseType? name;
  String? image;
  dynamic image1;
  dynamic image2;
  dynamic image3;
  HouseType? description;
  String? price;
  String? createdAt;
  String? updatedAt;
  int? goodListId;

  Design(
      {this.id,
      this.name,
      this.image,
      this.image1,
      this.image2,
      this.image3,
      this.description,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.goodListId});

  Design.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new HouseType.fromJson(json['name']) : null;
    image = json['image'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    description = json['description'] != null
        ? new HouseType.fromJson(json['description'])
        : null;
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    goodListId = json['good_list_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name!.toJson();
    }
    data['image'] = this.image;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['good_list_id'] = this.goodListId;
    return data;
  }
}

class Opportunity {
  int? id;
  int? userId;
  HouseType? name;
  String? image1;
  dynamic image2;
  dynamic image3;
  dynamic image4;
  HouseType? location;
  String? totalPrice;
  String? opportunityPrice;
  String? percentNumber;
  String? numberTime;
  String? opportunityCount;
  HouseType? description;
  dynamic numberOpportunityPay;
  String? createdAt;
  String? updatedAt;
  int? goodListId;

  Opportunity(
      {this.id,
      this.userId,
      this.name,
      this.image1,
      this.image2,
      this.image3,
      this.image4,
      this.location,
      this.totalPrice,
      this.opportunityPrice,
      this.percentNumber,
      this.numberTime,
      this.opportunityCount,
      this.description,
      this.numberOpportunityPay,
      this.createdAt,
      this.updatedAt,
      this.goodListId});

  Opportunity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'] != null ? new HouseType.fromJson(json['name']) : null;
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    image4 = json['image4'];
    location = json['location'] != null
        ? new HouseType.fromJson(json['location'])
        : null;
    totalPrice = json['total_price'];
    opportunityPrice = json['opportunity_price'];
    percentNumber = json['percent_number'];
    numberTime = json['number_time'];
    opportunityCount = json['opportunity_count'];
    description = json['description'] != null
        ? new HouseType.fromJson(json['description'])
        : null;
    numberOpportunityPay = json['number_opportunity_pay'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    goodListId = json['good_list_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    if (this.name != null) {
      data['name'] = this.name!.toJson();
    }
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['image4'] = this.image4;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['total_price'] = this.totalPrice;
    data['opportunity_price'] = this.opportunityPrice;
    data['percent_number'] = this.percentNumber;
    data['number_time'] = this.numberTime;
    data['opportunity_count'] = this.opportunityCount;
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    data['number_opportunity_pay'] = this.numberOpportunityPay;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['good_list_id'] = this.goodListId;
    return data;
  }
}

class Other {
  int? id;
  int? userId;
  String? itemType;
  int? itemId;
  String? createdAt;
  String? updatedAt;
  int? goodListId;

  Other(
      {this.id,
      this.userId,
      this.itemType,
      this.itemId,
      this.createdAt,
      this.updatedAt,
      this.goodListId});

  Other.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    itemType = json['item_type'];
    itemId = json['item_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    goodListId = json['good_list_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['item_type'] = this.itemType;
    data['item_id'] = this.itemId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['good_list_id'] = this.goodListId;
    return data;
  }
}

class Seller {
  int? id;
  dynamic name;
  String? email;
  String? logo;
  String? website;
  String? idCard;
  String? commercialRegister;
  String? taxCertificate;
  String? phone;
  String? bankAccountNumber;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic neighborhood;
  int? cityId;
  int? goodListId;
  String? city;

  Seller({
    this.id,
    this.name,
    this.email,
    this.logo,
    this.website,
    this.city,
    this.idCard,
    this.commercialRegister,
    this.taxCertificate,
    this.phone,
    this.bankAccountNumber,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.neighborhood,
    this.cityId,
    this.goodListId,
  });

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    logo = json['logo'];
    website = json['website'];
    city = json["city"];
    idCard = json['id_card'];
    commercialRegister = json['commercial_register'];
    taxCertificate = json['tax_certificate'];
    phone = json['phone'];
    bankAccountNumber = json['bank_account_number'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    neighborhood = json['neighborhood'];
    cityId = json['city_id'];
    goodListId = json['good_list_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['logo'] = logo;
    data['website'] = website;
    data['id_card'] = idCard;
    data['commercial_register'] = commercialRegister;
    data['tax_certificate'] = taxCertificate;
    data['phone'] = phone;
    data['bank_account_number'] = bankAccountNumber;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['neighborhood'] = neighborhood;
    data['city_id'] = cityId;
    data['good_list_id'] = goodListId;
    return data;
  }
}

class Product {
  int? id;
  Map<String, String>? name;
  Map<String, String>? description;
  double? price;
  double? noemalPrice;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  dynamic image;
  dynamic image1;
  dynamic image2;
  int? sellerId;
  int? categoryId;
  String? category;
  int? subCategoryId;
  int? cityId;
  double? tax;
  dynamic discount;
  int? goodListId;

  Product({
    this.id,
    this.category,
    this.discount,
    this.name,
    this.description,
    this.price,
    this.image1,
    this.image2,
    this.noemalPrice,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.sellerId,
    this.categoryId,
    this.subCategoryId,
    this.cityId,
    this.tax,
    this.goodListId,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    discount = json["discount"];
    name = json['name']?.cast<String, String>();
    description = json['description']?.cast<String, String>();
    price = double.tryParse(json['price']?.toString() ?? '');
    noemalPrice = double.tryParse(json['normalPrice']?.toString() ?? '');
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    image1 = json['image1'];
    image2 = json['image2'];
    sellerId = json['seller_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    cityId = json['city_id'];
    tax = double.tryParse(json['tax']?.toString() ?? '');
    goodListId = json['good_list_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['normalPrice'] = noemalPrice;
    data['quantity'] = quantity;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    data['seller_id'] = sellerId;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['city_id'] = cityId;
    data['tax'] = tax;
    data['good_list_id'] = goodListId;
    return data;
  }
}
