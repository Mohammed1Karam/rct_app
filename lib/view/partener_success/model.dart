class PartenerModel {
  final String? image;
  final String? name;
  final String? id;
  final String? description;

  PartenerModel({
    this.id,
    this.description,
    this.image,
    this.name,
  });

  factory PartenerModel.fromJson(Map<String, dynamic> json) {
    return PartenerModel(
      id: json['id'].toString(),
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'image': image,
      'name': name,
      'id': id,
    };
  }
}
