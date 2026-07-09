import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/view-model/cubits/orders%20list/orders_list_cubit.dart';
import 'package:rct/view-model/functions/compare_date.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_cubit.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_states.dart';
import 'package:rct/l10n/app_localizations.dart';

class DesignsOrders extends StatefulWidget {
  const DesignsOrders({super.key});

  @override
  State<DesignsOrders> createState() => _DesignsOrdersState();
}

class _DesignsOrdersState extends State<DesignsOrders> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    // FinalOrdersCubit.get(context).DesignsAndScketches();
    // context.read<FinalOrdersCubit>().DesignsAndScketches();
    // });
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await context.read<FinalOrdersCubit>().DesignsAndScketches();
  }

  Set<int> expandedCards = {};

  void toggleDetailsVisibility(int index) {
    setState(() {
      if (expandedCards.contains(index)) {
        expandedCards.remove(index);
      } else {
        expandedCards.add(index);
      }
    });
  }

  int? deletingIndex;
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BlocConsumer<FinalOrdersCubit, FinalOrdersStates>(
            listener: (context, state) {
              if (state is DesignsFaild) {
                print(state.message);
              } else if (state is DesignsSuccess) {}
            },
            builder: (context, state) {
              if (state is DesignsLoading) {
                return Center(child: Container());
              } else if (state is DesignsSuccess) {
                final data = state.data;
                if (data.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(local.orderNumber,
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                  "${data[index].orderNumber != "null" ? data[index].orderNumber : ""}",
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(local.status,
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: data[index].status ==
                                                      "pending"
                                                  ? Colors.amber
                                                  : data[index].status ==
                                                              "accepted" ||
                                                          data[index].status ==
                                                              "approved" ||
                                                          data[index].status ==
                                                              "approve"
                                                      ? Colors.green
                                                      : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              "${data[index].status ?? "pending"}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(local.date,
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          SizedBox(height: 8),
                                          Text(
                                            timeDifferenceFromNow(
                                                "${data[index].created_at}"),
                                            style:
                                                const TextStyle(fontSize: 12),
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
                                              if (data[index].name != null)
                                                Text(
                                                  "${local.name}: ${data[index].name}",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              Text(
                                                "${local.description}: ${data[index].description ?? ""}",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    data[index].image != null
                                                        ? Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20,
                                                                    horizontal:
                                                                        10),
                                                            height: 50,
                                                            width: 100,
                                                            child: Image.network(
                                                                "${linkServerName}/${data[index].image}",
                                                                fit: BoxFit
                                                                    .fill))
                                                        : Container(),
                                                    data[index].image1 != null
                                                        ? Container(
                                                            height: 50,
                                                            width: 100,
                                                            child: Image.network(
                                                                "${linkServerName}/${data[index].image1}",
                                                                fit: BoxFit
                                                                    .fill))
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: MainButton(
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
                                                                  print(
                                                                      "id ${data[index].id}");
                                                                  print(
                                                                      "type ${data[index].type}");
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
                                                        deletingIndex =
                                                            index; // Track the index of the item being deleted
                                                      });

                                                      try {
                                                        // Perform the delete operation
                                                        print(data[index].type);
                                                        await FinalOrdersCubit
                                                                .get(context)
                                                            .deleteUserAsset(
                                                                data[index].id,
                                                                data[index]
                                                                        .type ??
                                                                    "preferable",
                                                                context)
                                                            .then((v) async {
                                                          // ScaffoldMessenger.of(context).showSnackBar(
                                                          //   SnackBar(
                                                          //     content: Text(local.theorderhasbeensuccessfullydeleted),
                                                          //   ),
                                                          // );
                                                          await context
                                                              .read<
                                                                  FinalOrdersCubit>()
                                                              .DesignsAndScketches(
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
                                                      } catch (error) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(local
                                                                .failedtodeletetheorderPleasetryagainlater),
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
                                                      ? local.delete
                                                      : local.cancelRequest,
                                                  backGroundColor:
                                                      deletingIndex == index
                                                          ? Colors.grey
                                                          : primaryColor,
                                                  textColor: Colors.white,
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ])
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text(""));
                }
              } else {
                return const Center(child: Text(""));
              }
            },
          ),
        ],
      ),
    );
  }
}
