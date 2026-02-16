import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rct/model/order_model.dart';

class CostCalc {
  Future<void> calc(BuildContext context) async {
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    double cost = orderModel.cost;
    double constNum = 50000;
    double hafrWradm = orderModel.areaspace * 1.5 * 57;
    orderModel.cost = cost + constNum + hafrWradm;
  }
}
