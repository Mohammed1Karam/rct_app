import 'package:dio/dio.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/shared_pref.dart';

class NotificationService {
  final Dio _dio = Dio();

  Future<int> getUnreadCount() async {
    final token = await _getAuthToken();
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('$linkServerName/api/get-unread-count');

      if (response.statusCode == 200) {
        return response.data['unread_count'] ??
            0; // Return unread count, defaulting to 0 if not available
      } else {
        throw Exception('Failed to load unread count');
      }
    } catch (e) {
      print('Error: $e');
      return 0; // In case of error, return 0
    }
  }

  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }
}
