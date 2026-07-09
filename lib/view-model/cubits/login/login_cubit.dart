// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rct/constants/constants.dart';
// import 'package:rct/model/auth/login_model.dart';
// import 'package:rct/constants/linkapi.dart';
// import 'package:rct/main.dart';
// import 'package:rct/shared_pref.dart';
// import 'package:rct/view-model/services/crud.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// part 'login_state.dart';

// class LoginCubit extends Cubit<LoginState> {
//   final Crud _crud = Crud();

//   // Static variable to store the token
//   static String? token;
//   static String? name;
//   static dynamic image;
//   LoginCubit() : super(LoginInitial());

//   Future<void> login(LoginModel loginModel, BuildContext context) async {
//     emit(LoginLoading());
//     try {
//       // First request for login
//       final response = await _crud.loginPostRequest(linkLogin, loginModel);
//       if (response.containsKey("token")) {
//         token = response["token"];
//         name = response["name"];
//         image = response["image"];
//         loginToken = token;

//         await secureStorage.write(key: "token", value: token);
//         await secureStorage.write(key: "image", value: image);
//         await secureStorage.write(key: "name", value: name);
//         await secureStorage.write(key: "email", value: response["email"]);

//         AppPreferences.saveData(
//             key: 'loginToken', value: loginToken.toString());

//         Future<String?> getLoginToken() async {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           return prefs.getString('loginToken');
//         }

//         final token2 = await getLoginToken();
//         loginToken = await getLoginToken();

//         // Ensure the FCM token is valid
//         if (loginModel.fcm_token.isNotEmpty) {
//           // Include the email and password in the second request if needed
//           final fcmResponse = await _crud.postRequest(linkLogin, {
//             "email": loginModel.email,
//             "password": loginModel.password,
//             "fcm_token": loginModel.fcm_token,
//           });

//           // Handle the response for the FCM token post request
//           if (kDebugMode) {
//             print("FCM Token posted successfully");

//             emit(LoginSuccess());
//           } else {
//             print("FCM Token post failed: $fcmResponse");
//             emit(LoginFailed(errMessage: "Failed to post FCM token."));
//           }
//         } else {
//           print("FCM Token is empty.");
//           emit(LoginFailed(errMessage: "FCM Token is empty."));
//         }

//         if (kDebugMode) {
//           print("Token: $token");
//         }
//       } else {
//         emit(LoginFailed(errMessage: response.toString()));
//         print("Login failed: $response");
//       }
//     } catch (e) {
//       emit(LoginFailed(errMessage: "$e"));
//     }
//   }
// }
