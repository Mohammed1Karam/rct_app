import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/view-model/services/crud.dart';
import 'package:rct/view/share_rct/states.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/linkapi.dart';

/// States
class SearchSuccess extends ShareState {
  final List<Modelget> searchResults;

  SearchSuccess(this.searchResults);
}

class FilterLoadingsState extends ShareState {}

class ShareCubit extends Cubit<ShareState> {
  ShareCubit() : super(ShareInitial()) {}

  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        "Accept-Language": CacheHelper.getData(key: "lang"),
      },
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  List<Modelget> allShareList = [];
  List<Modelget>? filterByCategoryList;
  Modelget? productDl;
  List<Modelget> favoriteList = [];

  bool _isDataLoaded = false;

  Future<void> fetchShare(String url) async {
    final String? token = await _getAuthToken();

    // if (_isDataLoaded) {
    //   If data is already loaded, don't make a network request
    // emit(ShareSuccess(allShareList));
    // return;
    // }
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data["data"];

        var chances = data; // Extract the list of opportunities

        // Map over the chances data to create a list of Modelget objects
        allShareList =
            chances.map<Modelget>((e) => Modelget.fromJson(e)).toList();

        emit(ShareSuccess(allShareList));
      } else {
        emit(ShareError(
            'Failed to load Share. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      print("++++++++++++++++++++++");
      emit(ShareError('Error: $e'));
    }
  }

  void resetData() {
    allShareList.clear();
    _isDataLoaded = false;
  }

  Future<void> fetchid(String url) async {
    emit(ShareLoading());
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        var chances = response.data;
        print(chances);
        productDl = Modelget.fromJson(chances);

        allShareList.add(productDl!);
        emit(ShareSuccess(allShareList));
      } else {
        emit(ShareError(
            'Failed to load Share. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      print("ssssssssssss");
      print(e.toString());
      emit(ShareError('Error: $e'));
    }
  }

  bool checkproduct(String id) {
    bool flag = false;
    for (Modelget checkfound in allShareList) {
      if (checkfound.id == id) {
        flag = true;
      }
    }
    return flag;
  }

  void resetFilters() {
    filterByCategoryList = null;

    emit(ShareSuccess(allShareList)); // Show all data again
  }

  Future<void> filterByCategory(String category) async {
    emit(ShareLoading());
    if (category == "فرص مكتملة" ||
        category == "Completed" ||
        category == "مكتملة") {
      try {
        filterByCategoryList = allShareList.where((item) {
          int total =
              int.tryParse(item.opportunity_count?.toString() ?? '0') ?? 0;
          int paid =
              int.tryParse(item.number_opportunity_pay?.toString() ?? '0') ?? 0;

          // An opportunity is completed if total count > 0 and paid matches or exceeds it
          return total > 0 && paid >= total;
        }).toList();

        if (filterByCategoryList!.isEmpty) {
          emit(ShareError("empty"));
        } else {
          emit(ShareFilterCategorySuccessState(filterByCategoryList!));
        }
      } catch (error) {
        emit(ShareError(error.toString()));
      }
    } else {
      try {
        String newCategory = category;
        if(category == "Property"){
          newCategory = "Existing property";
        }
        filterByCategoryList = allShareList.where((item) {
          return item.type?.toLowerCase() == newCategory.toLowerCase();
        }).toList();

        if (filterByCategoryList!.isEmpty) {
          emit(ShareError(""));
        } else {
          emit(ShareFilterCategorySuccessState(filterByCategoryList!));
        }
      } catch (error) {
        emit(ShareError(error.toString()));
      }
    }
  }

  final Crud crud = Crud();
  List<String> aboutUsList = [];

  Future<void> fetchAboutUs() async {
    emit(GetAboutUsLoadingState());

    try {
      final response = await crud.getRequest(linkaboutUs);
      print(response); // Debugging: inspect the structure of the response

      if (response != null) {
        // Ensure the response is a list, then map the data correctly
        aboutUsList = response["data"]
            .map<String>((item) => item["description"] as String)
            .toList();

        emit(GetAboutUsSuccessState());
      } else {
        emit(GetAboutUsErrorState());

        throw Exception("Invalid response format, expected a List.");
      }
    } catch (e) {
      print("Error fetching About Us data: $e");

      emit(GetAboutUsErrorState());
    }
  }

  List<String> termsConditions = [];
  Future fetchTermsConditions() async {
    emit(GetTermsConditionsLoadingState());
    try {
      final response = await crud.getRequest(linkConditions);
      if (response != null) {
        termsConditions = response["data"]
            .map<String>((item) => item["condition"] as String)
            .toList();
        emit(GetTermsConditionsSuccessState());
      } else {
        emit(GetTermsConditionsErrorState());

        throw Exception("Invalid response format, expected a List.");
      }
    } catch (e) {
      print(e);
      emit(GetTermsConditionsErrorState());
    }
  }

  List<String> privacyList = [];
  Future fetchPrivacyList() async {
    emit(GetPrivacyListLoadingState());
    try {
      final response = await crud.getRequest(linkTerms);
      if (response != null) {
        privacyList = response["data"]
            .map<String>((item) => item["terms"] as String)
            .toList();
        emit(GetPrivacyListSuccessState());
      } else {
        emit(GetPrivacyListErrorState());

        throw Exception("Invalid response format, expected a List.");
      }
    } catch (e) {
      print(e);
      emit(GetPrivacyListErrorState());
    }
  }

  static ShareCubit get(context) => BlocProvider.of(context);
}

Future<String?> _getAuthToken() async {
  return AppPreferences.getData(key: 'loginToken');
}
