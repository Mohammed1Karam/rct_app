import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';

import 'package:rct/view/share_rct/cubit.dart';
import 'package:rct/view/share_rct/details.dart';
import '../../view-model/cubits/favourite/favourite_cubit.dart';
import 'package:rct/l10n/app_localizations.dart';

class ChancesFavorite extends StatefulWidget {
  const ChancesFavorite({super.key});

  @override
  State<ChancesFavorite> createState() => _ChancesFavoriteState();
}

class _ChancesFavoriteState extends State<ChancesFavorite> {
  @override
  void initState() {
    super.initState();
    context.read<ShareCubit>().fetchShare(shareRCT);
    context.read<FavouriteCubit>().getChances();
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
                      .opportunity!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    final house = context
                        .read<FavouriteCubit>()
                        .favoritesModel!
                        .data!
                        .opportunity![index]; // Safely access the house item

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShareDetails(id: house.id.toString())),
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
          // Default case
        },
      ),
    );
  }
}
