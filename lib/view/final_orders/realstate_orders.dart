import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view-model/functions/compare_date.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_cubit.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_states.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/l10n/app_localizations.dart';

import '../../generated/l10n.dart';

class RealstateOrders extends StatefulWidget {
  const RealstateOrders({Key? key}) : super(key: key);

  @override
  State<RealstateOrders> createState() => _RealstateOrdersState();
}

class _RealstateOrdersState extends State<RealstateOrders> {
  List<Modelget> data = [];
  bool isLoading = true;
  int? selectedCardIndex;
  int? deletingIndex;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    // _fetchInitialData();
    // context.read<FinalOrdersCubit>().RealOrders();
  }

  Future<void> _fetchInitialData() async {
    await context.read<FinalOrdersCubit>().RealOrders();
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
              builder: (context, state) {
                return state is RealEstateOrdersLoading ||
                        context.read<FinalOrdersCubit>().realList.isEmpty
                    ? Center()
                    : Expanded(
                        child: ListView.builder(
                          itemCount:
                              context.read<FinalOrdersCubit>().realList.length,
                          itemBuilder: (context, index) {
                            final item = context
                                .read<FinalOrdersCubit>()
                                .realList[index];

                            return Card(
                              elevation: 2,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildInfoColumn(local.estateType,
                                            item.house_type ?? ""),
                                        _buildStatusColumn(item.status),
                                        _buildInfoColumn(
                                            local.date,
                                            timeDifferenceFromNow(
                                                item.created_at)),
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
                                              _buildDetailText(
                                                  "${local.price}", item.price),
                                              _buildDetailText("${local.city}",
                                                  item.city_name),
                                              _buildDetailText(
                                                  "${local.district}",
                                                  item.district_name),
                                              _buildDetailText(
                                                  "${local.description}",
                                                  item.description.toString()),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
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
                                                        await FinalOrdersCubit
                                                                .get(context)
                                                            .deleteUserAsset(
                                                                data[index].id,
                                                                data[index]
                                                                    .type,
                                                                context);

                                                        // Remove the item from the list
                                                        setState(() {
                                                          data.removeAt(
                                                              index); // Remove the deleted item
                                                          deletingIndex =
                                                              null; // Reset the deleting index
                                                        });

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(local
                                                                .theorderhasbeensuccessfullydeleted),
                                                          ),
                                                        );
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
                                            ],
                                          )
                                        : Container(),
                                  ],
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

  Widget _buildInfoColumn(String title, String content) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey)),
        SizedBox(height: 8),
        Text(content, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStatusColumn(String status) {
    var local = S.of(context);
    final color = status == "pending"
        ? Colors.amber
        : (status == "accepted" || status == "approved" || status == "approve")
            ? Colors.green
            : Colors.red;

    return Column(
      children: [
        Text(local.status, style: TextStyle(color: Colors.grey)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(12)),
          child:
              Text(status, style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildDetailText(String title, String content) {
    return Text("$title: $content", style: TextStyle(fontSize: 12));
  }
}
