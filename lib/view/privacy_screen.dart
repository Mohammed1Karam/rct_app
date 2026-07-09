import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/generated/l10n.dart';
import 'dart:convert'; // For JSON encoding and decoding
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/view/share_rct/cubit.dart';
import 'package:rct/view/share_rct/states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';

class PrivacysScreen extends StatefulWidget {
  static const String id = "PrivacysScreen";
  const PrivacysScreen({super.key});

  @override
  State<PrivacysScreen> createState() => _PrivacysScreenState();
}

class _PrivacysScreenState extends State<PrivacysScreen> {
  final Crud crud = Crud();
  late Future<List<String?>> privacyFuture;

  @override
  void initState() {
    super.initState();
    // privacyFuture = fetchPrivacys();
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocBuilder<ShareCubit,ShareState>(
        builder: (context,state){
          if(context.read<ShareCubit>().privacyList.isNotEmpty){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  local.privacyPolicy,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: constVerticalPadding),
                Expanded(
                  child: ListView.builder(
                    itemCount: context.read<ShareCubit>().privacyList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            context.read<ShareCubit>().privacyList[index],
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
