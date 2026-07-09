import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view/partener_success/model.dart';
import 'package:rct/view/partener_success/partener_states.dart';

class ParetenerCubit extends Cubit<PartenerStates> {
  ParetenerCubit() : super(IntialPartenerStates());

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

  List<PartenerModel> data = [];
  bool _isDataLoaded = false; // Cache flag

  Future<void> fetchData() async {
    // if (_isDataLoaded) {
      // If data is already loaded, emit success state with cached data
      // emit(PartenerSuccess(data: data));
      // return;
    // }

    emit(PartenerLoading());
    try {
      final response = await _dio.get(
        "https://rctapp.com/api/clients",
        options: Options(
            headers: {
              "Accept-Language":CacheHelper.getData(key: "lang"),
            }
        ),
      );
      if (response.statusCode == 200) {
        var clients = response.data['data'];

        if (clients == null || clients.isEmpty) {
          emit(PartenerFailed(message: 'No clients available'));
          return;
        }

        // Cache the data
        data = clients
            .map<PartenerModel>((element) => PartenerModel.fromJson(element))
            .toList();

        _isDataLoaded = true; // Mark data as loaded
        emit(PartenerSuccess(data: data));
      } else {
        emit(PartenerFailed(
            message:
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      emit(PartenerFailed(message: 'Error: $e'));
    }
  }

  void resetData() {
    // Clear cached data and reset the flag
    data.clear();
    _isDataLoaded = false;
  }

  // Handle Dio errors in a centralized method
  void _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response?.statusCode == 403) {
        emit(PartenerFailed(
            message: 'Unauthorized access. Please check your credentials.'));
      } else {
        emit(PartenerFailed(
            message:
                'Error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}'));
      }
    } else {
      emit(PartenerFailed(message: 'Error sending request: ${e.message}'));
    }
  }

  static ParetenerCubit get(context) => BlocProvider.of(context);
}
