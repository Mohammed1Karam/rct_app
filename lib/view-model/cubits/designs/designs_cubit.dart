import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/model/designs_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/cubits/designs/designs_state.dart';
import 'package:rct/constants/linkapi.dart';

import '../../../services/cache_helper.dart';

class DesignsCubit extends Cubit<DesignsState> {
  final Dio _dio = Dio(); // Initialize Dio for HTTP requests
  List<Map<String, dynamic>> _favoriteList = [];

  DesignsCubit() : super(DesignsInitial()) {
// Load favorites when cubit is initialized
  }

  List<Map<String, dynamic>> get favoriteList => _favoriteList;

  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  List<Map<String, dynamic>> alldata = [];
  bool _isDataLoaded = false;
  List<DesignsModel> designsModel = [];
  Future<void> loadDesigns(BuildContext context) async {
    print("sssssssssssssssssss");

    final token = await _getAuthToken();

    if (token == null || token.isEmpty) {
      emit(DesignsFailure(errMessage: "Invalid or missing token"));
      return;
    }

    if (kDebugMode) {
      print('Token: $token');
      print('API Endpoint: $linkDesign');
    }

    try {
      final response = await _dio.get(
        linkDesign,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),

          },
        ),
      );

      if (kDebugMode) {
        print('Response Status Code: ${response.statusCode}');
        print('Response Data: ${response.data}');
      }
      print("---------------------------------");
      print(response.data);

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic> &&
            response.data.containsKey('data')) {
          final List<dynamic> dataList = response.data['data'];
          designsModel.clear();

          for (var item in dataList) {
            designsModel.add(DesignsModel.fromJson(item));
          }

          alldata = List<Map<String, dynamic>>.from(dataList);
          _isDataLoaded = true; // Mark data as loaded
          emit(DesignsSuccess(designs: alldata));
          print("ddddddddddddddddddd");
          print(designsModel);
        } else {
          emit(DesignsFailure(
            errMessage: 'Unexpected response format: ${response.data}',
          ));
        }
      } else {
        emit(DesignsFailure(
          errMessage: 'Failed with status code: ${response.statusCode}',
        ));
      }
    } catch (e, stackTrace) {
      emit(DesignsFailure(errMessage: "Error: $e"));
      if (kDebugMode) {
        print('Exception: $e');
        print('Stack Trace: $stackTrace');
      }
    }
  }

  void resetData() {
    favoriteList.clear();
    _isDataLoaded = false;
  }

  static DesignsCubit get(context) => BlocProvider.of(context);
}
