import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/argsClasses.dart';
import 'package:pluis_hv_app/commons/pagesRoutes.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';

import 'package:pluis_hv_app/detailsPage/detailsPage.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageCubit.dart';
import 'package:pluis_hv_app/galleryPage/galleryPageCubit.dart';
import 'package:pluis_hv_app/pluisWidgets/homeBottomBar.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCard.dart';

import '../injectorContainer.dart' as injectionContainer;
import 'galleryPageState.dart';

class GalleryPage extends StatefulWidget {
  final GalleryArgs categoryInfo;

  const GalleryPage({Key key, this.categoryInfo}) : super(key: key);

  @override
  _GalleryPage createState() {
    return _GalleryPage(categoryInfo: this.categoryInfo);
  }
}

class _GalleryPage extends State<GalleryPage> {
  final GalleryArgs categoryInfo;

  _GalleryPage({this.categoryInfo});

  @override
  void initState() {
    if (this.categoryInfo != null) {
      context
          .read<GalleryPageCubit>()
          .getProductsByCategory(this.categoryInfo.categoryId);
    } else {
      context.read<GalleryPageCubit>().getAllProducts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: buildBody(),
      bottomNavigationBar: BottomBar(
        onPressBookmark: () => Navigator.of(context).pushNamed(ADDRESS_BOOK_ROUTE),
        onPressSearch: ()=> Navigator.of(context).pushReplacementNamed(HOME_PAGE_ROUTE),
        onPressShopBag: () => Navigator.of(context).pushNamed(SHOP_CART),
        onPressAccount: () => Navigator.of(context).pushNamed(LOGIN_PAGE_ROUTE),
        onPressMenu: () => Navigator.of(context).pushNamed(MENU_PAGE),
      ),
    );
  }

  Widget buildBody() {
    return BlocConsumer<GalleryPageCubit, GalleryPageState>(
        listener: (context, state) async {
          if (state is GalleryPageSuccessState) {
            log(state.products.toString());
          } else if (state is GalleryPageErrorState) {
            log("Errror: => " + state.message);
          }
        },
        buildWhen: (previous, current) =>
            current is GalleryPageSuccessState ||
            previous is GalleryPageLoadingState,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: buildGridView(context, state),
              ))
            ],
          );
        });
  }

  GridView buildGridView(BuildContext context, GalleryPageState state) {
    if (state is GalleryPageSuccessState && state.products != null) {
      return GridView.builder(
        itemCount: state.products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          childAspectRatio: 0.60,
        ),
        itemBuilder: (context, index) => ProductCard(
          product: state.products[index],
          press: () => Navigator.push(
              context,
              PLuisPageRoute(
                  builder: (_) => BlocProvider<DetailsCubit>(
                        create: (_) => injectionContainer.sl<DetailsCubit>(),
                        child: DetailsPage(
                          product: state.products[index],
                        ),
                      ))),
        ),
      );
    }
  }

  appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: () => {Navigator.pop(context)},
      ),
      title: Padding(
          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
          child: Text(
              this.categoryInfo != null ? this.categoryInfo.name : "TODOS",
              style: TextStyle(color: Colors.black))),
      actions: <Widget>[],
    );
  }
}
