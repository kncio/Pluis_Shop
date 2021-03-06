import 'dart:convert';

import 'package:dartz/dartz_unsafe.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';

class ShoppingCart {
  final List<ShoppingOrder> shoppingList;

  ShoppingCart({this.shoppingList});

  List<Function> subscribers = [];

  //Add 1 unity to the product on the index index
  void addProductQty(int index) {
    this.shoppingList[index].qty += 1;
    this.subscribers.forEach((func) {
      func.call();
    });
  }

  //substract 1 unity to the product on the index index
  void substractProductQty(int index) {
    this.shoppingList[index].qty -= 1;
    this.subscribers.forEach((func) {
      func.call();
    });
  }

  String toMap() {
    Map<String, dynamic> cartSession = {};
    int index = 0;
    this.shoppingList.forEach((product) {
      cartSession[index.toString()] = product.toMap();
      index++;
    });
    var item = jsonEncode(cartSession);
    return item;
  }

  void resetCart() {
    this.shoppingList.clear();
  }
}

class ShoppingOrder {
  ///
  final Product productData;

  /// Product Row ID
  final String id;

  /// Product Name
  final String name;

  /// Product price per item
  final String product_price;

  /// Product selected color ID
  final String color;

  final String hexColorInfo;

  /// Product selected Tall
  final String tall;

  /// Product selected amount, forced to by 1 on apk
  int qty;

  /// Product amount top
  final int topQty;

  ShoppingOrder(
      {this.id,
      this.topQty,
      this.name,
      this.product_price,
      this.color,
      this.tall,
      this.qty,
      this.productData,
      this.hexColorInfo});

  //TO map for post buy order
  toMap() => {
        "id": this.id,
        "name": this.name,
        "product_price": this.product_price,
        "color": this.color,
        "tall": this.tall,
        "qty": this.qty.toString()
      };
}
