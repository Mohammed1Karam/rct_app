import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/order_card.dart';
import 'package:rct/view-model/cubits/orders%20list/orders_list_cubit.dart';

class OrderListScreen extends StatefulWidget {
  static String id = "OrderListScreen";

  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    // context.read<OrdersListCubit>().fetchOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<OrdersListCubit, OrdersListState>(
        builder: (context, state) {
          if (state is OrdersListLoading) {
            return Center(child: Container());
          } else if (state is OrdersListFailure) {
            return Center(child: Text(""));
          }
          if (state is OrdersListSuccess) {
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return OrderCard(
                  // onDelete: () {
                  //   setState(() {
                  //     context.read<OrdersListCubit>().fetchOrderList();
                  //   });
                  // },
                  order: order,
                  index: index,
                );
              },
            );
          }
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  " ",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
