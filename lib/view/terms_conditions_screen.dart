import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';
import 'package:rct/view/share_rct/cubit.dart';
import 'package:rct/view/share_rct/states.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      appBar: BackButtonAppBar(context),
      backgroundColor: Colors.white,
      body: BlocBuilder<ShareCubit,ShareState>(
        builder: (context,state){
          if(ShareCubit.get(context).termsConditions.isNotEmpty){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  local.termsConditions,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: ShareCubit.get(context).termsConditions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            ShareCubit.get(context).termsConditions[index],
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }else{
            return SizedBox();
          }
        },
      ),
    );
  }
}
