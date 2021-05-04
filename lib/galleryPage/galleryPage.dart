import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/localResourcesPool.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/detailsPage/detailsPage.dart';
import 'package:pluis_hv_app/galleryPage/galleryPageCubit.dart';
import 'package:pluis_hv_app/pluisWidgets/homeBottomBar.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCard.dart';
import 'package:uuid/uuid.dart';

import 'galleryPageState.dart';

class GalleryPage extends StatefulWidget {
  final int categoryId;
  final int genderId;

  const GalleryPage({Key key, this.categoryId, this.genderId})
      : super(key: key);

  @override
  _GalleryPage createState() {
    return _GalleryPage(categoryId: this.categoryId, genderId: this.genderId);
  }
}

class _GalleryPage extends State<GalleryPage> {
  final int categoryId;
  final int genderId;

  _GalleryPage({this.categoryId, this.genderId});

  @override
  void initState() {
    context.bloc<GalleryPageCubit>().getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: buildBody(),
      bottomNavigationBar: BottomBar(
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
              MaterialPageRoute(
                  builder: (context) => DetailsPage(
                        product: state.products[index],
                      ))),
        ),
      );
    }
  }

  //TODO: Set the fetched info
  Product buildProduct(int index, String image) {
    var product = Product(
        image: image,
        name: 'Prueba' + index.toString(),
        id: index.toString(),
        price: "22.0",
        description: 'Descripción');
    return product;
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
          child: Text('ZAPATOS', style: TextStyle(color: Colors.black))),
      actions: <Widget>[],
    );
  }
}
