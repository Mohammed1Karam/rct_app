class PercentageData {
  final dynamic id;
  final dynamic firstPercentage;
  final dynamic secondPercentage;
  final dynamic lastPercentage;
  final DateTime createdAt;
  final DateTime updatedAt;

  PercentageData({
    required this.id,
    required this.firstPercentage,
    required this.secondPercentage,
    required this.lastPercentage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PercentageData.fromJson(Map<String, dynamic> json) {
    return PercentageData(
      id: json['id'],
      firstPercentage: json['first_percentage'],
      secondPercentage: json['second_percentage'],
      lastPercentage: json['last_percentage'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
