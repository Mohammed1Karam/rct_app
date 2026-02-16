import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';
import 'package:rct/view/favorite/favorites_model.dart';

class FavouriteCubit extends Cubit<DataState> {
  FavouriteCubit() : super(FavouriteLoading());

  List<dynamic> houseList = [];
  List<dynamic> opportunityList = [];
  List<dynamic> _designList = [];
  List<dynamic> _schemaList = [];
  List<dynamic> _combinedList = [];
  List<dynamic> seller = [];
  List<dynamic> products = [];
  FavoritesModel? favoritesModel;
  final Dio _dio = Dio();

  bool _isDataLoaded = false; // Tracks if data is loaded

  /// Fetch list based on category
  Future<void> fetchList(String category) async {
    emit(FavouriteLoading()); // Emit loading state

    final token = await _getAuthToken();
    if (token == null) {
      emit(FavouriteError("Authentication token is missing"));
      return;
    }

    try {
      final response = await _dio.get(
        '$linkServerName/api/good-list',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        ),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        favoritesModel = FavoritesModel.fromJson(response.data);
        emit(GetFavoritesSuccessState());
        final data = response.data;
        if (data is Map && data.containsKey('data')) {
          final categoryData = data['data'][category];
          if (categoryData is List) {
            _updateCategoryList(category, categoryData);
          } else {
            _updateCategoryList(category, []);
          }
        } else {
          _updateCategoryList(category, []);
        }

        _isDataLoaded = true; // Mark data as loaded
      } else {
        emit(FavouriteError(
            "Failed to fetch data. Status: ${response.statusCode}"));
      }
    } catch (e) {
      log("Error fetching data: $e");
      emit(FavouriteError("An error occurred while fetching data"));
    }
  }

  /// Helper method to update the respective category list
  void _updateCategoryList(String category, List<dynamic> newList) {
    switch (category) {
      case 'House':
        houseList = newList;
        break;
      case 'Opportunity':
        opportunityList = newList;
        break;
      case 'Design':
        _designList = newList;
        break;
      case 'Sketch':
        _schemaList = newList;
        break;
      case 'Product':
        products = newList;
        break;
      case 'Seller':
        seller = newList;
        break;
    }
    emit(FavouriteSuccess(newList, true)); // Emit loaded state
  }

  /// Fetch individual lists
  Future<void> getGoodList() => fetchList('House');

  Future<void> getChances() => fetchList('Opportunity');

  Future<void> getDesign() => fetchList('Design');

  Future<void> getSchema() => fetchList('Sketch');
  Future<void> getproduct() => fetchList('Product');

  Future<void> getSeller() => fetchList('Seller');

  /// Fetch combined list
  Future<void> fetchCombinedList() async {
    if (_isDataLoaded) {
      // If data is already loaded, emit the current combined list
      emit(FavouriteSuccess(_combinedList, true));
      return;
    }

    try {
      emit(FavouriteLoading());

      // Fetch Design and Schema data
      await Future.wait([getDesign(), getSchema()]);

      // Combine lists
      _combinedList = [..._designList, ..._schemaList];
      emit(FavouriteSuccess(_combinedList, true));
      _isDataLoaded = true; // Mark combined data as loaded
    } catch (e) {
      log("Error fetching combined list: $e");
      emit(FavouriteError("Failed to fetch combined list"));
    }
  }

  /// Add an item to the list
  Future<void> postGoodList(String itemId, String type) async {
    const String url = "$linkServerName/api/good-list";
    final token = await _getAuthToken();

    if (token == null) {
      emit(FavouriteError("Authentication token is missing"));
      return;
    }

    final requestData = {
      "item_id": itemId,
      "type": type,
    };

    try {
      final response = await _dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isDataLoaded = false; // Reset flag to allow data refresh
        await getGoodList(); // Refresh the list after adding
      } else {
        emit(FavouriteError(
            "Failed to add item. Status: ${response.statusCode}"));
      }
    } catch (e) {
      log("Error posting good list: $e");
      emit(FavouriteError("An error occurred while adding the item"));
    }
  }

  /// Delete an item from the list
  Future<void> deleteGoodList(String itemId) async {
    final url = "$linkServerName/api/good-list/$itemId";
    final token = await _getAuthToken();

    if (token == null) {
      emit(FavouriteError("Authentication token is missing"));
      return;
    }

    try {
      final response = await _dio.delete(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _isDataLoaded = false; // Reset flag to allow data refresh
        await getGoodList(); // Refresh the list after adding

        // emit(FavouriteSuccess([], false));
      } else {
        emit(FavouriteError(
            "Failed to delete the item. Status: ${response.statusCode}"));
      }
    } catch (e) {
      if (e is DioException) {
        print("pppppppppppppppppppppppppppppppppppppppp");
        print(e.response);
      }
      log("Error deleting item: $e");
      emit(FavouriteError("An error occurred while deleting the item"));
    }
  }

  Future<List<int>> fetchGoodListIds() async {
    final token = await _getAuthToken();
    const url = '$linkServerName/api/good-list';

    if (token == null) {
      emit(FavouriteError("Authentication token is missing"));
      return [];
    }

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        ),
      );
      if (response.statusCode == 200) {
        final houseData = response.data['data']['House'] as List;
        final designData = response.data['data']['Design'] as List;

        final List<int> houseIds =
            houseData.map((item) => item['id'] as int).toList();
        final List<int> designIds =
            designData.map((item) => item['id'] as int).toList();

        final List<int> allIds = []
          ..addAll(houseIds)
          ..addAll(designIds);

        return allIds;
      } else {
        emit(FavouriteError("Failed to fetch good list IDs"));
        return [];
      }
    } catch (e) {
      log('Error fetching good list IDs: $e');
      emit(FavouriteError("An error occurred while fetching good list IDs"));
      return [];
    }
  }

  /// Fetch the authentication token from shared preferences
  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  /// Reset data load flag for manual refresh
  void resetDataLoadedFlag() {
    _isDataLoaded = false;
  }
}
