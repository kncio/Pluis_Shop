import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:pluis_hv_app/menuPage/menuCubit.dart';
import 'package:pluis_hv_app/pluisWidgets/expandableRow.dart';
import '../injectorContainer.dart' as injectionContainer;

import 'categoryExpandable.dart';
import 'menuState.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPage createState() {
    // TODO: implement createState
    return _MenuPage();
  }
}

class _MenuPage extends State<MenuPage> with SingleTickerProviderStateMixin {
  String selectedGenre;
  List<Tab> _tabs;
  TabController _tabController;
  List<GenresInfo> genres;

  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().loadGenres();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuCubit, MenuState>(listener: (context, state) async {
      if (state is MenuStateLoaded) {
        this.genres = state.genresTabs;
        this._tabController = TabController(length: genres.length, vsync: this);
        this._tabs = List<Tab>.from(genres.map((genre) => Tab(
              child: Text(
                genre.title,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )));
        await context.read<MenuCubit>().setSuccess();
      }
    }, builder: (context, state) {
      switch (state.runtimeType) {
        case MenuStateSuccess:
          return Scaffold(
            appBar: buildTabBar(),
            body: buildBody(),
          );
        default:
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
            ),
          );
      }
    });
  }

  Widget buildTabBar() => AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop())
        ],
        title: Center(
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.black,
            controller: this._tabController,
            isScrollable: true,
            tabs: this._tabs,
          ),
        ),
      );

  Widget buildBody() => TabBarView(
        controller: this._tabController,
        children: List<BlocProvider<MenuCategoriesExpandableCubit>>.from(
            this.genres.map((e) => buildMenuCategoriesExpandable(e))),
      );

  BlocProvider buildMenuCategoriesExpandable(GenresInfo e) {
    return BlocProvider<MenuCategoriesExpandableCubit>(
      create: (_) => injectionContainer.sl<MenuCategoriesExpandableCubit>(),
      child: MenuCategoriesExpandable(
        genreId: e.id,
      ),
    );
  }
}
