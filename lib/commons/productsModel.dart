import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Product {
  final double id;
  final String description;
  final String name;
  final double price;
  final String status;
  final String visibility;
  final String hit;
  final String is_discount;
  final String discount_price;
  final String discount_percentaje;
  final String updated_at;
  final String created_at;
  final String row_id;
  final String category_id;

  //Product Image UR
  final String image;

  Product(
      {this.id,
      this.description,
      this.name,
      this.price,
      this.status,
      this.visibility,
      this.hit,
      this.is_discount,
      this.discount_price,
      this.discount_percentaje,
      this.updated_at,
      this.created_at,
      this.row_id,
      this.category_id,
      this.image});

  static Product fromMap(Map<String, dynamic> data) {
    return Product(
        id: data['id'],
        description: data["description"],
        name: data["name"],
        price: data["price"],
        status: data["status"],
        visibility: data["visibility"],
        hit: data["hit"],
        is_discount: data["is_discount"],
        discount_price: data["discount_price"],
        discount_percentaje: data["discount_percentaje"],
        updated_at: data["updated_at"],
        row_id: data["row_id"],
        category_id: data["category_id"],
        image: data["image"]);
  }
}

// {
// "id": "120",
// "category_id": "15",
// "name": "Producto de Prueba",
// "description": "",
// "price": "150.00",
// "status": "1",
// "visibility": "1",
// "hit": "7",
// "image": "bb5bec0c57955bc8466aa7ac0f5e5132d3309a44-Producto_de_Prueba-Store_Collection.jpg",
// "is_discount": "0",
// "discount_price": "0.00",
// "discount_percentaje": "0",
// "updated_at": null,
// "created_at": "1616391649",
// "row_id": "60582de153153"
// }
