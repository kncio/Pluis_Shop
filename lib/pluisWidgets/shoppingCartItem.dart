import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/observables/totalBloc.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCardCubit.dart';
import 'package:pluis_hv_app/pluisWidgets/shoppingCartDataModel.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

class ShopCartItem extends StatefulWidget {
  final Product product;
  final String selectedTall;
  final String hexColorCode;
  final String coinNomenclature;

  //An index tha represet the object on the cartSingleton
  final int index;

  const ShopCartItem(
      {Key key,
      this.product,
      this.selectedTall,
      this.hexColorCode,
      this.index,
      this.coinNomenclature})
      : super(key: key);

  @override
  _ShopCartItem createState() {
    return _ShopCartItem(
        product: this.product,
        selectedTall: this.selectedTall,
        hexColorCode: this.hexColorCode,
        index: this.index,
        coinNomenclature: this.coinNomenclature);
  }
}

class _ShopCartItem extends State<ShopCartItem> {
  final Product product;
  final String selectedTall;
  final String hexColorCode;
  final String coinNomenclature;

  //An index tha represet the object on the cartSingleton
  final int index;

  ProductCardRepository _repository =
      injectorContainer.sl<ProductCardRepository>();

  ShoppingCart shoppingCartReference;
  TotalBloc _totalBloc = injectorContainer.sl<TotalBloc>();

  _ShopCartItem(
      {Key key,
      this.product,
      this.selectedTall,
      this.hexColorCode,
      this.index,
      this.coinNomenclature}) {
    shoppingCartReference = injectorContainer.sl<ShoppingCart>();
  }

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
                    this.product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              Wrap(children: [
                Text("Talla: ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(this.selectedTall,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18))),
              ]),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text("Color: ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(hexColor(this.hexColorCode))),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                  ),
                ),
              ]),
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (this
                                .shoppingCartReference
                                .shoppingList[this.index]
                                .qty >
                            1) {
                          setState(() {
                            this
                                .shoppingCartReference
                                .substractProductQty(index);
                          });
                          this._totalBloc.updateTotal();
                        }
                      }),
                  Text(this
                      .shoppingCartReference
                      .shoppingList[this.index]
                      .qty
                      .toString()),
                  IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        //validar si hay existencias
                        setState(() {
                          this.shoppingCartReference.addProductQty(index);
                        });
                        this._totalBloc.updateTotal();
                      }),
                  Text("Unidades")
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
                  child: buildPriceStreamBuilder()),
            ],
          ))
        ],
      ),
    );
  }

  StreamBuilder buildPriceStreamBuilder() {
    return StreamBuilder(
      stream: currentPriceVariation(this.product.price, this.coinNomenclature)
          .asStream(),
      builder: (_, snapshot) {
        return Text(
          (snapshot.data != null) ? snapshot.data : "",
        );
      },
    );
  }

  Future<String> currentPriceVariation(
      String Price, String selectedCoinNomencalture) async {
    var currentPrice = this.product.price;
    var priceVariations = <PriceVariation>[];
    var eitherValue =
        await this._repository.getPriceVariation(this.product.price);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? log("Failure")
            : log(failure.properties.first),
        (priceVariation) => priceVariation.length >= 0
            ? priceVariations = priceVariation
            : log("agg error"));

    currentPrice = priceVariations
        .where((variation) => variation.coin == this.coinNomenclature.trim())
        .first
        .price;

    return currentPrice;
  }

  int hexColor(String colorCodeString) {
    String xFormat = "0xff" + colorCodeString;
    xFormat = xFormat.replaceAll('#', '');
    int xIntFormat = int.parse(xFormat);
    return xIntFormat;
  }
}
