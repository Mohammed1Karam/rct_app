import 'package:dio/dio.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/main.dart';
import 'package:rct/model/modelget.dart';

class RealEstateDetailsRepository {
  final Dio _dio = Dio();

  Future<Modelget> getPropertyDetails(String id) async {
    final String? token = await secureStorage.read(key: 'token');
    try {
      final response = await _dio.get(
        '$linkServerName/api/houses/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Modelget.fromJson(response.data['data']);
      }

      throw Exception('Failed to load property details');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      }
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching property details: $e');
    }
  }
}
