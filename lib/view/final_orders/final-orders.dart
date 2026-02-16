import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_cubit.dart';
import 'package:rct/view/favorite/emptyScreen.dart';
import 'package:rct/view/final_orders/contract_order.dart';
import 'package:rct/view/final_orders/designOrders.dart';

import 'package:rct/view/final_orders/raw_orders.dart';
import 'package:rct/view/final_orders/orders_screen.dart';

import 'package:rct/view/final_orders/share_rct_orders.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:rct/view/ownership/renters_cubit.dart';

import '../../generated/l10n.dart';

class FinalOrdersScreen extends StatefulWidget {
  int initialIndex = 0;
  FinalOrdersScreen({super.key, required this.initialIndex});

  @override
  State<FinalOrdersScreen> createState() => _FinalOrdersScreenState();
}

class _FinalOrdersScreenState extends State<FinalOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Use the initialIndex from the widget
    _tabController = TabController(
        length: 6, initialIndex: widget.initialIndex, vsync: this);
   // context.read<FinalOrdersCubit>().DesignsAndScketches();
    RentersCubit.get(context).getContract();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    final List<String> tabs = [
      local.joinRCT,
      local.realestate,
      local.designs,
      local.plans,
      local.products,
      local.stores,
    ];
    return DefaultTabController(
      length: 6, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          centerTitle: true,
          title: Image.asset(
            "assets/images/photo_2024-09-16_00-14-11.jpg",
            fit: BoxFit.contain,
            width: 100,
            height: 100,
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.black,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: S.of(context).my_renter),
                  Tab(text: local.joinRCT),
                  //Tab(text: local.cooperationAndPartnership),
                  // Tab(text: local.realestate),
                  Tab(text: local.calculatorProjects),
                  Tab(text: local.plansDesigns),
                  Tab(text: local.services),
                  Tab(text: local.products),
                ],
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: "URW-DIN-Arabic",
                  fontWeight: FontWeight.w900,
                ),
                // If the screen is small, set isScrollable to true to make the tabs scrollable
                isScrollable: true,

                dragStartBehavior: DragStartBehavior.start,
                tabAlignment: TabAlignment.start,
                unselectedLabelColor: Colors.grey,
                labelColor: primaryColor,
                indicatorColor: primaryColor,
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: "URW-DIN-Arabic",
                  fontWeight: FontWeight.w700,
                ),
                // Remove TabAlignment.start to allow the tabs to take equal space
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ContractOrders(),
            ShareRctOrders(),
            //RowOrdersScreen(),
            // RealstateOrders(),
            OrderListScreen(),
            DesignsOrders(),
            EmprtScreen(),
            EmprtScreen(),
          ],
        ),
      ),
    );
  }
}
