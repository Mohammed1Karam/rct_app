import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/card_container.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/cubits/sketches/sketches_cubit.dart';
import 'package:rct/view-model/cubits/sketches/sketches_state.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';
import 'package:rct/view/designs%20and%20sketches/details_of_Sketch_Screen.dart';
import 'package:rct/view/designs%20and%20sketches/sketches_form_screen.dart';

import 'package:rct/view-model/cubits/favourite/favourite_cubit.dart';

class SketchesScreen extends StatefulWidget {
  const SketchesScreen({super.key});

  @override
  State<SketchesScreen> createState() => _SketchesScreenState();
}

class _SketchesScreenState extends State<SketchesScreen> {
  final Set<dynamic> favoriteItems = {}; // Tracks favorite items by their IDs.
  final FavouriteCubit favouriteCubit = FavouriteCubit();

  @override
  void initState() {
    super.initState();
    _initializeFavorites();
    context.read<SketchesCubit>().loadSketches(context);
  }

  void _initializeFavorites() async {
    try {
      // Fetch the sketch-related favorite items
      await favouriteCubit.getSchema();

      // Assuming favouriteCubit.state holds a List or data with a field that contains the items
      if (favouriteCubit.state is FavouriteSuccess) {
        final favouriteItemsList =
            (favouriteCubit.state as FavouriteSuccess).data;
        setState(() {
          favoriteItems.addAll(favouriteItemsList.map((item) => item['id']));
        });
      }
    } catch (e) {
      debugPrint("Error initializing favorites: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<SketchesCubit, SketchesState>(
                builder: (context, state) {
                  if (state is SketchesLoading) {
                    return const Center();
                  } else if (state is SketchesFailure) {
                    debugPrint("Error in sketches screen: $state");
                    return SizedBox();
                    // return Center(
                    //   child: Image.asset(
                    //     "$imagePath/modul-lettering-404-with-gears-and-exclamation-mark-text.png",
                    //   ),
                    // );
                  } else if (state is SketchesSuccess) {
                    return _buildSketchesGrid(state.sketches);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSketchesGrid(List<dynamic> sketches) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: sketches.length,
      itemBuilder: (context, index) {
        final sketch = sketches[index];
        return InkWell(
          onTap: () {
            _navigateToDetails(context, sketch["id"]);
          },
          child: CardContainer(
            image: "$linkServerName/${sketch["image"]}",
            title: sketch["name"],
            onTap: () {
              print(sketch["id"]);
              print(sketch["price"]);
              _navigateToForm(context, sketch["id"], sketch["price"] ?? "0");
            },
            favoriteIcon: BlocBuilder<FavouriteCubit, DataState>(
              // listener: (context, state) {
              //   if (state is FavouriteError) {}
              // },
              bloc: FavouriteCubit(),
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: sketch["is_in_goodlist"] != false
                        ? Colors.red
                        : Colors.black,
                  ),
                  onPressed: () async {
                    try {
                      if (sketch["is_in_goodlist"] == true) {
                        setState(() {
                          sketch["is_in_goodlist"] = false;
                        });
                        await context.read<FavouriteCubit>().deleteGoodList(
                            sketch["goodlist_id"]?.toString() ?? "");
                      } else {
                        setState(() {
                          sketch["is_in_goodlist"] = true;
                        });
                        await context
                            .read<FavouriteCubit>()
                            .postGoodList(sketch["id"].toString(), "sketchs");
                      }
                      // Update the local state and refresh sketchs

                      await context.read<SketchesCubit>().loadSketches(context);
                      await context.read<FavouriteCubit>().getSchema();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('')),
                      );
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _navigateToDetails(BuildContext context, dynamic productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailsOfScetches(productId: productId.toString()),
      ),
    );
  }

  void _navigateToForm(BuildContext context, dynamic id, String price) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SketchForm(
          id: id,
          price: price,
        ),
      ),
    );
  }
}
