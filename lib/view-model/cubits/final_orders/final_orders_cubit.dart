import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/services/crud.dart';
import 'package:rct/model/realEstatemodel.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_states.dart';
import 'package:rct/view/favorite/favorites_model.dart';
import 'package:rct/view/final_orders/opportunity_model.dart';
import 'package:rct/view/final_orders/rawlands_model.dart';

class FinalOrdersCubit extends Cubit<FinalOrdersStates> {
  FinalOrdersCubit() : super(InitialFinalOrderStates());
  final Crud _crud = Crud();
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Accept-Language": CacheHelper.getData(key: "lang"),
    },
  ));

  Dio get dio => _dio;
  List<Modelget> realList = [];
  List<Modelget> allData = [];
  List<Modelget> shareRct = [];
  bool _isLoaded = false;
  List<String> imageList = []; // Static list to store images
  List<String> nameList = [];
  List<Modelget> cooperationList = [];
  List<Modelget> designs_Sketches = [];
  List<Modelget> users = [];
  List<Modelget> rctState = [];
  Future<void> RealOrders() async {
    if (_isLoaded && realList.isNotEmpty) {
      emit(RealEstateOrdersSuccess(realList));
    }
    emit(RealEstateOrdersLoading());
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        "$linkServerName/api/user/houses",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        ),
      );

      if (response.statusCode == 200) {
        try {
          var responseData = response.data;

          var houses = responseData['houses'];

          if (houses == null || houses.isEmpty) {
            emit(RealEstateOrdersFaild('''You Do'nt have orders'''));
            return;
          }

          realList = houses
              .map<Modelget>((element) => Modelget.fromJson(element))
              .toList();
          print("tttttttttttttttttttttt");
          print(realList);

          emit(RealEstateOrdersSuccess(realList));
          _isLoaded = true;
          // if (realList.isEmpty) {
          //   emit(RealEstateOrdersFaild('''You Do'nt have orders'''));
          // } else {
          //   emit(RealEstateOrdersSuccess(realList));
          //   _isLoaded = true;
          // }
        } catch (e) {
          emit(RealEstateOrdersFaild('Failed to decode houses data'));
        }
      } else {
        emit(RealEstateOrdersFaild(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      emit(RealEstateOrdersFaild(
          'Dio error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}, HEADERS: ${e.response?.headers}'));
    } catch (e) {
      emit(RealEstateOrdersFaild('Unexpected error: $e'));
    }
  }

  int currentPage = 1; // Track the current page
  bool isLoadingMore =
      false; // Flag to prevent loading multiple pages simultaneously
  final int itemsPerPage = 10; // Define how many items per page to fetch

  List<OpportunityModel> opportunity = [];
  Future<void> ShareRct() async {
    if (_isLoaded && opportunity.isNotEmpty) {
      emit(ShareOrdersSuccess(opportunity));
    }
    emit(ShareOrdersLoading());
    final token = await _getAuthToken();
    print("token: $token");

    try {
      final response = await _dio.get(
        "$linkServerName/api/opportunities/user/opportunities",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print("responseData: $responseData");

      /*  final status = responseData['status'];
        if (status != 'true') {
          emit(RealEstateOrdersFaild('Request failed: status= $status'));
          return;
        }*/
        opportunity = (responseData['data']['opportunities'] as List)
            .map<OpportunityModel>(
                (json) => OpportunityModel.fromMap(json))
            .toList();
        emit(ShareOrdersSuccess(opportunity));
      } else {
        emit(ShareOrdersFaild(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      emit(ShareOrdersFaild(
          'Dio error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}, HEADERS: ${e.response?.headers}'));
    } catch (e) {
      emit(ShareOrdersFaild('Unexpected error: $e'));
    }
  }

  RawLandsModel? rawLandsModel;
  Future<void> RawLand({bool fromInit = true}) async {
    if (_isLoaded && cooperationList.isNotEmpty) {
      emit(RawLandOrdersSuccess(cooperationList));
    }
    if (fromInit) {
      emit(RawLandOrdersLoading());
    }
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        "$linkServerName/api/user/rawlands",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        print("API Response Data: $responseData");

        if (responseData is Map<String, dynamic>) {
          var rawLandsData = responseData['rawLands'] ?? [];

          var oldBuildingsData = responseData['oldBuildings'] ?? [];

          var Schema = responseData['Schema'] ?? [];

          List<Modelget> rawLandList = [];

          rawLandList = rawLandsData
              .map<Modelget>((element) => Modelget.fromJson(element))
              .toList();

          List<Modelget> oldBuildingsList = [];

          oldBuildingsList = oldBuildingsData
              .map<Modelget>((element) => Modelget.fromJson(element))
              .toList();

          List<Modelget> schema = [];

          schema = Schema.map<Modelget>((element) => Modelget.fromJson(element))
              .toList();

          cooperationList = [...rawLandList, ...oldBuildingsList, ...schema];

          emit(RawLandOrdersSuccess(cooperationList));
          _isLoaded = true;
        } else {
          emit(RawLandOrdersFaild('Invalid JSON structure'));
        }
      } else {
        emit(RawLandOrdersFaild(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(RawLandOrdersFaild('Error: ${e.toString()}'));
    }
  }

  Future<void> DesignsAndScketches({bool fromInit = true}) async {
    // if (_isLoaded && allData.isNotEmpty) {
    // Emit the cached data if already loaded
    // emit(DesignsSuccess(allData));
    // return;
    // }
    allData.clear();
    if (fromInit) {
      emit(DesignsLoading());
    }

    final token = await _getAuthToken();

    try {
      // Make API request
      final response = await _dio.get(
        "$linkServerName/api/design-and-sketches",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Secure token management
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        // print('API Response for designs: ${response.data['sketches']}');

        // Check if the response is valid
        if (responseData is Map<String, dynamic>) {
          // Extract designs, sketches, and preferables from the response
          var designsData = responseData['designs']?['data'] ?? [];
          var sketchesData = responseData['sketches']?['data'] ?? [];
          var preferablesData = responseData['preferables']?['data'] ?? [];

          // Check and convert each list
          if (designsData is List) {
            var designs = designsData
                .map<Modelget>((element) => Modelget.fromJson(element))
                .toList();
            allData.addAll(designs);
          } else {
            emit(DesignsFaild(
                'Unexpected data type for designs: ${designsData.runtimeType}'));
          }

          if (sketchesData is List) {
            var sketches = sketchesData
                .map<Modelget>((element) => Modelget.fromJson(element))
                .toList();
            allData.addAll(sketches);
          } else {
            emit(DesignsFaild(
                'Unexpected data type for sketches: ${sketchesData.runtimeType}'));
          }

          if (preferablesData is List) {
            var preferables = preferablesData
                .map<Modelget>((element) => Modelget.fromJson(element))
                .toList();
            allData.addAll(preferables);
          } else {
            emit(DesignsFaild(
                'Unexpected data type for preferables: ${preferablesData.runtimeType}'));
          }

          // Check if data is populated
          if (allData.isNotEmpty) {
            _isLoaded = true; // Mark data as loaded
            emit(DesignsSuccess(allData)); // Emit success with cached data
          } else {
            emit(DesignsFaild('No data available'));
          }
        } else {
          emit(DesignsFaild('Invalid JSON structure'));
        }
      } else {
        emit(DesignsFaild(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(DesignsFaild('Error: ${e.toString()}'));
    }
  }

  Future<void> PostDes(BuildContext context) async {
    Modelget modelget = Provider.of<Modelget>(context, listen: false);
    HouseModel houseModel = Provider.of<HouseModel>(context, listen: false);
    emit(DesignsLoading());

    try {
      print("Description: ${houseModel.description}");
      print("Order Number: ${houseModel.orderNumber}");
      print("Order Number: ${houseModel.design_id}");
      print("Order Number: ${houseModel.status}");

      var result = await _crud.postRequest(
        "$linkServerName/api/design-and-sketches",
        {
          "description": houseModel.description,
          // "user_id": "",
          "design_id": houseModel.design_id,
          "orderNumber": houseModel.orderNumber,
          "status": "pending",
        },
      );

      print("Response from API: $result");

      if (result.containsKey("data")) {
        emit(DesignsSuccess(designs_Sketches));
      } else {
        emit(DesignsFaild(result["message"]));
      }
    } catch (e) {
      emit(DesignsFaild("Error: $e"));
      print("Error during POST request: $e");
    }
  }

  Future<void> PostSketch(BuildContext context) async {
    HouseModel houseModel = Provider.of<HouseModel>(context, listen: false);
    emit(SketchLoading22());

    try {
      print("Description: ${houseModel.description}");
      print("Order Number: ${houseModel.orderNumber}");
      print("id: ${houseModel.design_id}");
      print("status: ${houseModel.status}");

      var result = await _crud.postRequest(
        "$linkServerName/api/sketch_and_designs",
        {
          "description": houseModel.description,
          // "user_id": "34",
          "sketch_id": houseModel.design_id,
          "orderNumber": houseModel.orderNumber,
          "status": "pending",
        },
      );

      print("Response from API: $result");

      if (result.containsKey("data")) {
        emit(SketchSuccess22(designs_Sketches));
      } else {
        emit(SketchFaild22(result["message"]));
      }
    } catch (e) {
      emit(SketchFaild22("Error: $e"));
      print("Error during POST request: $e");
    }
  }

//    myImage;
// final myName;
  Future<void> Users() async {
    emit(UserLoading());
    final token = await _getAuthToken();

    try {
      final response = await _dio.get(
        "$linkServerName/api/user",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData?['id'] != null && responseData?['name'] != null) {
          final user = Modelget.fromJson(responseData);

          // Generate image URL
          final myImage = "$linkServerName/${responseData["image"]}";
          final myName = responseData["name"];

          // Save to preferences
          await Future.wait([
            AppPreferences.saveData(key: 'myimage', value: myImage),
            AppPreferences.saveData(key: 'myname', value: myName),
          ]);

          emit(UserSucess(
            [user],
            myName: responseData["name"],
            myImage: "$linkServerName/${responseData["image"]}",
          ));
        } else {
          emit(UserFaild('حاول مجددا'));
        }
      } else {
        emit(UserFaild('حاول مجددا'));
      }
    } on DioException catch (e) {
      emit(UserFaild('حاول مجددا'));
      debugPrint('حاول مجددا');
    } catch (e) {
      emit(UserFaild('حاول مجددا'));
      debugPrint('Error: $e');
    }
  }

  Future<void> PostSketchWithoutOrderNum({
    required String id,
    required String price,
  }) async {
    final token = await _getAuthToken();

    emit(SketchLoading22());

    try {
      var result = await _crud.postRequestwithHeaders(
        "$linkServerName/api/orders",
        {
          "sketch_id": id,
          "cost": price,
        },
        headers: {
          'Authorization': 'Bearer $token',
          "Accept-Language": CacheHelper.getData(key: "lang"),
        },
      );

      print("Response from API: $result");

      if (result.containsKey("data")) {
        emit(SketchSuccess22(designs_Sketches));
      } else {
        emit(SketchFaild22(result["message"]));
      }
    } catch (e) {
      emit(SketchFaild22("Error: $e"));
      print("Error during POST request: $e");
    }
  }

  Future<void> PostDesignhWithoutOrderNum({
    required String id,
    required String price,
  }) async {
    final token = await _getAuthToken();

    emit(DesignsLoading());

    try {
      var result = await _crud.postRequestwithHeaders(
        "$linkServerName/api/orders",
        {
          "design_id": id,
          "cost": price,
        },
        headers: {
          'Authorization': 'Bearer $token',
          "Accept-Language": CacheHelper.getData(key: "lang"),
        },
      );

      print("Response from API: $result");

      if (result.containsKey("data")) {
        emit(DesignsSuccess(designs_Sketches));
      } else {
        emit(DesignsFaild(result["message"]));
      }
    } catch (e) {
      emit(DesignsFaild("Error: $e"));
      print("Error during POST request: $e");
    }
  }

//for orders
  Future<void> deleteUserAsset(
      String assetId, String assetType, BuildContext context) async {
    const String url = '$linkServerName/api/delete-user-asset';
    final String? token = await _getAuthToken();

    if (token == null) {
      print('Error: Authorization token is null.');
      return;
    }

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
        ),
        data: {
          'id': assetId,
          'type': assetType,
        },
      );

      if (response.statusCode == 200) {
        print('Asset deleted successfully');
      } else {
        print("/////////////////////////////////////");
        print(' Message: ${response.statusMessage}');
      }
    } on DioError catch (dioError) {
      print("+++++++++++++++++++++++++++++++++");

      print('DioError occurred: ${dioError.message}');
      if (dioError.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(dioError.response?.data["message"] ?? "error occurred"),
            backgroundColor: Colors.red,
          ),
        );
        print(
            'Response: ${dioError.response?.statusCode}, Data: ${dioError.response?.data}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  static FinalOrdersCubit get(BuildContext context) => BlocProvider.of(context);
}

Future<String?> _getAuthToken() async {
  return AppPreferences.getData(key: 'loginToken');
}
