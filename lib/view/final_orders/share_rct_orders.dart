import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view-model/functions/compare_date.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_cubit.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_states.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/view/final_orders/opportunity_model.dart';

import '../../generated/l10n.dart';
import '../../services/cache_helper.dart';
import '../../shared_pref.dart';
import '../ownership/pdf_preview.dart';

class ShareRctOrders extends StatefulWidget {
  const ShareRctOrders({Key? key}) : super(key: key);

  @override
  State<ShareRctOrders> createState() => _ShareRctOrdersState();
}

class _ShareRctOrdersState extends State<ShareRctOrders> {
  List<OpportunityModel> data = [];
  List<Modelget> status = [];
  bool isLoading = true;
  int? selectedCardIndex;
  int? deletingIndex;
  bool isDeleting = false;

  bool openPdf = false;

  @override
  void initState() {
    super.initState();
     //_fetchInitialData();
    if(FinalOrdersCubit.get(context).opportunity.isEmpty){
      FinalOrdersCubit.get(context).ShareRct();
    }
    //context.read<FinalOrdersCubit>().ShareRct();
  }

  Future<void> _fetchInitialData() async {
    await context.read<FinalOrdersCubit>().ShareRct();
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
    return ModalProgressHUD(
      inAsyncCall: openPdf,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlocConsumer<FinalOrdersCubit, FinalOrdersStates>(
                listener: (context, state) {
                  if (state is ShareOrdersFaild) {
                    print(state.message);
                     setState(() {
                       isLoading = false;
                    });
                     } else if (state is ShareOrdersSuccess) {
                     setState(() {
                       data = FinalOrdersCubit.get(context).opportunity;
                     isLoading = false;
                    });
                  }
                 },
                builder: (context, state) {
                  return state is ShareOrdersLoading ||
                          context.read<FinalOrdersCubit>().opportunity.isEmpty && isLoading
                      ? Center()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: context
                                .read<FinalOrdersCubit>()
                                .opportunity
                                .length,
                            itemBuilder: (context, index) {
                              final item = context
                                  .read<FinalOrdersCubit>()
                                  .opportunity[index];
                              return Card(
                                elevation: 2,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: _buildInfoColumn(S.of(context).project_name,  CacheHelper.getData(key: "lang") == "ar"? item.opportunity.name?? "": item.opportunity.name ?? "")),
                                          Expanded(child: _buildInfoColumn(S.of(context).subscripe_number, item.opportunity.id.toString() ?? "")),
                                          Expanded(
                                            child: _buildInfoColumn(
                                                S.of(context).subscripe_date,
                                                item.opportunity.createdAt == null? "" :DateFormat(
                                                  'yyyy/M/d',
                                                ).format(item.opportunity.createdAt! as DateTime)),
                                          ),
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
                                      SizedBox(height: 10,),
                                      expandedCards.contains(index)
                                          ? Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  spacing: 5,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      _buildDetailText(local.location,
                                                          CacheHelper.getData(key: "lang") == "ar"?item.opportunity.location ?? "": item.opportunity.location ?? ""),
                                                      _buildDetailText(S.of(context).opportunity_price,
                                                          item.opportunity.opportunityPrice ?? ""),
                                                      _buildDetailText(S.of(context).return_type,
                                                          item.opportunity.typeOfReturn.toString() ??""),
                                                      _buildDetailText(S.of(context).return_date,
                                                          item.myInvestmentSummary.nextReturn == null? "" :
                                                          item.myInvestmentSummary.nextReturn?.dueDate ?? ""),
                                                    ],
                                                  ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  spacing: 5,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    _buildDetailText(S.of(context).subscription_type,
                                                        item.opportunity.type ?? ""),
                                                    _buildDetailText(S.of(context).opportunities_number,
                                                        item.opportunity.numberOpportunityPay.toString() ?? ""),
                                                    _buildDetailText(S.of(context).project_duration,
                                                        item.opportunity.projectDuration ?? ""),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                              'https://rctapp.com/api/payments/pdf/opportunity/${item.opportunity.id}',
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
                                                            child: Image.asset("assets/images/pdf.png", width: 20,color: Colors.grey,)),
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
                                          item.opportunity.status == "start_return"
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12 ,color: Colors.grey)),
        SizedBox(height: 8),
        Text(content, style: TextStyle(fontSize: 12)),
      ],
    );
  }


  Widget _buildDetailText(String title, String content) {
    return Text.rich(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      TextSpan(
        text: '$title: ',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal,color: Colors.grey),
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
