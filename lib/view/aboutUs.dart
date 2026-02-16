import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/generated/l10n.dart';
import 'dart:convert';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/view/share_rct/cubit.dart';
import 'package:rct/view/share_rct/states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {


  @override
  void initState() {
    super.initState();
    // fetchAboutUs();
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ShareCubit>().fetchAboutUs();
        }, // Pull-to-refresh functionality
        child: BlocBuilder<ShareCubit, ShareState>(
          builder: (context, state) {
            if(state is GetAboutUsLoadingState|| state is GetAboutUsErrorState){
              return SizedBox();
            }else {
              return context.read<ShareCubit>().aboutUsList.isEmpty
                  ? const Center(child: Text(""))
                  : Column(
                children: [
                  SizedBox(height: 15),
                  Text(
                    local.aboutUs,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: context.read<ShareCubit>().aboutUsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              context.read<ShareCubit>().aboutUsList[index],
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

          },
        ),
      ),
    );
  }
}
