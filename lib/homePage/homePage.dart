import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
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

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String selectedGenre = "0";
  List<Tab> tabs;
  List<GenresInfo> genres;
  List<List<SlidesInfo>> slidersInfoByGender;

  @override
  void initState() {
    super.initState();
    context.read<HomePageCubit>().loadGenres();
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
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
      listener: (context, state) async {
        if (state is HomePageGenresLoaded) {
          log("!!!Genres Loaded");
          this.genres = (state as HomePageGenresLoaded).genresInfo;
          _tabController = TabController(length: genres.length, vsync: this);

          tabs = List<Tab>.from(genres.map((genre) => Tab(
                child: Text(
                  genre.title,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              )));

          _tabController.addListener(() {
            this.selectedGenre = genres[_tabController.index].gender_id;
            //
          });
          context.read<HomePageCubit>().loadSlidersInfo(this.genres);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomePageLoading:
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
            );
          case HomePageSuccessState:
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 18,
                ),
                Center(
                  child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.black,
                      isScrollable: true,
                      tabs: this.tabs),
                ),
                Expanded(
                  child: TabBarView(
                    controller: this._tabController,
                      children: createCarouselFromSlidersInfo(
                          (state as HomePageSuccessState).imagesUrl)),
                )
              ],
            );
          default:
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
            );
        }
      },
    );
  }

  List<HomePageCarousel> createCarouselFromSlidersInfo(
      List<List<SlidesInfo>> info) {
    return List<HomePageCarousel>.from(info.map((e) => HomePageCarousel(
          imagesUrls: e,
        )));
  }
}
