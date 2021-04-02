import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/localResourcesPool.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisButton.dart';
import 'package:pluis_hv_app/shopCart/shopCartCubit.dart';
import 'package:pluis_hv_app/shopCart/shopCartState.dart';

class ShopCartPage extends StatefulWidget {
  final Function appBarCancelOnPressFunc;
  final int totalProducts;

  const ShopCartPage(
      {Key key, this.appBarCancelOnPressFunc, this.totalProducts})
      : super(key: key);

  @override
  _ShopCartPage createState() {
    return _ShopCartPage(this.appBarCancelOnPressFunc, () => {}, totalProducts);
  }
}

class _ShopCartPage extends State<ShopCartPage> {
  final Function _onPress;
  final Function _onPressEdit;
  final int totalProducts;

  _ShopCartPage(this._onPress, this._onPressEdit, this.totalProducts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ShopCartCubit,ShopCartState>(
        listener: (context, state) async{

        },
        builder: (contet,state)
        {
          return buildBody();
        },
      ),
      bottomNavigationBar: buildBuyInfo(context),
    );
  }

  Column buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAppBar(),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: SizedBox(
              child: Text(
            'CARRITO DE COMPRAS',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: SizedBox(
              child: Text(
            '${this.totalProducts != null ? this.totalProducts : 3} productos',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          )),
        ),
        SizedBox(
          height: 16,
        ),
        itemsBody(),
      ],
    );
  }

  Widget buildBuyInfo(BuildContext context) {
    return SizedBox(
      child: Container(
        height: 150,
        padding: EdgeInsets.all(10),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Total  ' + '750  CUP',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  )),
              SizedBox(
                height: 25,
              ),
              DarkButton(text:"COMPRAR")
            ],
          ),
        ),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 2.0,
            spreadRadius: 1.5,
            offset: Offset(2.0, 2.0),
          )
        ]),
      ),
    );
  }

  //TODO: EL carrito tiene que ser persistente, o ser un endpoint de la api
  Widget itemsBody() {
    return Expanded(
      child: Container(
        // height: MediaQuery.of(context).size.height-300,
        child: ListView(
          children: [
            ShopCartItem(
              product: Product(image: LocalResources.menImages[4].assetName),
            ),
            SizedBox(
              height: 10,
            ),
            ShopCartItem(
              product: Product(image: LocalResources.menImages[2].assetName),
            ),
            SizedBox(
              height: 10,
            ),
            ShopCartItem(
              product: Product(image: LocalResources.menImages[1].assetName),
            ),
            SizedBox(
              height: 10,
            ),
            ShopCartItem(
              product: Product(image: LocalResources.menImages[4].assetName),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () => {
            Navigator.of(context).pop()
          },
        ),
        actions: [
          TextButton(onPressed: this._onPressEdit, child: Text('EDITAR'))
        ],
      );
}



class ShopCartItem extends StatelessWidget {
  final Product product;

  const ShopCartItem({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: Row(
        children: [
          Expanded(
              child: Image.network(
             this.product.image,
          )),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Text(
                    'PANTALONES DE TELA',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Text('32',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
              Expanded(
                  child: Container(
                child: SizedBox(),
              )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Text('375 cup',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 14))),
            ],
          ))
        ],
      ),
    );
  }
}
