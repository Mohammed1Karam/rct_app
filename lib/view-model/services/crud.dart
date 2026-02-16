import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/auth/login_model.dart';
import 'package:rct/services/cache_helper.dart';

class Crud {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<List<dynamic>> getRequestGoogleMaps(
    String url,
  ) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> responseBody = jsonDecode(response.body)["predictions"];
        return responseBody;
      } else {
        throw "Failed to load data: ${response.statusCode}";
      }
    } catch (e) {
      throw "Failed to load data: $e";
    }
  }

  Future getRequest(String url) async {
    String? token = await secureStorage.read(key: "token");
    // initializeToken();
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        "Accept-Language":CacheHelper.getData(key: "lang"),
      });
      // Check status code
      if (response.statusCode == 200) {
        // Successful response, parse and return data
        // print(response.body);
        return jsonDecode(response.body);
      } else {
        // Handle non-200 status codes
        if (kDebugMode) {
          print('Failed to load data: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw 'Failed to load data: ${response.statusCode}';
      }
    } catch (e) {
      // Catch any other exceptions
      if (kDebugMode) {
        print('Failed to load data: $e');
      }
      throw 'Failed to load data: $e';
    }
  }

  Future<Map> postRequest(
    String url,
    Map data,
  ) async {
    String? token = await secureStorage.read(key: "token");

    // initializeToken();
    try {
      // print("toooookeeeeennnn:  $token");
      var response = await http.post(Uri.parse(url), body: data, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        "Accept-Language":CacheHelper.getData(key: "lang"),
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print(jsonDecode(response.body));
        }
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error :$e");
      }
      throw "Failed to load data: $e";
    }
  }

  Future<Map> postRequestwithHeaders(String url, Map data,
      {required Map<String, String> headers}) async {
    String? token = await secureStorage.read(key: "token");

    // initializeToken();
    try {
      // print("toooookeeeeennnn:  $token");
      var response = await http.post(Uri.parse(url), body: data, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        "Accept-Language":CacheHelper.getData(key: "lang"),
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print(jsonDecode(response.body));
        }
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error :$e");
      }
      throw "Failed to load data: $e";
    }
  }

  Future<bool> addfilesImage(Map<String, String> body, File file) async {
    String addimageUrl = '$linkServerName/api/imageadd';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      "Accept-Language":CacheHelper.getData(key: "lang"),
    };
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', file.path));
    var response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map> postRequestWithFiles(
      String url, Map<String, dynamic> data, Map<String, File?> images,
      {required Map<String, String> headers}) async {
    String? token = await secureStorage.read(key: "token");

    try {
      var uri = Uri.parse(url);
      var request = http.MultipartRequest('POST', uri);

      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      // Add fields to the request
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add files to the request
      for (var entry in images.entries) {
        if (entry.value == null) {
          continue;
        }
        var stream = http.ByteStream(entry.value!.openRead());
        var length = await entry.value?.length();
        var multipartFile = http.MultipartFile(entry.key, stream, length!,
            filename: entry.value?.path.split('/').last);
        request.files.add(multipartFile);
      }

      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = await http.Response.fromStream(response);
        return jsonDecode(responseData.body);
      } else {
        var responseData = await http.Response.fromStream(response);
        return jsonDecode(responseData.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error :$e");
      }
      throw "Failed to load data: $e";
    }
  }
  // Future<Map> postFilesRequest(String url, Map data) async {
  //   String? token = await secureStorage.read(key: "token");

  //   // initializeToken();
  //   try {
  //     // print("toooookeeeeennnn:  $token");
  //     var response = http.MultipartRequest('POST', Uri.parse(url))
  //       ..fields['text'] = text
  //       ..files.add(await http.MultipartFile.fromPath(
  //         'file',
  //         file.path,
  //         contentType: MediaType('application', 'octet-stream'),
  //       ));
  //     var response = await http.post(Uri.parse(url), body: data, headers: {
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       if (kDebugMode) {
  //         print(jsonDecode(response.body));
  //       }
  //       return jsonDecode(response.body);
  //     } else {
  //       return jsonDecode(response.body);
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Error :$e");
  //     }
  //     throw "Failed to load data: $e";
  //   }
  // }

  Future<Map> loginPostRequest(String url, LoginModel model) async {
    // initializeToken();
    try {
      // print("toooookeeeeennnn:  $token");
      var response = await http.post(Uri.parse(url), body: {
        'email': model.email,
        'password': model.password,
      }, headers: {
        'Accept': 'application/json',
        "Accept-Language":CacheHelper.getData(key: "lang"),
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error :$e");
      }
      throw "Failed to load data: $e";
    }
  }

  Future<Map> registerPostRequest(String url, LoginModel model) async {
    // initializeToken();
    try {
      // print("toooookeeeeennnn:  $token");
      var response = await http.post(Uri.parse(url), body: {
        'email': model.email,
        'password': model.password,
      }, headers: {
        'Accept': 'application/json',
        "Accept-Language":CacheHelper.getData(key: "lang"),
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error :$e");
      }
      throw "Failed to load data: $e";
    }
  }

  Future<Map> putRequest(String url, Map data) async {
    // initializeToken();
    try {
      var response = await http.put(Uri.parse(url), body: data, headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer H8H4dScynYaJDv2x46WsZiPuvPYmRkdlkKalL6x0beb26e07',
        "Accept-Language":CacheHelper.getData(key: "lang"),
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      throw "Failed to load data: $e";
    }
  }
}
