import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';

// State Classes
class SearchSuccess extends DataState {
  final List<Modelget> searchResults;

  SearchSuccess(this.searchResults);
}

class FilterLoadingsState extends DataState {}

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial());

  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Content-Type': 'application/json',
      "Accept-Language": CacheHelper.getData(key: "lang"),
    },
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  List<Modelget> allDataList = [];
  List<Modelget>? filterList;
  List<Modelget>? searchList;
  List<Modelget>? filterbycategoryList;
  List<Modelget> favoriteList = [];

  // Fetch all data from API
  bool _isDataLoaded = false; // Variable to track if data is already loaded

  Future<void> fetchData(String url) async {
    final String? token = await _getAuthToken();
    emit(DataLoading());

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
        var houses = response.data['houses'];

        if (houses == null || houses.isEmpty) {
          emit(DataError(''));
          return;
        }

        allDataList = houses.map<Modelget>((element) {
          return Modelget.fromJson(element);
        }).toList();

        // Mark data as loaded
        _isDataLoaded = true;

        // Emit success with all data
        emit(DataSuccess(allDataList));
      } else {
        emit(DataError(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeee");
      emit(DataError('Error: $e'));
    }
  }

  Future<void> fetchUnAuthData(String url) async {
    // Retrieve the token (if needed)
    final String? token = await _getAuthToken();

    // Emit loading state
    emit(DataLoading());

    try {
      // Perform the API request
      final response = await _dio.get(
        url,
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          "Accept-Language": CacheHelper.getData(key: "lang"),
        }),
      );

      // Print the response for debugging
      print(response.data);

      if (response.statusCode == 200) {
        var houses = response.data['houses']; // Access the correct key

        if (houses == null || houses.isEmpty) {
          emit(DataError('No data found.'));
          return;
        }

        // Map the data to your model
        allDataList = houses.map<Modelget>((element) {
          return Modelget.fromJson(element);
        }).toList();

        // Mark data as loaded
        _isDataLoaded = true;

        // Emit success state with data
        emit(DataSuccess(allDataList));
      } else {
        emit(DataError(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      // Emit error state with detailed exception message
      emit(DataError('Error occurred: $e'));
    }
  }

  // Method to reset data (if needed)
  void resetData() {
    allDataList.clear();
    _isDataLoaded = false;
  }

  Modelget? productDl;
  Future<void> fetchid(String url) async {
    emit(DataLoading());
    final String? token = await _getAuthToken();
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
        var chances = response.data;
        productDl = Modelget.fromJson(chances);

        int index =
            allDataList.indexWhere((element) => element.id == productDl!.id);
        if (index != -1) {
          allDataList[index] = productDl!;
        } else {
          allDataList.add(productDl!);
        }

        emit(DataSuccess(allDataList));
      } else {
        emit(DataError(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(DataError('Error: $e'));
    }
  }

  bool checkproduct(String id) {
    bool flag = false;
    for (Modelget checkfound in allDataList) {
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
    emit(DataSuccess(allDataList)); // Show all data again
  }

  // Filter data by city, district, and price
  void filterData({
    required String city,
    required String district,
    required int maxPrice,
  }) {
    filterList = allDataList.where((item) {
      final itemPrice = double.tryParse(item.price ?? "0") ?? 0;

      return (item.city_name.toString().toLowerCase().contains(city) &&
          (item.district_name
                  .toString()
                  .removeAllWhitespace
                  .toLowerCase()
                  .contains(district.removeAllWhitespace) &&
              itemPrice <= maxPrice));
    }).toList();

    if (filterList!.isEmpty) {
      emit(DataError(""));
    } else {
      emit(FilterSuccessState(filterList!));
    }
  }

  void filterProperties(
      {required String city, required String district, required int maxPrice}) {
    filterList = allDataList.where((item) {
      final itemPrice = double.tryParse(item.price ?? "0") ?? 0;
      return (city.isEmpty ||
              item.city_name!.toLowerCase().contains(city.toLowerCase())) &&
          (district.isEmpty ||
              item.district_name!
                  .toLowerCase()
                  .contains(district.toLowerCase().trim())) &&
          (itemPrice <= maxPrice);
    }).toList();

    if (filterList!.isEmpty) {
      emit(DataError(""));
    } else {
      emit(FilterSuccessState(filterList!));
    }
  }

  void SearchHouse({required String input}) {
    searchList = allDataList.where((element) {
      bool cityMatches = element.city_name != null &&
          element.city_name!.toLowerCase().contains(input.toLowerCase());
      bool districtMatches = element.district_name != null &&
          element.district_name!.toLowerCase().contains(input.toLowerCase());
      bool name = element.name != null &&
          element.name!.toLowerCase().contains(input.toLowerCase());

      return cityMatches || districtMatches || name;
    }).toList();

    if (searchList!.isNotEmpty) {
      emit(SearchSuccess(searchList!));
    } else {
      emit(DataError(''));
    }
  }

  // Filter by category (e.g., house type)
  Future<void> filterByCategory(String category) async {
    filterbycategoryList = allDataList.where((item) {
      return item.house_type?.toLowerCase() == category.toLowerCase();
    }).toList();

    if (filterbycategoryList!.isEmpty) {
      emit(DataError(""));
    } else {
      emit(FilterCategorySuccessState(filterbycategoryList!));
    }
  }

  // Fetch notifications (not directly related to filtering, but included here)
  Future<void> fetchNotifications() async {
    final url = Uri.parse('$linkServerName/api/testnotification');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List notifications = json.decode(response.body)['notifications'];
      print('Notifications: $notifications');
    } else {
      print('Failed to fetch notifications');
    }
  }

  static DataCubit get(context) => BlocProvider.of(context);
}

Future<String?> _getAuthToken() async {
  return AppPreferences.getData(key: 'loginToken');
}
