

import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

class BuyOrderModel {

  final List<Tuple2<Uuid,int>> products;
  final List<int> sizes;

  BuyOrderModel(this.products, this.sizes);

}