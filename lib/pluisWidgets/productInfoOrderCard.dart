import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/observables/colorStringObservable.dart';
import 'package:pluis_hv_app/observables/totalBloc.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCardCubit.dart';
import 'package:pluis_hv_app/pluisWidgets/shoppingCartDataModel.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

class ProductItem extends StatefulWidget {
  final String productRowId;
  final String selectedTall;
  final String colorRowId;
  final String coinNomenclature;
  final String qty;
  final String pricePerUnit;
  final String total;

  //An index tha represet the object on the cartSingleton
  final int index;

  const ProductItem(
      {Key key,
      this.productRowId,
      this.selectedTall,
      this.colorRowId,
      this.index,
      this.coinNomenclature,
      this.qty,
      this.pricePerUnit,
      this.total})
      : super(key: key);

  @override
  _ShopCartItem createState() {
    return _ShopCartItem(
        productRowId: this.productRowId,
        selectedTall: this.selectedTall,
        colorRowId: this.colorRowId,
        index: this.index,
        qty: this.qty,
        coinNomenclature: this.coinNomenclature);
  }
}

class _ShopCartItem extends State<ProductItem> {
  final String productRowId;
  final String selectedTall;
  final String colorRowId;
  final String coinNomenclature;
  final String qty;
  final String pricePerUnit;
  final String total;

  //An index tha represet the object on the cartSingleton
  final int index;

  ProductCardRepository _repository =
      injectorContainer.sl<ProductCardRepository>();

  Product _product;
  bool _loading = true;
  bool _error = false;
  String _hexColorCode = "";

  _ShopCartItem({
    Key key,
    this.productRowId,
    this.selectedTall,
    this.colorRowId,
    this.index,
    this.coinNomenclature,
    this.qty,
    this.pricePerUnit,
    this.total,
  });

  @override
  void initState() {
    super.initState();

    this._repository.getProductDetail(this.productRowId).then((value) => {
          value.fold(
            (failure) => failure.properties.isEmpty
                ? this.setState(() {
                    _error = true;
                  })
                : this.setState(() {
                    _error = true;
                  }),
            (product) => product != null
                ? this.setState(() {
                    _product = product;
                    this._loading = false;
                  })
                : this.setState(() {
                    _error = true;
                  }),
          )
        });
  }

  @override
  Widget build(BuildContext context) {
    return (!this._loading && !this._error)
        ? SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Row(
              children: [
                Expanded(child: Image.network(this._product.image,)),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: Text(
                          this._product.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        )),
                    Wrap(children: [
                      Text("Talla: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(this.selectedTall,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                    ]),
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("Color: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("${this.colorRowId}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ]),
                    Row(
                      children: [
                        Text(this.qty,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(" Unidad(es)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14))
                      ],
                    ),
                    Flexible(
                      child: buildPriceStreamBuilder(),
                    ),
                  ],
                ))
              ],
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget buildPriceStreamBuilder() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: StreamBuilder(
        stream: currentPriceVariation(
                (this._product.is_discount == "1")
                    ? this.total
                    : this._product.price,
                this.coinNomenclature)
            .asStream(),
        builder: (_, snapshot) {
          return Text(
              (snapshot.data != null)
                  ? snapshot.data + "  ${this.coinNomenclature}"
                  : "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
        },
      ),
      subtitle: (this._product.is_discount == "1")
          ? StreamBuilder(
              stream: currentPriceVariation(
                      this._product.price, this.coinNomenclature)
                  .asStream(),
              builder: (_, snapshot) {
                return Text(
                  (snapshot.data != null)
                      ? snapshot.data + "  ${this.coinNomenclature}"
                      : "",
                  style: TextStyle(
                      decorationColor: Colors.red,
                      decoration: TextDecoration.lineThrough),
                );
              },
            )
          : SizedBox.shrink(),
    );
  }

  Future<String> currentPriceVariation(
      String price, String selectedCoinNomencalture) async {
    var currentPrice = price;
    var priceVariations = <PriceVariation>[];
    var eitherValue = await this._repository.getPriceVariation(price);

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
