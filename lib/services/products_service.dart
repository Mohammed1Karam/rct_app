// import 'package:dio/dio.dart';
// import 'package:rct/constants/linkapi.dart';
// import 'package:rct/shared_pref.dart';
// import 'package:rct/view/RealEstate/modelget.dart';

// class ProductService {
//   final Dio _dio = Dio(BaseOptions(
//     headers: {
//       'Content-Type': 'application/json',
//     },
//     connectTimeout: const Duration(seconds: 60),
//     receiveTimeout: const Duration(seconds: 60),
//   ));

//   Future<List<Modelget>?> getProducts() async {
//     try {
//       final response = await _dio.get(
//         linkHouses,
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer ${await _getAuthToken()}',
//           },
//         ),
//       );
//       print(response.data);
//       if (response.statusCode == 200) {
//         final mlist = List<Modelget>.from(
//             (response.data["data"]["data"]).map((i) => Modelget.fromJson(i)));
//         print(mlist.length);
//         return mlist;
//       }
//       print(response);
//     } catch (e) {}
//   }
// }

// Future<String?> _getAuthToken() async {
//   return AppPreferences.getData(key: 'loginToken');
// }
