import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/sar_image.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/favourite/favourite_cubit.dart';
import 'package:rct/view/RealEstate/details_screen.dart';
import 'package:rct/view/RealEstate/filter.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/view-model/cubits/real_estate/real_estate_cubit.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';
import 'package:rct/l10n/app_localizations.dart';

class FinalOffers extends StatefulWidget {
  FinalOffers({super.key, required this.url});

  String url;

  @override
  State<FinalOffers> createState() => _FinalOffersState();
}

class _FinalOffersState extends State<FinalOffers> {
  List<Modelget> data = [];
  bool allButtonActive = true;
  bool sakanyActive = false;
  bool tojaryActive = false;
  final FavouriteCubit favouriteCubit = FavouriteCubit();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    if (widget.url == linkHouses) {
      _fetchInitialData();
      // setState(() {
      //   data = context.read<DataCubit>().allDataList; // Get all data
      // });
    } else {
      context.read<DataCubit>().fetchUnAuthData("$linkServerName/api/houses");
    }
    // });
  }

  Future<void> _fetchInitialData() async {
    context.read<DataCubit>().fetchData(widget.url); // Fetch data

    setState(() {
      data = context.read<DataCubit>().allDataList; // Get all data
    });
  }

  void _handleCategoryFilter(String category) async {
    await context.read<DataCubit>().filterByCategory(category);
    setState(() {
      data = context.read<DataCubit>().filterbycategoryList ?? [];
    });
  }

  void _handleSearch(String query) {
    context.read<DataCubit>().SearchHouse(input: query);
    setState(() {
      data = context.read<DataCubit>().searchList ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    final cubit = context.read<DataCubit>();

    return Scaffold(
      appBar: BackButtonAppBar(context),
      backgroundColor: Colors.white,
      body: BlocConsumer<DataCubit, DataState>(
        listener: (context, state) {
          if (state is DataError) {
            print(state.message);
          } else if (cubit.allDataList.isEmpty) {
          } else if (state is FilterSuccessState) {
            if (cubit.filterList != null && cubit.filterList!.isNotEmpty) {
              data = cubit.filterList!;
            } else {
              data = []; // Reset to empty if no filtered results
            }
          } else if (state is DataSuccess || state is FavouriteSuccess) {
            data = cubit.allDataList; // Reset to all data on success
          } else if (state is FilterCategorySuccessState) {
            data = context.read<DataCubit>().filterbycategoryList ?? [];
          } else if (state is SearchSuccess) {
            data = context.read<DataCubit>().searchList ?? [];
          }
        },
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 10),
            child: Column(
              children: [
                // Search & Filter Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: _handleSearch,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          labelText: "",
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          fillColor: Colors.grey[200],
                          filled: true,
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
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
                    // IconButton(
                    //   icon: const Icon(Icons.line_style_sharp, size: 27),
                    //   onPressed: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const FilterScreen()),
                    //   ),
                    // ),

                    const SizedBox(width: 5),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FilterScreen()
                              )
                        );
                      },
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
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      local.type,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFilterButton(local.all, allButtonActive, () {
          setState(() {
            allButtonActive = true;
            sakanyActive = false;
            tojaryActive = false;
            DataCubit.get(context).resetFilters();
            data = context.read<DataCubit>().allDataList; // Show all data
          });
        }),
        _buildFilterButton(local.residential, sakanyActive, () {
          _handleCategoryFilter(local.residential);
          setState(() {
            allButtonActive = false;
            tojaryActive = false;
            sakanyActive = true;
          });
        }),
        _buildFilterButton(local.commercial, tojaryActive, () {
          _handleCategoryFilter(local.commercial);
          setState(() {
            allButtonActive = false;
            tojaryActive = true;
            sakanyActive = false;
          });
        }),
      ],
    );
  }

  Widget _buildFilterButton(
      String label, bool isActive, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isActive ? primaryColor : const Color.fromRGBO(238, 238, 238, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: isActive ? Colors.white : Colors.black, fontSize: 12),
      ),
    );
  }

  Widget _buildPropertyGrid(local) {
    if (data.isEmpty) {
      return Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Image.asset(
            "assets/images/emptyDataImage.jpeg",
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return GridView.builder(
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        mainAxisExtent: 260,
      ),
      itemBuilder: (context, index) {
        final house = data[index];
        return _buildPropertyCard(house, local);
      },
    );
  }

  Widget _buildPropertyCard(Modelget house, local) {
    // final cubit = context.read<DataCubit>();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              id: house.id,
              isdeeplink: true,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: house.image1 != null
                        ? Image.network(
                            "${linkServerName}/${house.image1!}",
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, size: 120),
                  ),
                  widget.url == linkHouses
                      ? Positioned(
                          right: 2,
                          child: BlocConsumer<FavouriteCubit, DataState>(
                            listener: (context, state) {
                              if (state is FavouriteSuccess) {
                              } else if (state is FavouriteError) {}
                            },
                            builder: (context, state) {
                              return IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: house.is_in_goodlist != "false"
                                      ? Colors.red
                                      : Colors.black,
                                ),
                                onPressed: () async {
                                  if (house.is_in_goodlist == "true") {
                                    setState(() {
                                      house.is_in_goodlist = "false";
                                    });
                                    await context
                                        .read<FavouriteCubit>()
                                        .deleteGoodList(
                                            house.goodlist_id.toString() ?? "");
                                  } else {
                                    // data = context.read<DataCubit>().allDataList;
                                    setState(() {
                                      house.is_in_goodlist = "true";
                                    });
                                    await context
                                        .read<FavouriteCubit>()
                                        .postGoodList(house.id, "houses");
                                  }

                                  await context
                                      .read<DataCubit>()
                                      .fetchData(widget.url);

                                  if (sakanyActive) {
                                    _handleCategoryFilter(local.residential);
                                  } else if (tojaryActive) {
                                    _handleCategoryFilter(local.commercial);
                                  } else if (allButtonActive) {
                                    DataCubit.get(context).resetFilters();
                                  }
                                  // setState(() {
                                  //   data =
                                  //       context.read<DataCubit>().allDataList;
                                  //   _fetchInitialData();
                                  //   context
                                  //       .read<DataCubit>()
                                  //       .fetchData(widget.url);
                                  // });
                                },
                              );
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                house.house_type ?? "",
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                "${house.city_name} - ${house.district_name}",
                maxLines: 1,
                style: const TextStyle(fontSize: 10),
              ),
              const SizedBox(height: 4),
              Text(
                "${house.description}",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10),
              ),
              Spacer(),
              Row(
                children: [
                  CacheHelper.getData(key: "lang") == "en"
                      ? const SarImage()
                      : Container(),
                  Text(
                    "${NumberFormat('#,###').format(double.tryParse(house.price ?? ''))} ",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 5, 97, 50),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  CacheHelper.getData(key: "lang") == "ar"
                      ? const SarImage()
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
