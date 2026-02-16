import 'package:flutter/foundation.dart';
import 'package:rct/main.dart';

class Checktoken {
  String? name;
  String? email;
  Future<bool> hasToken() async {
    String? token = await secureStorage.read(key: "token");
    if (token != null) {
      if (kDebugMode) {
        print('Token: $token');
      }
      return token.isNotEmpty;
    }
    if (kDebugMode) {
      print('Token not found');
    }
    return false;
  }
}
