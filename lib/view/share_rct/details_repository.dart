import 'package:dio/dio.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/model/investor_upgrade_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:path/path.dart' as p;
import 'package:rct/main.dart';
import 'dart:io';

class ShareDetailsRepository {
  final Dio _dio = Dio();

  Future<Modelget> getOpportunityDetails(String id) async {
    final String? token = await secureStorage.read(key: "token");
    final String lang = await CacheHelper.getData(key: "lang") ?? "ar";
    try {
      final response = await _dio.get(
        '$shareRCT/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Accept-Language': lang,
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Modelget.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load opportunity details');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      }
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching opportunity details: $e');
    }
  }

  Future<List<InvestorQuestion>> getInvestorUpgradeQuestions() async {
    final String? token = await secureStorage.read(key: "token");
    final String lang = CacheHelper.getData(key: "lang") ?? "ar";

    try {
      final response = await _dio.get(
        linkInvestorUpgradeQuestions,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Accept-Language': lang,
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => InvestorQuestion.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load investor upgrade questions');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      }
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  Future<Map<String, dynamic>> submitInvestorUpgrade({
    required Map<int, int> answers,
    required Map<int, List<File>> questionFiles,
  }) async {
    final String? token = await secureStorage.read(key: "token");
    final String lang = CacheHelper.getData(key: "lang") ?? "ar";

    try {
      FormData formData = FormData();
      
      answers.forEach((id, value) {
        formData.fields.add(MapEntry("answers[$id]", value.toString()));
      });

      questionFiles.forEach((id, files) {
        for (var file in files) {
          formData.files.add(MapEntry(
            "files[$id][]",
            MultipartFile.fromFileSync(file.path, filename: p.basename(file.path)),
          ));
        }
      });

      final response = await _dio.post(
        linkSubmitInvestorUpgrade,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Accept-Language': lang,
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response?.data ?? {"status": 500, "message": e.message};
    } catch (e) {
      return {"status": 500, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> initiatePayment({
    required String type,
    required String id,
    required int count,
  }) async {
    final String? token = await secureStorage.read(key: "token");
    final String lang = CacheHelper.getData(key: "lang") ?? "ar";

    try {
      final response = await _dio.post(
        linkInitiatePayment,
        data: {
          "type": type,
          "id": id,
          "count": count,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Accept-Language': lang,
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response?.data ?? {"status": 500, "message": e.message};
    } catch (e) {
      return {"status": 500, "message": e.toString()};
    }
  }
}
