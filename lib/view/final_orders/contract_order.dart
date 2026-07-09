import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/contract_model.dart';
import 'package:rct/view/ownership/renters_cubit.dart';
import '../../generated/l10n.dart';
import '../../services/cache_helper.dart';
import '../../shared_pref.dart';
import '../ownership/pdf_preview.dart';

class ContractOrders extends StatefulWidget {
  const ContractOrders({Key? key}) : super(key: key);

  @override
  State<ContractOrders> createState() => _ContractOrdersState();
}

class _ContractOrdersState extends State<ContractOrders> {
  List<ContractModel> data = [];
  bool isLoading = true;
  bool openPdf = false;

  @override
  void initState() {
    super.initState();
    if(RentersCubit.get(context).allContractList.isEmpty){
      RentersCubit.get(context).getContract();
    }
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
    var cubit = RentersCubit.get(context);
    return ModalProgressHUD(
      inAsyncCall: openPdf,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlocConsumer<RentersCubit, RentersState>(
                listener: (context, state) {
                  if (state is GetContractSuccess) {
                    setState(() {
                      data = cubit.allContractList;
                      isLoading = false;
                      print(data.length);
                    });
                  }
                },
                builder: (context, state) {
                  return state is GetContractLoading ||
                          cubit.allContractList.isEmpty && isLoading
                      ? Center()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: cubit.allContractList.length,
                            itemBuilder: (context, index) {
                              final item = cubit.allContractList[index];
                              return Card(
                                elevation: 2,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildInfoColumn(local.renter_value ,
                                              item.totalAmount ?? ""),
                                          Spacer(),
                                          _buildInfoColumn(
                                              local.first_batch_date ,
                                              DateFormat(
                                                'yyyy/M/d',
                                              ).format(item.renter.updatedAt)),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            visualDensity: VisualDensity.compact,
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
                                      SizedBox(
                                        height: 10,
                                      ),
                                      expandedCards.contains(index)
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    spacing: 5,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      _buildDetailText(
                                                          S.of(context).location,
                                                          CacheHelper.getData(
                                                                      key:
                                                                          "lang") ==
                                                                  "ar"
                                                              ? item.renter.city
                                                                      .ar ??
                                                                  ""
                                                              : item.renter.city
                                                                      .en ??
                                                                  ""),
                                                      _buildDetailText(
                                                          local.payment_duration,
                                                          item.numberOfInstallments
                                                                  .toString() ??
                                                              ""),
                                                      _buildDetailText(local.payment_plan,
                                                          item.monthlyAmount ??
                                                              ""),
                                                      _buildDetailText(
                                                          S.of(context).next_payment_date,
                                                          DateFormat(
                                                            'yyyy/M/d',
                                                          ).format(item.endDate)),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    spacing: 5,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      _buildDetailText(
                                                          local.first_batch,
                                                          item.renter
                                                                  .firstPayment ??
                                                              ""),
                                                      _buildDetailText(
                                                          local.num_of_units,
                                                          item.renter.units
                                                                  .toString() ??
                                                              ""),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.end,
                                                        children: [

                                                          GestureDetector(
                                                              onTap: () async {
                                                                final token = await AppPreferences.getData(key: 'loginToken');
                                                                setState(() {
                                                                  openPdf = true;
                                                                });
                                                                var headers = {
                                                                  'Content-Type':
                                                                      'application/json',
                                                                  'Accept':
                                                                      'application/json',
                                                                  'Authorization':
                                                                      'Bearer $token',
                                                                };
                                                                var dio = Dio();
                                                                var response =
                                                                    await dio
                                                                        .request(
                                                                  'https://rctapp.com/api/payments/pdf/renter/${item.renter.id}',
                                                                  options:
                                                                      Options(
                                                                    method: 'GET',
                                                                    headers:
                                                                        headers,
                                                                  ),
                                                                );
      
                                                                if (response
                                                                        .statusCode ==
                                                                    200) {
                                                                  print(json.encode(
                                                                      response
                                                                          .data));
                                                                  setState(() {
                                                                    openPdf =
                                                                        false;
                                                                  });
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              PdfViewerScreen(
                                                                        pdfBase64:
                                                                            json.encode(response.data["data"]
                                                                                [
                                                                                "pdf_base64"]),
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  print(response
                                                                      .statusMessage);
                                                                }
                                                              },
                                                              child: Image.asset(
                                                                "assets/images/pdf.png",
                                                                width: 20,
                                                                color:
                                                                    Colors.grey,
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                item.status == "active"
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 6.0),
                                                        width: 80,
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: Center(
                                                            child: Text(S.of(context).active,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12))),
                                                      )
                                                    : Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 6.0),
                                                        width: 80,
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: Center(
                                                            child: Text(S.of(context).in_active,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12))),
                                                      ),
                                              ],
                                            ),
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
      ),
    );
  }

  Widget _buildInfoColumn(String title, String content) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
        SizedBox(height: 8),
        Text(content, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildDetailText(String title, String content) {
    return Text.rich(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      TextSpan(
        text: '$title: ',
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.normal, color: Colors.grey),
        children: [
          TextSpan(
            text: content,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
