import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';
import 'package:pluis_hv_app/commons/localResourcesPool.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/galleryPage/galleryPage.dart';
import 'package:pluis_hv_app/pluisWidgets/homeBottomBar.dart';
import 'package:pluis_hv_app/pluisWidgets/homePageCarousel.dart';

import 'homePageCubit.dart';
import 'homePageStates.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: buildTabBar(),
        body: buildBody(context),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  BottomBar buildBottomNavigationBar() {
    return BottomBar(
      onPressSearch: () =>
          Navigator.pushNamed(context, GALERY_SCREEN_PAGE_ROUTE),
      onPressShopBag: () => Navigator.of(context).pushNamed(SHOP_CART),
      onPressAccount: () => Navigator.of(context).pushNamed(LOGIN_PAGE_ROUTE) ,
      onPressMenu: ()=> Navigator.of(context).pushNamed(MENU_PAGE),
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocConsumer<HomePageCubit, HomePageState>(
      listener: (context, state) async {},
      builder: (context, state) {
        return TabBarView(children: [
          Expanded(
            child: HomePageCarousel(),
          ),
          Expanded(
            child: HomePageCarousel(),
          ),
          Expanded(
            child: HomePageCarousel(),
          ),
        ]);
      },
    );
  }

  Column buildColumn() {
    return Column(
        children: [
          Expanded(
            child: HomePageCarousel(),
          ),
        ],
      );
  }

  Widget buildTabBar() => AppBar(
    automaticallyImplyLeading: false,

    title: Center(
      child: TabBar(
        isScrollable: true,
        tabs: [
          Tab(
            child: Text(
              "HOMBRES",
              style: TextStyle(fontSize:18,color: Colors.black),
            ),
          ),
          Tab(child: Text("MUJERES", style: TextStyle(fontSize:18,color: Colors.black))),
          Tab(child: Text("NIÑOS", style: TextStyle(fontSize:18,color: Colors.black))),
        ],
      ),
    ),
  );
}
