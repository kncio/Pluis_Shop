import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/shoppingCartDataModel.dart';

import 'package:pluis_hv_app/pluisWidgets/shoppingCartItem.dart';
import 'package:pluis_hv_app/shopCart/shopCartCubit.dart';
import 'package:pluis_hv_app/shopCart/shopCartState.dart';

import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ShopCartPage extends StatefulWidget {
  final Function appBarCancelOnPressFunc;

  const ShopCartPage({Key key, this.appBarCancelOnPressFunc}) : super(key: key);

  @override
  _ShopCartPage createState() {
    return _ShopCartPage(this.appBarCancelOnPressFunc);
  }
}

class _ShopCartPage extends State<ShopCartPage> {
  final Function _onPress;

  bool editing;

  ShoppingCart shoppingCartReference;

  _ShopCartPage(this._onPress);

  @override
  void initState() {
    shoppingCartReference = injectorContainer.sl<ShoppingCart>();
    this.editing = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ShopCartCubit, ShopCartState>(
        listener: (context, state) async {},
        builder: (contet, state) {
          return buildBody();
        },
      ),
      bottomNavigationBar: buildBuyInfo(context),
    );
  }

  Widget buildBody() {
    return SlidingUpPanel(
      minHeight: 25,
      panel: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Container(
              width: 70,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
          ),
        ],
      ),
      body: Column(
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
              '${this.shoppingCartReference.shoppingList.length != null ? this.shoppingCartReference.shoppingList.length : 3} productos',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            )),
          ),
          SizedBox(
            height: 16,
          ),
          itemsBody(),
        ],
      ),
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
                    'TOTAL  ' + totalPice().toString(),
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  )),
              SizedBox(
                height: 25,
              ),
              DarkButton(
                text: "COMPRAR",
                action: () {}, //TODO:
              )
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

  Widget itemsBody() {
    return Expanded(
      child: Container(
        // height: MediaQuery.of(context).size.height-300,
        child: ListView.builder(
            itemCount: this.shoppingCartReference.shoppingList.length,
            itemBuilder: (context, index) {
              return Wrap(alignment: WrapAlignment.end, children: [
                this.editing
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            this
                                .shoppingCartReference
                                .shoppingList
                                .removeAt(index);
                          });
                        })
                    : SizedBox.shrink(),
                ShopCartItem(
                  selectedTall:
                      this.shoppingCartReference.shoppingList[index].tall,
                  product: this
                      .shoppingCartReference
                      .shoppingList[index]
                      .productData,
                )
              ]);
            }),
      ),
    );
  }

  //TODO: Implementar la formula para calcular los descuentos por productos y los cupones
  // Idea: Sacar el precio total sumando los productos, luego sacar
  // el descuento total pot cada producto, y por ultimo los cupones
  double totalPice() {
    double sum = 0;

    this.shoppingCartReference.shoppingList.forEach((product) {
      sum += double.tryParse(product.productData.price);
    });

    return sum;
  }

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () => {Navigator.of(context).pop()},
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  this.editing = !this.editing;
                });
              },
              child: Text('EDITAR'))
        ],
      );
}
