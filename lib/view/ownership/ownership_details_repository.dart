import 'package:dio/dio.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/renter_model.dart';
import 'package:rct/shared_pref.dart';

class OwnershipDetailsRepository {
  final Dio _dio = Dio();

  Future<RenterModel> getRenterDetails(String id) async {
    final token = AppPreferences.getData(key: 'loginToken');

    try {
      final response = await _dio.get(
        '$linkServerName/api/renters/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data['data'] ?? {};
        return _mapApiResponseToRenter(data);
      }

      throw Exception('Failed to load ownership details');
    } on DioException catch (e) {
      final message = e.response?.data?['message']?.toString() ?? e.message;
      throw Exception(message ?? 'Network error');
    } catch (e) {
      throw Exception('Error fetching ownership details: $e');
    }
  }

  RenterModel _mapApiResponseToRenter(Map<String, dynamic> json) {
    return RenterModel(
      id: json['id'] as int?,
      title: (json['name'] ?? '').toString(),
      city: (json['city_name'] ?? '').toString(),
      district: (json['district_name'] ?? '').toString(),
      lat: (json['lat'] ?? '0').toString(),
      long: (json['long'] ?? '0').toString(),
      age: _toInt(json['oper_age']),
      paymentPlan: _toInt(json['type_of_return']),
      paymentDuration: (json['project_duration'] ?? '').toString(),
      price: (json['total_price'] ?? '0').toString(),
      firstPayment: (json['opportunity_price'] ?? '').toString(),
      units: _toInt(json['opportunity_count']),
      description: (json['description'] ?? '').toString(),
      images1: _toNullableString(json['image1']),
      images2: _toNullableString(json['image2']),
      images3: _toNullableString(json['image3']),
      images4: _toNullableString(json['image4']),
      file: _toNullableString(json['file']),
    );
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  String? _toNullableString(dynamic value) {
    if (value == null) return null;
    final parsed = value.toString();
    return parsed.isEmpty ? null : parsed;
  }
}
