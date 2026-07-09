import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/orders%20list/orders_list_cubit.dart';
import 'package:rct/view-model/functions/compare_date.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_cubit.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_states.dart';
import 'package:rct/model/modelget.dart';

import '../../generated/l10n.dart';

class RowOrdersScreen extends StatefulWidget {
  const RowOrdersScreen({super.key});

  @override
  State<RowOrdersScreen> createState() => _RowOrdersScreenState();
}

class _RowOrdersScreenState extends State<RowOrdersScreen> {
  List<Modelget> data = [];
  bool isLoadingData = true;
  bool isButtonLoading = false;
  int? deletingIndex;
  bool isDeleting = false;

  // Track expanded state for individual cards
  Set<int> expandedCards = {};

  @override
  void initState() {
    super.initState();
    // _fetchInitialData();
    // FinalOrdersCubit.get(context).RawLand();
    // context.read<FinalOrdersCubit>().RawLand();
  }

  Future<void> _fetchInitialData() async {
    await context.read<FinalOrdersCubit>().RawLand();
  }

  void toggleDetailsVisibility(int index) {
    setState(() {
      if (expandedCards.contains(index)) {
        expandedCards.remove(index);
      } else {
        expandedCards.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<FinalOrdersCubit, FinalOrdersStates>(
              builder: (BuildContext context, Object? state) {
                return state is RawLandOrdersLoading
                    ? Center()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: FinalOrdersCubit.get(context)
                              .cooperationList
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            data =
                                FinalOrdersCubit.get(context).cooperationList;
                            return Card(
                              elevation: 2,
                              color: Colors.white,
                              child: IntrinsicHeight(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(local.estateType,
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Text(
                                                      data[index].type ==
                                                              "raw_lands"
                                                          ? local.rowland
                                                          : data[index].type ==
                                                                  "old_buildings"
                                                              ? local
                                                                  .oldBuildings
                                                              : local.plans,
                                                      style: const TextStyle(
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                local.status,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0),
                                                decoration: BoxDecoration(
                                                  color: data[index].status ==
                                                          "pending"
                                                      ? Colors.amber
                                                      : data[index].status ==
                                                                  "accepted" ||
                                                              data[index]
                                                                      .status ==
                                                                  "approved" ||
                                                              data[index]
                                                                      .status ==
                                                                  "approve"
                                                          ? Colors.green
                                                          : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  data[index].status,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(local.date,
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              const SizedBox(height: 8),
                                              Text(
                                                timeDifferenceFromNow(
                                                    data[index].created_at),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              expandedCards.contains(index)
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              color: primaryColor,
                                            ),
                                            onPressed: () =>
                                                toggleDetailsVisibility(index),
                                          ),
                                        ],
                                      ),
                                      expandedCards.contains(index)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(data[index]
                                                            .identity_number !=
                                                        null
                                                    ? " ${local.nationalID} : ${data[index].identity_number}"
                                                    : ""),
                                                Text(data[index]
                                                            .identity_number !=
                                                        null
                                                    ? "${local.birthDate} : ${data[index].birthdate}"
                                                    : ""),
                                                Text(
                                                    "${local.price} : ${data[index].price}"),
                                                Text(
                                                    "${local.city} : ${data[index].city_name}"),
                                                Text(
                                                    "${local.district} : ${data[index].district_name}"),
                                                Text(
                                                    " ${local.propertyLocation} : ${data[index].location}"),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 20,
                                                    horizontal: 10,
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 100,
                                                    child: data[index]
                                                                .electronic_instrument !=
                                                            null
                                                        ? Image.network(
                                                            "$linkServerName/${data[index].electronic_instrument}",
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Container(),
                                                  ),
                                                ),
                                                MainButton(
                                                  onTap: () async {
                                                    // Show a confirmation dialog first
                                                    bool? shouldDelete =
                                                        await showDialog<bool>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Center(
                                                            child: Text(
                                                              local
                                                                  .areyousureyouwanttocanceltheorder,
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          content: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              MainButton(
                                                                backGroundColor:
                                                                    Colors
                                                                        .green,
                                                                width: 70,
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true); // Confirm deletion
                                                                },
                                                                text: local.yes,
                                                              ),
                                                              const SizedBox(
                                                                  width: 20),
                                                              MainButton(
                                                                width: 70,
                                                                backGroundColor:
                                                                    Colors.red,
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false); // Cancel deletion
                                                                },
                                                                text: local.no,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );

                                                    if (shouldDelete == true) {
                                                      setState(() {
                                                        deletingIndex = index;
                                                      });

                                                      try {
                                                        await FinalOrdersCubit
                                                                .get(context)
                                                            .deleteUserAsset(
                                                                data[index].id,
                                                                data[index]
                                                                    .type,
                                                                context)
                                                            .then((v) async {
                                                          await context
                                                              .read<
                                                                  FinalOrdersCubit>()
                                                              .RawLand(
                                                                  fromInit:
                                                                      false);

                                                          setState(() {
                                                            deletingIndex =
                                                                null; // Track the index of the item being deleted
                                                          });
                                                        });

                                                        // Remove the item from the list
                                                        // setState(() {
                                                        //   data.removeAt(index); // Remove the deleted item
                                                        //   deletingIndex = null; // Reset the deleting index
                                                        // });

                                                        // ScaffoldMessenger.of(context).showSnackBar(
                                                        //   const SnackBar(
                                                        //     content: Text("تم حذف الطلب بنجاح"),
                                                        //   ),
                                                        // );
                                                      } catch (error) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                "فشل في حذف الطلب. يرجى المحاولة لاحقًا."),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        );
                                                        setState(() {
                                                          deletingIndex =
                                                              null; // Reset even if deletion fails
                                                        });
                                                      }
                                                    }
                                                  },
                                                  text: deletingIndex == index
                                                      ? CacheHelper.getData(
                                                                  key:
                                                                      "lang") ==
                                                              "ar"
                                                          ? "جار الحذف..."
                                                          : "Deleteing..."
                                                      : CacheHelper.getData(
                                                                  key:
                                                                      "lang") ==
                                                              "ar"
                                                          ? "الغاء الطلب"
                                                          : "Cancel Order",
                                                  backGroundColor:
                                                      deletingIndex == index
                                                          ? Colors.grey
                                                          : primaryColor,
                                                  textColor: Colors.white,
                                                  width: double.infinity,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
