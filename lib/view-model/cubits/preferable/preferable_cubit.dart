import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';

part 'preferable_state.dart';

class PreferableCubit extends Cubit<PreferableState> {
  final Dio _dio = Dio(); // Initialize Dio instance

  PreferableCubit() : super(PreferableInitial());

  Future<void> pushPreferable(
      String description, File file, dynamic orderNumber) async {
    emit(PreferableLoading());

    try {
      // Prepare form data
      FormData formData = FormData.fromMap({
        // "user_id": "3",
        "description": description,
        "orderNumber": orderNumber,
        "file": await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
      });

      final token = await _getAuthToken();
      var response = await _dio.post(
        linkPreferables,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $token',
            "Accept-Language":CacheHelper.getData(key: "lang"),
          },
        ),
      );

      // Check if response contains 'data'
      if (response.data != null && response.data['data'] != null) {
        emit(PreferableSuccess());
      } else {
        emit(PreferableFailure(errMessage: response.data.toString())); //
        print(response.data.toString()); // Handle the error case
      }
    } catch (e) {
      emit(PreferableFailure(errMessage: "$e"));
      print(e);
    }
  }
}

Future<String?> _getAuthToken() async {
  return AppPreferences.getData(key: 'loginToken');
}
