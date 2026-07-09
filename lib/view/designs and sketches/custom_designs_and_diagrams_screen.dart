import 'dart:io';
import 'package:rct/services/cache_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_dropdownlist.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/view-model/cubits/preferable/preferable_cubit.dart';
import 'package:rct/view-model/functions/image_picker.dart';
import 'package:rct/view/home_screen.dart';

import '../../generated/l10n.dart';

class CustomDesignAndDiagramsScreen extends StatefulWidget {
  const CustomDesignAndDiagramsScreen({super.key});

  @override
  State<CustomDesignAndDiagramsScreen> createState() => _CustomDesignAndDiagramsScreenState();
}

class _CustomDesignAndDiagramsScreenState extends State<CustomDesignAndDiagramsScreen> {
  TextEditingController controller = TextEditingController();
  String? _selectedOrderNumber;
  File? file;
  bool isLoading = false;

  // Function to display the image in full screen
  void _viewImageLarge(File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(imageFile),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    var local = S.of(context);

    return BlocConsumer<PreferableCubit, PreferableState>(
      listener: (context, state) {
        if (state is PreferableLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is PreferableFailure) {
          setState(() {
            isLoading = false;
          });
          // showSnackBar(context, state.errMessage, redColor);
        } else {
          setState(() {
            isLoading = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowPopUp(
                  title: Center(
                    child: Image.asset(
                      "assets/icons/popUp-icon.png",
                      height: 50.h,
                      width: 50.w,
                    ),
                  ),
                  content: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      local.requestSentSuccessfully,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      local.requestWillBeReviewed,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ontap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen())),
                );
              });
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: BackButtonAppBar(context),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.pleaseChooseDesignOrPlan,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: constVerticalPadding),
                    InkWell(
                      onTap: () async {
                        File? pickedFile = await pickImageFromGallery(context);
                        if (pickedFile != null) {
                          setState(() {
                            file = pickedFile;
                          });
                        }
                      },
                      child: file == null
                          ? CacheHelper.getData(key: "lang") == "ar"
                              ? Image.asset("$imagePath/upload-photo.png")
                              : CacheHelper.getData(key: "lang") == "en"
                                  ? Image.asset("assets/images/upload.jpg")
                                  : Image.asset("$imagePath/upload-photo.png")
                          : GestureDetector(
                              onTap: () => _viewImageLarge(file!),
                              child: Image.file(
                                file!,
                                height: 50.h,
                                width: 50.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    SizedBox(height: constVerticalPadding),
                    Text(
                      local.otherDetailsOrInformation,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: constVerticalPadding),
                    TextFormFieldCustom(
                      context: context,
                      border: false,
                      length: 100,
                      labelText: local.pleaseWriteOtherDetails,
                      onChanged: (value) {},
                      controller: controller,
                    ),
                    SizedBox(height: constVerticalPadding),
                    Text(
                      local.enterRequestNumber,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: constVerticalPadding),
                    CustomDropDownList(
                      list: orderModel.orderNumbers,
                      selectedValue: _selectedOrderNumber,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOrderNumber = newValue;
                        });
                      },
                      hint: local.pleaseChooseRequestNumber,
                    ),
                    SizedBox(height: constVerticalPadding),
                    Center(
                      child: MainButton(
                          text: local.submitRequest,
                          backGroundColor: primaryColor,
                          onTap: () async {
                            if (file == null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(S.of(context).should_choose_design),
                                backgroundColor: Colors.red,
                              ));
                            }  else {
                              String dis = controller.text.isEmpty ? "no description" : controller.text;
                              await context.read<PreferableCubit>().pushPreferable(dis, file!, _selectedOrderNumber);
                            }
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
