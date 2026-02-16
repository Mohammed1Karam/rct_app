import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/sar_image.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/model/renter_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/favourite/favourite_cubit.dart';
import 'package:rct/view/RealEstate/filter.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/view/ownership/Filter_ownership.dart';
import 'package:rct/view/ownership/ownership_details_screen.dart';
import 'package:rct/view/ownership/pdf_preview.dart';
import 'package:rct/view/ownership/renters_cubit.dart';

import '../../view-model/cubits/real_estate/states.dart' hide FilterSuccessState;

class OwnershipScreen extends StatefulWidget {
  OwnershipScreen({
    super.key,
  });

  @override
  State<OwnershipScreen> createState() => _OwnershipScreenState();
}

class _OwnershipScreenState extends State<OwnershipScreen> {
  List<RenterModel> data = [];
  bool allButtonActive = true;
  final FavouriteCubit favouriteCubit = FavouriteCubit();

  @override
  void initState() {
    super.initState();
    context.read<RentersCubit>().fetchUnAuthData("$linkServerName/api/renters");
    setState(() {
      data = context.read<RentersCubit>().allRenterList; // Get all data
    });
  }

  void _handleSearch(String query) {
    context.read<RentersCubit>().SearchHouse(input: query);
    setState(() {
      data = context.read<RentersCubit>().searchList ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    print(data.length);
    return Scaffold(
        appBar: BackButtonAppBar(context),
        backgroundColor: Colors.white,
        body: BlocConsumer<RentersCubit, RentersState>(
          listener: (context, state) {
            if (state is GetRenterError) {
              print(state.message);
            }
          },
          builder: (context, state) {
            return Padding(
              padding:
                  const EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            _handleSearch(value);
                            setState(() {
                              data = context.read<RentersCubit>().searchList ?? [];
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            hintText: local.search,
                            floatingLabelAlignment: FloatingLabelAlignment.start,
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintStyle: const TextStyle(fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FilterOwnershipScreen(),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            "assets/images/mage_filter.png",
                            width: 25,
                            height: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: _buildPropertyGrid(local, data)),
                ],
              ),
            );
          },
        ));
  }

  Widget _buildPropertyGrid(local, List<RenterModel>? data) {
    return GridView.builder(
      itemCount: data?.length ?? 0,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        mainAxisExtent: 260,
      ),
      itemBuilder: (context, index) {
        return _buildPropertyCard(local, data?[index]);
      },
    );
  }

  Widget _buildPropertyCard(local, RenterModel? model) {
    return InkWell(
      onTap: () async {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OwnershipDetailsScreen(
              id: model!.id.toString(),
            ),
          ),
        );
      },
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Stack(
                children: [
                  SizedBox(
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: model != null
                          ? Image.network(
                              "${model.images1}",
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : Center(
                            child: const Icon(
                                Icons.image,

                                size: 120,
                              ),
                          ),
                    ),
                  ),
                  CacheHelper.getData(key: "token") != null
                      ? Positioned(
                          left: 1,
                          child: BlocConsumer<FavouriteCubit, DataState>(
                            listener: (context, state) {
                              if (state is FavouriteSuccess) {
                              } else if (state is FavouriteError) {}
                            },
                            builder: (context, state) {
                              return IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: true ? Colors.red : Colors.black,
                                ),
                                onPressed: () async {},
                              );
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                model?.title?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                " ${model?.city?? " "}- ${model?.district?? ""} ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10),
              ),
              const SizedBox(height: 4),
              Text(
                model?.description?? "",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CacheHelper.getData(key: "lang") == "en"
                      ? SarImage(
                    color: greenColor,
                  )
                      : Container(),
                  Text(
                    "${NumberFormat('#,###').format(double.tryParse(model?.price?? ""))} ",
                    style: TextStyle(
                      fontSize: 12,
                      color: greenColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  CacheHelper.getData(key: "lang") == "ar"
                      ?  SarImage(
                    color: greenColor,
                  )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
