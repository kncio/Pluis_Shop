import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Product {
  final Uuid productId;
  final String description;
  final String productName;
  final double productPrice;
  final AssetImage image;

  const Product({this.productId, this.description, this.productName, this.productPrice, this.image});
}