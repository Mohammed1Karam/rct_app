import 'package:flutter/material.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/view/favorite/chances_favourite.dart';
import 'package:rct/view/favorite/emptyScreen.dart';

import 'package:rct/view/favorite/real_esttaefavourite.dart';
import 'package:rct/view/favorite/sketches_favourite.dart';
import 'package:rct/view/favorite/designfavorite.dart';
import 'package:rct/l10n/app_localizations.dart';

class MainFavourites extends StatelessWidget {
  const MainFavourites({super.key});

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    final List<String> tabs = [
      local.joinRCT,
      local.realestateorders,
      local.designs,
      local.plans,
      local.products,
      local.stores,
    ];

    final List<Widget> sections = [
      ChancesFavorite(),
      RealFavorites(),
      DesignFavorites(),
      SketchesFavourite(),
      EmprtScreen(),
      EmprtScreen(),
    ];
    final bool isSmallScreen = MediaQuery.of(context).size.width < 640;
    return DefaultTabController(
      length: tabs.length,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
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
              icon: const Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.black,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(55.0),
              child: TabBar(
                isScrollable: isSmallScreen ? true : false,
                indicatorColor: primaryColor,
                tabAlignment:
                    isSmallScreen ? TabAlignment.start : TabAlignment.fill,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: 'URW-DIN-Arabic',
                  fontWeight: FontWeight.w900,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: 'URW-DIN-Arabic',
                  fontWeight: FontWeight.w700,
                ),
                tabs: tabs
                    .map((tab) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(tab),
                        ))
                    .toList(),
              ),
            ),
          ),
          body: TabBarView(
            children: sections,
          ),
        ),
      ),
    );
  }
}
