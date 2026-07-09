import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/sar_image.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';

import 'package:rct/model/modelget.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';
import 'package:rct/view-model/cubits/favourite/favourite_cubit.dart';
import 'package:rct/view/share_rct/cubit.dart';
import 'package:rct/view/share_rct/details.dart';
import 'package:rct/view/share_rct/states.dart';

import '../home_screen.dart';

class ShareRct extends StatefulWidget {
  const ShareRct({super.key, required this.url, required this.isLoggedIn});

  final String url;
  final bool isLoggedIn;

  @override
  State<ShareRct> createState() => _ShareRctState();
}

class _ShareRctState extends State<ShareRct> {
  final Set<dynamic> favoriteItems = {};
  List<Modelget> data = [];
  bool check = false;
  bool allButtonActive = true;
  bool sakanyActive = false;
  bool tojaryActive = false;
  bool endOpportunityActive = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // _fetchInitialData();
    context.read<ShareCubit>().fetchShare(widget.url);
    context.read<FavouriteCubit>().getChances();

    ShareCubit.get(context).resetFilters();
    data = context.read<ShareCubit>().allShareList; // Fetch all data
  }

  // Future<void> _fetchInitialData() async {
  //   await context.read<ShareCubit>().fetchShare(widget.url);
  //
  // }

  void _handleCategoryFilter(String category) async {
    await context.read<ShareCubit>().filterByCategory(category);
    setState(() {
      data = context.read<ShareCubit>().filterByCategoryList ?? [];
    });
  }

  // List<dynamic> getchances = [];
  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    final cubit = context.read<ShareCubit>();

    return Scaffold(
      appBar: BackButtonAppBar(context),
      backgroundColor: Colors.white,
      body: BlocConsumer<ShareCubit, ShareState>(
        listener: (context, state) {
          if (state is ShareSuccess) {
            print("------------------------- Share");
          }
          if (state is ShareError) {
            print('----------------------share error');
            print(state.message);
          } else if (cubit.allShareList.isEmpty) {
            print('----------------------no data');
          } else if (state is FilterSuccessState) {
          } else if (state is ShareSuccess || state is FavouriteSuccess) {
            data = cubit.allShareList; // Reset to all data on success
          }
        },
        builder: (context, state) {
          if (state is ShareLoading) {
            return const Center();
          }

          return Padding(
            padding:
                const EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      local.chances,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildCategoryRow(local),
                const SizedBox(height: 20),
                // Property Listings
                Expanded(
                  child: _buildPropertyGrid(local),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryRow(local) {
    return Row(
      spacing: 5,
      children: [
        Expanded(
          child: _buildFilterButton(local.all, allButtonActive, () {
            setState(() {
              check = true;
              allButtonActive = true;
              sakanyActive = false;
              tojaryActive = false;
              endOpportunityActive = false;
              ShareCubit.get(context).resetFilters();
              data = context.read<ShareCubit>().allShareList; // Fetch all data
            });
          }),
        ),
        Expanded(
          child: _buildFilterButton(local.rowland, tojaryActive, () {
            _handleCategoryFilter(local.rowland);

            setState(() {
              check = false;
              // sakanyActive = !sakanyActive;
              allButtonActive = false;
              sakanyActive = false;
              tojaryActive = true;
              endOpportunityActive = false;
            });
          }),
        ),
        Expanded(
          child: _buildFilterButton(local.presentestate, sakanyActive, () {
            _handleCategoryFilter(local.presentestate);

            setState(() {
              check = false;
              // tojaryActive = !tojaryActive;
              allButtonActive = false;
              tojaryActive = false;
              sakanyActive = true;
              endOpportunityActive = false;
            });
          }),
        ),
        Expanded(
          child: _buildFilterButton(
              local.completed_opportunities, endOpportunityActive, () {
            _handleCategoryFilter(local.completed_opportunities);
            setState(() {
              check = false;
              allButtonActive = false;
              sakanyActive = false;
              tojaryActive = false;
              endOpportunityActive = true;
            });
          }),
        ),
      ],
    );
  }

  Widget _buildFilterButton(
      String label, bool isActive, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: isActive ? primaryColor : const Color(0xFFEBEBEB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: "URW-DIN-Arabic",
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : Colors.black,
            fontSize: 10),
      ),
    );
  }

  Widget _buildPropertyGrid(local) {
    if (data.isEmpty) {
      return Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Image.asset(
            "assets/images/shareEmptyData.jpeg",
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return GridView.builder(
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        mainAxisExtent: 300,
      ),
      itemBuilder: (context, index) {
        return _buildPropertyCard(data[index], local);
      },
    );
  }

  Widget _buildPropertyCard(Modelget house, local) {
    final cubit = context.read<ShareCubit>();
    int completedOpportunities = (int.tryParse(house.opportunity_count)! -
        int.tryParse(house.number_opportunity_pay)!);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShareDetails(id: house.id.toString())),
        );
      },
      child: Card(
        elevation: 3,
        color:
            completedOpportunities == 0 ? Colors.grey.shade200 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: house.image1 != null
                          ? SizedBox(
                              height: 150,
                              child: Image.network(
                                "${house.image1!}",
                                width: double.infinity,
                                fit: BoxFit.fill,
                                height: 150,
                              ),
                            )
                          : const Icon(Icons.image)),
                  if (widget.isLoggedIn)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: BlocConsumer<FavouriteCubit, DataState>(
                        listener: (context, state) {
                          if (state is FavouriteSuccess) {
                          } else if (state is FavouriteError) {
                            print(state.message);
                          }
                        },
                        builder: (context, state) {
                          print(
                              "is in favoirte ${house.is_in_goodlist.toString()}");
                          print("id ${house.id}");
                          return IconButton(
                            icon: Icon(
                              Icons.favorite_border_outlined,
                              color: house.is_in_goodlist.toString() == "true"
                                  ? Colors.red
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () async {
                              if (house.is_in_goodlist.toString() == "true") {
                                setState(() {
                                  house.is_in_goodlist = "false";
                                });
                                await context
                                    .read<FavouriteCubit>()
                                    .deleteGoodList(
                                        house.goodlist_id.toString());
                              } else {
                                setState(() {
                                  house.is_in_goodlist = "true";
                                });
                                // data = context.read<ShareCubit>().allShareList;
                                await context
                                    .read<FavouriteCubit>()
                                    .postGoodList(
                                        house.id.toString(), "Opportunity");
                              }

                              await context
                                  .read<ShareCubit>()
                                  .fetchShare(widget.url);

                              if (sakanyActive && !check) {
                                _handleCategoryFilter(local.presentestate);
                              } else if (tojaryActive && !check) {
                                _handleCategoryFilter(local.rowland);
                              } else if (check) {
                                ShareCubit.get(context).resetFilters();
                              }

                              // setState(() {
                              // data = context.read<ShareCubit>().allShareList;
                              // _fetchInitialData();
                              // context.read<ShareCubit>().fetchShare(widget.url);
                              // });
                            },
                          );
                        },
                      ),
                    ),
                  Positioned(
                    bottom: -1,
                    left: 0,
                    child: Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: completedOpportunities == 0
                            ? Colors.grey.shade200
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          // bottomLeft: Radius.circular(15),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /* CacheHelper.getData(key: 'lang') == 'en'
                              ? Image.asset(
                                  "assets/images/return_2.png",
                                  width: 23,
                                  color: greenColor,
                                )
                              : SizedBox(),
                          SizedBox(width: 3),*/
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: greenColor,
                                  ),
                                ),
                                Text(
                                  '${house.percent_number}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: greenColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*SizedBox(width: 3),
                          CacheHelper.getData(key: 'lang') == 'ar'
                              ? Image.asset(
                                  "assets/images/return_2.png",
                                  width: 23,
                                  color: greenColor,
                                )
                              : SizedBox(),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                house.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              house.city_name != ""
                  ? Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${house.city_name}",
                                  style: TextStyle(fontSize: 9),
                                ),
                                TextSpan(
                                  text: " - ",
                                ),
                                TextSpan(
                                  text: "${house.district_name}",
                                  style: TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${house.location}",
                                  style: TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  "${house.description}",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CacheHelper.getData(key: "lang") == "en"
                      ? SarImage(
                          height: 14,
                          color: greenColor,
                        )
                      : Container(),
                  Text(
                    "${NumberFormat('#,###').format(int.tryParse(house.total_price.toString()))} ",
                    style: TextStyle(
                      fontSize: 13,
                      color: greenColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  CacheHelper.getData(key: "lang") == "ar"
                      ? SarImage(
                          height: 14,
                          color: greenColor,
                        )
                      : Container(),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
