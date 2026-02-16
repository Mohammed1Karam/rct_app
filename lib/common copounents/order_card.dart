import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';

import 'package:rct/shared_pref.dart';
import 'package:rct/view-model/cubits/orders%20list/orders_list_cubit.dart';
import 'package:rct/view-model/functions/compare_date.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_cubit.dart';

class OrderCard extends StatefulWidget {
  final Map order;
  final int index;

  // final Function onDelete; //
  const OrderCard({
    Key? key,
    required this.order,
    required this.index,
    // required this.onDelete,
  }) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool showDetails = false;
  bool isDeleting = false;
  int? deletingIndex;

  void toggleDetailsVisibility() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  Future<void> _pickAndUploadFile(
      BuildContext context, String orderNumber) async {
    var local = S.of(context);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(local.fileselectedSuccess)));
      } else {}
    } catch (e) {
      // Handle any errors that occur during file picking
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(local.errorPleaseTryAgain)));
    }
  }

  Widget _buildOrderInfo(BuildContext context, String label, String value,
      {bool status = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        if (status)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: _getStatusColor(value),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            ),
          )
        else
          Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildOrderInfo(context, local.orderNumber,
                          widget.order['number'] ?? ''),
                    ],
                  ),
                  _buildOrderInfo(context, local.status,
                      widget.order['status'] ?? 'Pending',
                      status: true),
                  _buildOrderInfo(context, local.date,
                      timeDifferenceFromNow(widget.order['created_at'] ?? '')),
                  IconButton(
                    icon: Icon(
                      showDetails ? Icons.expand_less : Icons.expand_more,
                      color: primaryColor,
                    ),
                    onPressed: toggleDetailsVisibility,
                  ),
                ],
              ),
              if (showDetails)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          " ${local.orderNumber} : ${widget.order['number'] ?? ''}"),
                      Text(
                          " ${local.estateType} : ${widget.order['main_type'] ?? ''}"),
                      Text(
                          " ${local.totalLandArea} : ${widget.order['area'] ?? ''}"),
                      Text(
                          " ${local.swimmingPool} : ${widget.order['has_pool'] == 0 ? "${local.no}" : "${local.yes}"}"),
                      Text(
                          " ${local.soilTesting} : ${widget.order['landcheckimage'] == null ? "${local.no}" : "${local.yes}"}"),
                      _buildImageRow(),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: MainButton(
                          textColor: Colors.white,
                          backGroundColor: primaryColor,
                          text: isDeleting
                              ? local.delete
                              : local
                                  .canceltheorder, // Button text changes during deletion
                          onTap: () async {
                            // Show a confirmation dialog first
                            bool? shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                      local.areyousureyouwanttocanceltheorder,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MainButton(
                                        backGroundColor: Colors.green,
                                        width: 70,
                                        onTap: () {
                                          Navigator.of(context)
                                              .pop(true); // Confirm deletion
                                        },
                                        text: local.yes,
                                      ),
                                      SizedBox(width: 20),
                                      MainButton(
                                        width: 70,
                                        backGroundColor: Colors.red,
                                        onTap: () {
                                          Navigator.of(context)
                                              .pop(false); // Cancel deletion
                                        },
                                        text: local.no,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                            // If the user confirmed the deletion
                            if (shouldDelete == true) {
                              setState(() {
                                isDeleting = true; // Set loading state to true
                              });

                              try {
                                // Perform the delete operation
                                await FinalOrdersCubit.get(context)
                                    .deleteUserAsset(
                                        widget.order["id"]
                                            .toString(), // Use the order ID passed to the widget
                                        "order", // The asset type
                                        context)
                                    .then((v) async {
                                  await context
                                      .read<OrdersListCubit>()
                                      .fetchOrderList(fromInit: false);
                                });

                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(
                                //     content: Text("تم حذف الطلب بنجاح"),
                                //   ),
                                // );

                                // Call the onDelete callback to remove the item from the list (optional)
                                // widget.onDelete();
                                // context.read<OrdersListCubit>().fetchOrderList();
                              } catch (error) {
                                // print("----------------------");
                                // print(error.toString());
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text(local.failedtodeletetheorderPleasetryagainlater),
                                //     backgroundColor: Colors.red,
                                //   ),
                                // );
                              } finally {
                                setState(() {
                                  isDeleting = false; // Reset loading state
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _pickAndUploadFile(
                        context, widget.order['number'].toString()),
                    child: Column(
                      children: [
                        Icon(Icons.upload, color: primaryColor),
                        Text(local.uploadPayMentRecipt,
                            style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (widget.order['electronicimage'] != null)
          _buildImage("${linkServerName}/${widget.order['electronicimage']}"),
        if (widget.order['nationalidimage'] != null)
          _buildImage("${linkServerName}/${widget.order['nationalidimage']}"),
        if (widget.order['landcheckimage'] != null)
          _buildImage("${linkServerName}/${widget.order['landcheckimage']}"),
      ],
    );
  }

  Widget _buildImage(String url) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 20,
      ),
      height: 50,
      width: 80,
      child: Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
        return Icon(Icons.error);
      }),
    );
  }
}

Widget _buildOrderInfo(BuildContext context, String label, String value,
    {bool status = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style:
            Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
      ),
      const SizedBox(height: 4.0),
      status
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: _getStatusColor(value),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
            )
          : Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
    ],
  );
}

Color _getStatusColor(String status) {
  switch (status) {
    case "accepted":
    case "approved":
    case "approve":
      return Colors.green;
    case 'canceled':
      return Colors.red;
    case 'pending':
    default:
      return Colors.amber;
  }
}

void _showErrorDialog(BuildContext context, String message) {
  var local = S.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: Text('خطأ'),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            message,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Center(
            child: MainButton(
              onTap: () {
                Navigator.of(context).pop();
              },
              text: local.accept,
              backGroundColor: primaryColor,
              width: 200,
            ),
          ),
        ],
      );
    },
  );
}

Future<String?> _getAuthToken() async {
  return AppPreferences.getData(key: 'loginToken');
}
