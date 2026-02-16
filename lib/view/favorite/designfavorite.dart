import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';
import 'package:rct/view/designs%20and%20sketches/details_of_designs.dart';

import '../../view-model/cubits/favourite/favourite_cubit.dart';
import 'package:rct/l10n/app_localizations.dart';

class DesignFavorites extends StatefulWidget {
  const DesignFavorites({super.key});

  @override
  State<DesignFavorites> createState() => _DesignFavoritesState();
}

class _DesignFavoritesState extends State<DesignFavorites> {
  @override
  void initState() {
    super.initState();
    // Fetch the good list when the widget initializes
    context.read<FavouriteCubit>().getDesign();
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FavouriteCubit, DataState>(
        // listener: (context, state) {
        //   if (state is FavouriteSuccess) {}
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
                      .design!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    final house = context
                        .read<FavouriteCubit>()
                        .favoritesModel!
                        .data!
                        .design![index]; // Safely access the house item

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // Navigate to the details screen of the selected favorite
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsOfDesignsScreen(
                                      productId: "${house.id}",
                                    )),
                          );
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
                                        ? house.name!.ar ?? ""
                                        : house.name!.en ?? "",
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

                                        // Fetch the updated list of favorites
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
