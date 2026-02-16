import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/services/crud.dart';
import 'package:rct/view/notification/notify_model.dart';
import 'package:rct/view/notification/states.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

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
  List<NotificationModel> allDataList = [];

  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  bool _isDataLoaded = false;
// Method to fetch notifications from the API
  Future<void> fetchNotifications() async {
    if (_isDataLoaded) {
      // If data is already loaded, don't make a network request
      emit(NotificationLoaded(allDataList));
      return;
    }
    emit(NotificationLoading());
    final token = await _getAuthToken();
    print(token);
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Accept-Language'] = CacheHelper.getData(key: "lang");
      // Ensure token is included
      final response = await dio.get(notificationsLink);

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        print(data['notifications'].length);
        if (data['notifications'] is List) {
          // Map the notifications data to NotificationModel and store in allDataList
          allDataList = (data['notifications'] as List)
              .map((notificationData) =>
                  NotificationModel.fromJson(notificationData))
              .toList();

          print('Notifications fetched and stored successfully');
          _isDataLoaded = true;
          emit(NotificationLoaded(allDataList));
        } else {
          emit(NotificationError('Notifications data is invalid.'));
        }
      } else {
        emit(NotificationError('Failed to fetch notifications.'));
      }
    } catch (error) {
      print('Error fetching notifications: $error');
      emit(NotificationError(
          'Error occurred while fetching notifications: $error'));
    }
  }

  void resetData() {
    allDataList.clear();
    _isDataLoaded = false;
  }

  // Method to post notification (existing code for posting notifications)
  // List<NotificationModel> postNotification = [];
  Future<void> postNotify({
    required int data_id,
    required String type,
    required int agreed_terms,
    File? file,
  }) async {
    final token = await _getAuthToken();

    // Prepare the images map
    Map<String, File?> images = {};
    if (file != null) {
      images['file'] = file;
    }

    emit(PostLoading());
    try {
      final response = await _crud.postRequestWithFiles(
        "$linkServerName/api/accept-admin-offer",
        {
          "data_id": data_id,
          "agreed_terms": agreed_terms,
          "type": type,
        },
        images,
        headers: {
          'Authorization': 'Bearer $token',
          "Accept-Language": CacheHelper.getData(key: "lang"),
        },
      );

      print('API response: ${response.toString()}');

      if (response is Map<String, dynamic>) {
        if (response.containsKey("data")) {
          final data = response["data"];
          emit(PostSuccess());
        } else if (response.containsKey("message")) {
          final message = response["message"];
          emit(PostSuccess());
        } else {
          emit(PostFailure(
              errMessage:
                  "Unexpected response format: Missing 'data' or 'message' key."));
        }
      } else {
        emit(PostFailure(errMessage: "Unexpected response format: $response"));
      }
    } catch (e) {
      emit(PostFailure(errMessage: "Error occurred: ${e.toString()}"));
    } finally {
      emit(NotificationLoaded(allDataList));
    }
  }

  Future<void> resetUnreadCount() async {
    final token = await _getAuthToken();
    const String url = '$linkServerName/api/reset-unread-count';
    final Dio dio = Dio();

    try {
      // Set the authorization header
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Make the POST request
      final Response response = await dio.post(url);

      // Handle the response
      if (response.statusCode == 200) {
        print('Unread count reset successfully: ${response.data}');
      } else {
        print(
            'Failed to reset unread count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while resetting unread count: $e');
    }
  }

  static NotificationCubit get(BuildContext context) =>
      BlocProvider.of(context);
}
