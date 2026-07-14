import 'package:dio/dio.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/renter_model.dart';
import 'package:rct/shared_pref.dart';

import '../../services/cache_helper.dart';

class OwnershipDetailsRepository {
  final Dio _dio = Dio();

  Future<RenterModel> getRenterDetails(String id) async {
    final token = AppPreferences.getData(key: 'loginToken');
    final String lang =  CacheHelper.getData(key: "lang") ?? "ar";
    try {
      final response = await _dio.get(
        '$linkServerName/api/renters/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Accept-Language': lang,
            if (token != null && token.toString().isNotEmpty) 'Authorization': 'Bearer $token',
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
      title: (json['title'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      district: (json['district'] ?? '').toString(),
      lat: (json['lat'] ?? '0').toString(),
      long: (json['long'] ?? '0').toString(),
      age: _toInt(json['age']),
      rooms: _toInt(json['rooms']),
      bathrooms: _toInt(json['bathrooms']),
      area: _toInt(json['area']),
      paymentPlan: _toInt(json['payment_plan']),
      paymentDuration: (json['payment_duration'] ?? '').toString(),
      price: (json['price'] ?? '0').toString(),
      firstPayment: (json['first_payment'] ?? '').toString(),
      units: _toInt(json['units']),
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
