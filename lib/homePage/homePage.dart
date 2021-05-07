import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
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
    context.read<HomePageCubit>().loadGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomBar buildBottomNavigationBar() {
    return BottomBar(
      onPressSearch: () =>
          Navigator.pushNamed(context, GALERY_SCREEN_PAGE_ROUTE),
      onPressShopBag: () => Navigator.of(context).pushNamed(SHOP_CART),
      onPressAccount: () => Navigator.of(context).pushNamed(LOGIN_PAGE_ROUTE),
      onPressMenu: () => Navigator.of(context).pushNamed(MENU_PAGE),
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocConsumer<HomePageCubit, HomePageState>(
      listener: (context, state) async {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomePageLoading:
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
            );
          case HomePageImagesLoaded:
            return DefaultTabController(
              length: 4,
              child: Column(
                children: [
                AppBar(
                automaticallyImplyLeading: false,
                title: Center(
                  child: TabBar(
                      isScrollable: true,
                      tabs: List<Tab>.from((state as HomePageImagesLoaded)
                          .genresInfo
                          .map((e) => Tab(
                        child: Text(
                          e.id,
                          style: TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      )))),
                ),
              ),
                  TabBarView(children: [
                    HomePageCarousel(),
                    HomePageCarousel(),
                    HomePageCarousel(),
                    HomePageCarousel(),
                  ])
                ],
              ),
            );
          default:
            return TabBarView(children: [
              HomePageCarousel(),
              HomePageCarousel(),
              HomePageCarousel(),
              HomePageCarousel(),
            ]);
        }
      },
    );
  }

  // Widget buildTabBar() =>
  //     AppBar(
  //       automaticallyImplyLeading: false,
  //       title: Center(
  //         child: TabBar(
  //           isScrollable: true,
  //           tabs: [
  //             Tab(
  //               child: Text(
  //                 "HOMBRES",
  //                 style: TextStyle(fontSize: 18, color: Colors.black),
  //               ),
  //             ),
  //             Tab(
  //                 child: Text("MUJERES",
  //                     style: TextStyle(fontSize: 18, color: Colors.black))),
  //             Tab(
  //                 child: Text("NIÑOS",
  //                     style: TextStyle(fontSize: 18, color: Colors.black))),
  //           ],
  //         ),
  //       ),
  //     );

  Widget buildTabBar() {
    return BlocConsumer<HomePageCubit, HomePageState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomePageImagesLoaded:
            return AppBar(
              automaticallyImplyLeading: false,
              title: Center(
                child: TabBar(
                    isScrollable: true,
                    tabs: List<Tab>.from((state as HomePageImagesLoaded)
                        .genresInfo
                        .map((e) => Tab(
                              child: Text(
                                e.id,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            )))),
              ),
            );
          default:
            return LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                minHeight: 2);
        }
      },
    );
  }
}
