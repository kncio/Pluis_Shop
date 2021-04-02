import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/localResourcesPool.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/detailsPage/detailsPage.dart';
import 'package:pluis_hv_app/galleryPage/galleryPageCubit.dart';
import 'package:pluis_hv_app/pluisWidgets/homeBottomBar.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCard.dart';
import 'package:uuid/uuid.dart';

import 'galleryPageState.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPage createState() {
    return _GalleryPage();
  }
}

class _GalleryPage extends State<GalleryPage> {
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
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget buildBody() {
    return BlocConsumer<GalleryPageCubit, GalleryPageState>(
        listener: (context, state) async {
          if(state is GalleryPageSuccessState){
            log(state.products.length.toString());
          }
          else if(state is GalleryPageErrorState){
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
    if(state is GalleryPageSuccessState  && state.products != null){
      log("returnin gridview");
      return GridView.builder(

        itemCount: state.products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          childAspectRatio: 0.60,
        ),
        itemBuilder: (context, index) => ProductCard(
          product: buildProduct(index),
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

  Product buildProduct(int index) {
    var product = Product(
        image: LocalResources.menImages[index].assetName,
        name: 'Prueba' + index.toString(),
        id: index.toDouble(),
        price: 22.0,
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
        onPressed: () {},
      ),
      title: Padding(
          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
          child: Text('ZAPATOS', style: TextStyle(color: Colors.black))),
      actions: <Widget>[],
    );
  }
}
