class DesignsModel {
  int? id;
  String? name;
  String? image;
  String? image1;
  String? image2;
  String? image3;
  String? description;
  dynamic price;
  String? createdAt;
  String? updatedAt;
  bool? isInGoodlist;
  int? goodlistId;
  int? userId;

  DesignsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    description = json['description'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isInGoodlist = json['is_in_goodlist'];
    goodlistId = json['goodlist_id'];
    userId = json['user_id'];
  }
}
