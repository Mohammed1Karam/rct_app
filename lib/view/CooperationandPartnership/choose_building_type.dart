import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_dropdownlist.dart';

import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';

import 'package:rct/view-model/cubits/types/types_cubit.dart';
import 'package:rct/view/CooperationandPartnership/OldBuilding.dart';

import 'package:rct/view/CooperationandPartnership/Plans.dart';
import 'package:rct/view/CooperationandPartnership/RawLand.dart';
import 'package:rct/view/auth/sendotp.dart';
import 'package:rct/view/home_screen.dart';

class ChooseBuildingType extends StatefulWidget {
  const ChooseBuildingType({Key? key}) : super(key: key);

  @override
  State<ChooseBuildingType> createState() => _ChooseBuildingTypeState();
}

class _ChooseBuildingTypeState extends State<ChooseBuildingType> {
  String? _selectedType;

  Map<String, Map<String, dynamic>> nameToDetails = {};

  @override
  void initState() {
    super.initState();
    context.read<TypesCubit>().get();
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    List<String> itemNames = [
      local.rowland,
      local.oldBuildings,
      local.sketches,
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BackButtonAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: constVerticalPadding + 10),
              Text(
                local.estateType,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: constVerticalPadding + 10),
              CustomDropDownList(
                list: itemNames,
                selectedValue: _selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
                hint: local.chooseType,
              ),
              SizedBox(height: 50),
              Center(
                child: MainButton(
                  text: local.next,
                  backGroundColor: primaryColor,
                  onTap: () async {
                    String loginMessage = local.pleaselogin; // Custom message
                    bool isLoggedIn =
                        await checkLoginStatus(); // Check if the user is logged in

                    if (isLoggedIn) {
                      // If logged in, navigate to the ChooseBuildingType screen

                      if (_selectedType == local.rowland) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Raw_Screen()));
                      } else if (_selectedType == local.oldBuildings) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Oldbuilding_Screen()));
                      } else if (_selectedType == local.sketches) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PlansScreen()));
                      }
                    } else {
                      // Show dialog if the user is not logged in
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                textAlign: TextAlign.center,
                                local.alert,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                textAlign: TextAlign.center,
                                loginMessage,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ), // Display the login message
                              actions: [
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text(
                                        local.cancel,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        // Navigate to the login screen
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SendOtp()), // Replace with your actual login screen
                                        );
                                      },
                                      child: Text(
                                        local.login,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
