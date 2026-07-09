import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:rct/model/renter_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/ownership/renter_payment_handler.dart';

import '../../common copounents/sharewepview.dart';
import '../../constants/linkapi.dart';
import '../../model/contract_model.dart';
import '../../services/cache_helper.dart';

part 'renters_state.dart';

class RentersCubit extends Cubit<RentersState> {
  RentersCubit() : super(RentersInitial());
  static RentersCubit get(BuildContext context) => BlocProvider.of(context);

  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Content-Type': 'application/json',
      "Accept-Language": CacheHelper.getData(key: "lang"),
    },
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  List<RenterModel> allRenterList = [];
  List<ContractModel> allContractList = [];
  List<RenterModel>? filterList;
  List<RenterModel>? searchList;
  List<RenterModel>? filterbycategoryList;
  List<RenterModel> favoriteList = [];

  bool _isDataLoaded = false;

  Future<void> fetchData(String url) async {
    final String? token = await _getAuthToken();

    emit(GetRenterLoading());

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
      print(response.statusCode);
      if (response.statusCode == 200) {
        var renters = response.data['data'];

        if (renters == null || renters.isEmpty) {
          emit(GetRenterError());
          return;
        }

        allRenterList = renters.map<RenterModel>((element) {
          return RenterModel.fromMap(element);
        }).toList();

        // Mark data as loaded
        _isDataLoaded = true;

        // Emit success with all data
        emit(GetRenterSuccess(allRenterList));
      } else {
        emit(GetRenterError(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeee");
      emit(GetRenterError('Error: $e'));
    }
  }

  Future<void> fetchUnAuthData(String url) async {
    final String? token = await _getAuthToken();

    // Emit loading state
    emit(GetRenterLoading());

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          "Accept-Language": CacheHelper.getData(key: "lang").toString(),
        }),
      );

      // Print the response for debugging
      print(response.data);

      if (response.statusCode == 200) {
        var houses = response.data['data']; // Access the correct key

        if (houses == null || houses.isEmpty) {
          emit(GetRenterError('No data found.'));
          return;
        }

        // Map the data to your model
        allRenterList = houses.map<RenterModel>((element) {
          return RenterModel.fromMap(element);
        }).toList();

        // Mark data as loaded
        _isDataLoaded = true;

        // Emit success state with data
        emit(GetRenterSuccess(allRenterList));
      } else {
        emit(GetRenterError(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      // Emit error state with detailed exception message
      emit(GetRenterError('Error occurred: $e'));
    }
  }

  // Method to reset data (if needed)
  void resetData() {
    allRenterList.clear();
    _isDataLoaded = false;
  }

  RenterModel? productDl;
  Future<void> fetchid(String url) async {
    emit(GetRenterLoading());
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) if (response.statusCode == 200) {
        var chances = response.data;
        productDl = RenterModel.fromMap(chances);

        allRenterList.add(productDl!);
        emit(GetRenterSuccess(allRenterList));
      } else {
        emit(GetRenterError(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(GetRenterError('Error: $e'));
    }
  }

  bool checkproduct(String id) {
    bool flag = false;
    for (RenterModel checkfound in allRenterList) {
      if (checkfound.id == id) {
        flag = true;
      }
    }
    return flag;
  }

  // Reset filters and show all data
  void resetFilters() {
    filterList = null;
    searchList = null;
    filterbycategoryList = null;
    emit(GetRenterSuccess(allRenterList)); // Show all data again
  }

  void filterData({
    required String city,
    required String district,
    required int maxPrice,
  }) {
    filterList = allRenterList.where((item) {
      final itemPrice = double.tryParse(item.price ?? "0") ?? 0;

      return (item.city.toString().toLowerCase().contains(city) &&
          (item.district
                  .toString()
                  .removeAllWhitespace
                  .toLowerCase()
                  .contains(district.removeAllWhitespace) &&
              itemPrice <= maxPrice));
      // }
    }).toList();

    if (filterList!.isEmpty) {
      emit(GetRenterError(""));
    } else {
      emit(FilterSuccessState(filterList!));
    }
  }

  void filterProperties({ required String city,
    required String district,
    required int maxPrice}){
    filterList = allRenterList.where((item){
      final itemPrice = double.tryParse(item.price ?? "0") ?? 0;
      return (city.isEmpty || item.city!.toLowerCase().contains(city.toLowerCase()))
          && (district.isEmpty || item.district!.toLowerCase().contains(district.toLowerCase().trim()))
          && (itemPrice <= maxPrice);
    }).toList();

    if(filterList!.isEmpty){
      emit(GetRenterError(""));
    }else{
      emit(FilterSuccessState(filterList!));
    }
  }

  void SearchHouse({required String input}) {
    searchList = allRenterList.where((element) {
      bool cityMatches = element.city != null &&
          element.city!.toLowerCase().contains(input.toLowerCase());
      bool districtMatches = element.district != null &&
          element.district!.toLowerCase().contains(input.toLowerCase());
      bool name = element.title != null &&
          element.title!.toLowerCase().contains(input.toLowerCase());

      return cityMatches || districtMatches || name;
    }).toList();
    print(searchList);

    if (searchList!.isNotEmpty) {
      emit(SearchSuccess(searchList!));
    } else {
      emit(GetRenterError(''));
    }
  }

  Future<void> PayContract(
      {required BuildContext context,
      required RenterModel model,
      required int unitsCount}) async {
    emit(PayContractLoading());
    try {
      final token = await _getAuthToken();
      print('TOKEN: $token');
      print('ID: ${model.id}');
      var data = json.encode({
        "type": "renter",
        "id": model.id,
        "payment_type": "down_payment",
        "units_count": unitsCount,
        "agreement_number": "${DateTime.now().millisecondsSinceEpoch}",
        "phone": AppPreferences.getData(key: "phone"),
        "city": model.city,
        "district": model.district,
      });
      print('Request Body: $data');
      final postResponse = await _dio.post(
        '$linkServerName/api/payments/initiate',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('Response Status: ${postResponse.statusCode}');
      print('Response Data: ${postResponse.data}');
      final responseData = postResponse.data;
      final status = responseData['success'];
      if (status == true) {
        final redirectUrl = postResponse.data['data']['redirect_url'];
        print('Redirect URL: $redirectUrl');
        if (redirectUrl != null) {
          AppPreferences.saveData(key: "redirectUrl", value: redirectUrl);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SharePaymentWebViewScreen(paymentUrl: redirectUrl),
            ),
          );
          emit(PayContractSuccess());
        } else {
          emit(PayContractError('خطأ: رابط إعادة التوجيه فارغ.'));
        }
      } else {
        emit(PayContractError(postResponse.statusMessage));
      }
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SharePaymentWebViewScreen(
              paymentUrl: AppPreferences.getData(key: "redirectUrl") ?? ''),
        ),
      );
      emit(PayContractError('خطأ في معالجة الدفع '));
    }
  }

  Future<void> getContract() async {
    // if (_isDataLoaded) {
    //   emit(GetContractSuccess(allContractList));
    //   return;
    // }
    emit(GetContractLoading());
    final token = await _getAuthToken();
    print(token);
    try {
      final response = await _dio.get(
        '$linkServerName/api/renter-contracts',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data["data"]}');

      if (response.statusCode == 200) {
          allContractList = (response.data["data"] as List).map((contract) => ContractModel.fromMap(contract)).toList();
          print('contacts fetched and stored successfully');
          _isDataLoaded = true;
          emit(GetContractSuccess(allContractList));
      } else {
        emit(GetContractError('Failed to fetch contracts.'));
      }
    } catch (error) {
      print('Error fetching contract: $error');
      emit(GetContractError('Error occurred while fetching contract: $error'));
    }
  }
}

Future<String?> _getAuthToken() async {
  return AppPreferences.getData(key: 'loginToken');
}
