import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:http/http.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:pluis_hv_app/pluisWidgets/homeBottomBar.dart';
import 'package:pluis_hv_app/pluisWidgets/homePageCarousel.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import '../injectorContainer.dart' as injectionContainer;

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
  List<Tab> tabs = [];
  List<GenresInfo> genres;
  List<List<SlidesInfo>> slidersInfoByGender;

  @override
  void initState() {
    super.initState();
    Settings.invalidateCredentials();
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

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Center(
        child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.black,
            isScrollable: true,
            tabs: this.tabs),
      ),
    );
  }

  BottomBar buildBottomNavigationBar() {
    return BottomBar(
      onPressBookmark: () => Navigator.of(context).pushNamed(ADDRESS_BOOK_ROUTE),
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
          this.genres = state.genresInfo;
          _tabController = TabController(length: genres.length, vsync: this);

          tabs = List<Tab>.from(genres.map((genre) => Tab(
                child: Text(
                  genre.title,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              )));

          _tabController.addListener(() {
            this.selectedGenre = genres[_tabController.index].gender_id;
            log("Tab index change" + this.selectedGenre);
          });
          await this.context.read<HomePageCubit>().setSuccess();
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
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: buildAppBar(),
              body: Container(
                child: TabBarView(
                    controller: this._tabController,
                    children: createCarouselFromGenres()),
              ),
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

  List<BlocProvider<HomePageCarouselCubit>> createCarouselFromGenres() {
    return List<BlocProvider<HomePageCarouselCubit>>.from(
        this.genres.map((e) => createCarouselProvider(e.gender_id)));
  }

  BlocProvider createCarouselProvider(String genreId) {
    return BlocProvider<HomePageCarouselCubit>(
      create: (_) => injectionContainer.sl<HomePageCarouselCubit>(),
      child: HomePageCarousel(genreId: genreId),
    );
  }
}
