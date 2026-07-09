import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/card_container.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/cubits/designs/designs_cubit.dart';
import 'package:rct/view-model/cubits/designs/designs_state.dart';
import 'package:rct/view-model/cubits/real_estate/states.dart';
import 'package:rct/view/designs%20and%20sketches/details_of_designs.dart';
import 'package:rct/view/designs%20and%20sketches/designs_form_screen.dart';
import 'package:rct/view-model/cubits/favourite/favourite_cubit.dart';

class DesignsScreen extends StatefulWidget {
  const DesignsScreen({super.key});

  @override
  State<DesignsScreen> createState() => _DesignsScreenState();
}

class _DesignsScreenState extends State<DesignsScreen> {
  final FavouriteCubit favouriteCubit = FavouriteCubit();

  @override
  void initState() {
    super.initState();
    context.read<DesignsCubit>().loadDesigns(context);
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
              child: BlocBuilder<DesignsCubit, DesignsState>(
                builder: (context, state) {
                  if (state is DesignsLoading) {
                    return const Center();
                  } else if (state is DesignsFailure) {
                    debugPrint("Error in designs screen: $state");
                    return const Center(
                      child: Text("Failed to load designs."),
                    );
                  } else if (state is DesignsSuccess) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount:
                          context.read<DesignsCubit>().designsModel.length,
                      itemBuilder: (context, index) {
                        final design =
                            context.read<DesignsCubit>().designsModel[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsOfDesignsScreen(
                                  productId: design.id.toString(),
                                ),
                              ),
                            );
                          },
                          child: CardContainer(
                            image: "$linkServerName/${design.image}",
                            title: "${design.name}",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DesignsForm(
                                    id: design.id,
                                    price: design.price,
                                  ),
                                ),
                              );
                            },
                            favoriteIcon:
                                BlocConsumer<FavouriteCubit, DataState>(
                              listener: (context, state) {
                                if (state is FavouriteError) {}
                              },
                              builder: (context, state) {
                                return IconButton(
                                  icon: Icon(
                                    //  design["is_in_goodlist"] != false ? Icons.favorite :
                                    Icons.favorite_border,
                                    color: design.isInGoodlist != false
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  onPressed: () async {
                                    try {
                                      if (design.isInGoodlist == true) {
                                        setState(() {
                                          design.isInGoodlist = false;
                                        });
                                        await context
                                            .read<FavouriteCubit>()
                                            .deleteGoodList(
                                                design.goodlistId?.toString() ??
                                                    "");
                                      } else {
                                        setState(() {
                                          design.isInGoodlist = true;
                                        });
                                        await context
                                            .read<FavouriteCubit>()
                                            .postGoodList(design.id.toString(),
                                                "designs");
                                      }

                                      await context
                                          .read<DesignsCubit>()
                                          .loadDesigns(context);

                                      // Update the local state and refresh designs

                                      // await context.read<FavouriteCubit>().getGoodList();
                                      // await context.read<FavouriteCubit>().getDesign();

                                      print(design);
                                    } catch (e) {
                                      debugPrint('Error updating favorite: $e');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('An error occurred.')),
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
                  } else {
                    return const Center(child: Text(''));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDesignsGrid(List<dynamic> designs) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: designs.length,
      itemBuilder: (context, index) {
        final design = designs[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsOfDesignsScreen(
                  productId: design["id"].toString(),
                ),
              ),
            );
          },
          child: CardContainer(
            image: "$linkServerName/${design["image"]}",
            title: "${design["name"]}",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DesignsForm(
                    id: design["id"],
                    price: design["price"],
                  ),
                ),
              );
            },
            favoriteIcon: BlocConsumer<FavouriteCubit, DataState>(
              listener: (context, state) {
                if (state is FavouriteError) {}
              },
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    //  design["is_in_goodlist"] != false ? Icons.favorite :
                    Icons.favorite_border,
                    color: design["is_in_goodlist"] != false
                        ? Colors.red
                        : Colors.black,
                  ),
                  onPressed: () async {
                    try {
                      print(
                          "++++++++++++++++++++++++++++++++++++++++++++++++++++");
                      print("is_in_goodlist ${design["is_in_goodlist"]} ");
                      print(design["goodlist_id"]);
                      print(design["id"]);
                      print(
                          "++++++++++++++++++++++++++++++++++++++++++++++++++++");

                      if (design["is_in_goodlist"] == true) {
                        print("reeeeeeeeemove");
                        await context.read<FavouriteCubit>().deleteGoodList(
                            design["goodlist_id"]?.toString() ?? "");
                      } else {
                        print("addddddddd");

                        await context
                            .read<FavouriteCubit>()
                            .postGoodList(design["id"].toString(), "designs");
                      }

                      // Update the local state and refresh designs
                      setState(() {
                        design["is_in_goodlist"] =
                            design["is_in_goodlist"] == false ? true : false;
                      });
                      // await context.read<FavouriteCubit>().getGoodList();
                      await context.read<DesignsCubit>().loadDesigns(context);
                      // await context.read<FavouriteCubit>().getDesign();

                      print(design);
                    } catch (e) {
                      debugPrint('Error updating favorite: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('An error occurred.')),
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
}
