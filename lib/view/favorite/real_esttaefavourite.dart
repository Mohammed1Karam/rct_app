import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/real_estate/real_estate_cubit.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';
import 'package:rct/view/RealEstate/details_screen.dart';

import '../../view-model/cubits/favourite/favourite_cubit.dart';
import 'package:rct/l10n/app_localizations.dart';

class RealFavorites extends StatefulWidget {
  const RealFavorites({super.key});

  @override
  State<RealFavorites> createState() => _RealFavoritesState();
}

class _RealFavoritesState extends State<RealFavorites> {
  @override
  void initState() {
    super.initState();
    context.read<DataCubit>().fetchUnAuthData(linkHouses);
    context.read<FavouriteCubit>().getGoodList();
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FavouriteCubit, DataState>(
        // listener: (context, state) {
        //   if (state is FavouriteSuccess) {
        //     // Optionally show a success message or snackbar here
        //   }
        //   if (state is FavouriteError) {}
        // },
        builder: (context, state) {
          return state is FavouriteLoading &&
                  context.read<FavouriteCubit>().favoritesModel == null
              ? SizedBox()
              : ListView.builder(
                  itemCount: context
                      .read<FavouriteCubit>()
                      .favoritesModel!
                      .data!
                      .house!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    final house = context
                        .read<FavouriteCubit>()
                        .favoritesModel!
                        .data!
                        .house![index]; // Safely access the house item

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                      id: house.id.toString(),
                                      isdeeplink: false,
                                    )),
                          );
                          // Navigate to the details screen of the selected favorite
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => FavoritesDetails(
                          //       description:
                          //           CacheHelper.getData(key: "lang") == "ar"
                          //               ? house.description!.ar ?? ""
                          //               : house.description!.en ?? "",

                          //       image: house.image1 != null
                          //           ? "${linkServerName}/${house.image1}"
                          //           : 'https://via.placeholder.com/150', // Placeholder image
                          //       name: CacheHelper.getData(key: "lang") == "ar"
                          //           ? house.cityName!.ar ?? ""
                          //           : house.cityName!.en ?? "",
                          //     ),
                          //   ),
                          // );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          child: Row(
                            children: [
                              // Image of the house
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        house.image1 != null
                                            ? "${linkServerName}/${house.image1}"
                                            : 'https://via.placeholder.com/150', // Placeholder image
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: 120,
                                  width: MediaQuery.of(context).size.width * .3,
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    CacheHelper.getData(key: "lang") == "ar"
                                        ? house.cityName!.ar ?? ""
                                        : house.cityName!.en ?? "",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all(Colors.red),
                                    ),
                                    onPressed: () async {
                                      final goodListId =
                                          house.goodListId.toString();

                                      try {
                                        // Remove the house from favorites by calling the delete method in the cubit
                                        await context
                                            .read<FavouriteCubit>()
                                            .deleteGoodList(goodListId);

                                        context
                                            .read<FavouriteCubit>()
                                            .getGoodList();
                                      } catch (e) {
                                        // Handle potential errors (e.g., network issues)
                                        print('Error deleting favorite: $e');
                                      }
                                    },
                                    child: Text(
                                      local.delete,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
