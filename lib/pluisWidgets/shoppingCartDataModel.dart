import 'package:pluis_hv_app/commons/productsModel.dart';

class ShoppingCart {
  final List<ShoppingOrder> shoppingList;

  ShoppingCart({this.shoppingList});

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

  /// Product selected Tall
  final String tall;

  /// Product selected tall, forced to by 1 on apk
  final int qty;

  ShoppingOrder(
      {this.id,
      this.name,
      this.product_price,
      this.color,
      this.tall,
      this.qty,
      this.productData});

  toMap() => {
        "id": this.id,
        "name": this.name,
        "product_price": this.product_price,
        "color": this.color,
        "tall": this.tall,
        "qty": this.qty.toString()
      };
}
