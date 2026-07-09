import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';
import 'package:rct/view/designs%20and%20sketches/details_of_Sketch_Screen.dart';

import '../../view-model/cubits/favourite/favourite_cubit.dart';
import 'package:rct/l10n/app_localizations.dart';

class SketchesFavourite extends StatefulWidget {
  const SketchesFavourite({super.key});

  @override
  State<SketchesFavourite> createState() => _SketchesFavouriteState();
}

class _SketchesFavouriteState extends State<SketchesFavourite> {
  @override
  void initState() {
    super.initState();

    context.read<FavouriteCubit>().getSchema();
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<FavouriteCubit, DataState>(
            // listener: (context, state) {
            //   // Optionally handle error states or notifications
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
                      .sketch!
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    final house = context
                        .read<FavouriteCubit>()
                        .favoritesModel!
                        .data!
                        .sketch![index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsOfScetches(
                                      productId: "${house.id}",
                                    )),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        house.image1 != null
                                            ? "${linkServerName}/${house.image1}"
                                            : 'https://via.placeholder.com/150',
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
                                    onPressed: () {
                                      context
                                          .read<FavouriteCubit>()
                                          .deleteGoodList(
                                              house.goodListId.toString());
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
        }));
  }
}
