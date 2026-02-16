import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final Dio _dio = Dio();
  XFile? _image; // Updated type for selected image
  bool _isLoading = false; // Loading indicator
  int? id;

  @override
  void initState() {
    super.initState();
    Users();
  }

  Future<void> Users() async {
    final token = await _getAuthToken();
    print('Auth Token: $token'); // Check token

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get(
        "$linkServerName/api/user",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            "Accept-Language": CacheHelper.getData(key: "lang"),
          },
          followRedirects: false, // Disable automatic redirects
          validateStatus: (status) {
            return status! < 500; // Accept status codes < 500
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map) {
        var responseData = response.data;

        print(responseData["phone"]);
        print("id + ${responseData["id"]}");
        // Handle valid response data
        _nameController.text = responseData["name"] ?? '';
        _emailController.text = responseData["email"] ?? '';
        _phoneController.text = responseData["phone"].toString().substring(3);
        id = responseData["id"] ?? '';
        // _image = "$linkServerName/${responseData["image"]}" as XFile?;
      } else if (response.statusCode == 302) {
        print('Redirect to: ${response.headers['location']}');
        // Handle the redirect manually, if needed
      } else {
        print('Unexpected response: ${response.data}');
      }
    } on DioException catch (e) {
      print(
          'Dio error! STATUS: ${e.response?.statusCode}, DATA: ${e.response?.data}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getAuthToken() async {
    return AppPreferences.getData(key: 'loginToken');
  }

  Future<void> pickAndUploadPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      File image = File(photo.path);
      await _updateProfile({
        "image": await MultipartFile.fromFile(image.path),
      });
    } else {
      print("No photo selected");
    }
  }

  Future<void> _updateProfile(Map<String, dynamic> data) async {
    final local = S.of(context);
    final token = await _getAuthToken();
    if (token == null) {
      showSnackBar(context, local.errorPleaseTryAgain, Colors.red);
      return;
    }

    try {
      final response = await _dio.post(
        '$linkServerName/api/users/update',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: FormData.fromMap(data),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        showSnackBar(context, local.errorPleaseTryAgain, Colors.red);
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.statusCode}, ${e.response?.data}');
      showSnackBar(context, local.errorPleaseTryAgain, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = S.of(context);

    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: whiteBackGround),
          ),
          title: Text(
            local.profile,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            // Stack with a fixed height
            SizedBox(
              height: 250, // Adjust height
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 250,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Image.asset(
                                "assets/images/h512-removebg-preview.png",
                                height: 150,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Expanded for content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  padding: EdgeInsets.zero, // Remove default ListView padding
                  children: [
                    SizedBox(height: 20), // Reduce space
                    ..._buildProfileFields(local),
                    SizedBox(height: 10), // Adjust spacing
                    _buildImageSelectionButton(local),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: MainButton(
                        text: _isLoading ? local.saving : local.save,
                        backGroundColor: primaryColor,
                        onTap: _isLoading
                            ? null
                            : () async {
                                final data = {
                                  'name': _nameController.text,
                                  'email': _emailController.text,
                                  'phone': "966" + _phoneController.text,
                                };
                                await _updateProfile(data);
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  List<Widget> _buildProfileFields(local) {
    return [
      _buildTextField(local.name, _nameController),
      SizedBox(height: 10.h),
      _buildTextField(local.email, _emailController),
      SizedBox(height: 10.h),
      _buildTextField(local.phone, _phoneController, numberofdigits: 9),
    ];
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int? numberofdigits}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        SizedBox(height: 10.h),
        TextFormFieldCustom(
          numberofdigits: numberofdigits,
          context: context,
          labelText: controller.text.isNotEmpty ? controller.text : label,
          controller: controller,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildImageSelectionButton(local) {
    return InkWell(
      onTap: pickAndUploadPhoto,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            local.chooseImage,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
