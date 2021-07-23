import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';

class ProductCardCubit extends Cubit<ProductCardState> {
  final ProductCardRepository repository;

  ProductCardCubit({this.repository}) : super(ProductCardInitialState());

  Future<void> getPriceVariations(String price) async {
    emit(ProductCardInitialState());

    var eitherValue = await repository.getPriceVariation(price);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(ProductCardErrorState())
            : emit(ProductCardErrorState()),
        (list) => list.length >= 0
            ? emit(ProductCardSuccessState(variations: list))
            : emit(ProductCardErrorState()));
  }
}

abstract class ProductCardState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductCardInitialState extends ProductCardState {}

class ProductCardErrorState extends ProductCardState {}

class ProductCardSuccessState extends ProductCardState {
  final List<PriceVariation> variations;

  ProductCardSuccessState({this.variations});
}

class ProductCardRepository {
  final ApiClient api;

  ProductCardRepository({this.api});

  Future<Either<Failure, List<PriceVariation>>> getPriceVariation(
      String price) async {
    List<PriceVariation> variations = [];

    try {
      var response = await api.get(GET_PRICES_VARIATIONS, {"price": price});

      if (response.statusCode == 200) {
        log(response.data["data"].toString());
        variations = unpack(response.data["data"]);
        log("list lenght");
        return Right(variations);
      } else {
        log(response.statusCode.toString());
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  List<PriceVariation> unpack(dynamic data) {
    var value = <PriceVariation>[];

    var parsedData = (data as Map<String, dynamic>);
    for (var key in parsedData.keys) {
      value.add(PriceVariation.fromMap(parsedData[key]));
    }

    return value;
  }

  Future<Either<Failure, Product>> getProductDetail(
      String rowId) async {
    Product product;
    try {
      var response =
      await api.get(GET_PRODUCT_DETAIL, {"row_id": rowId});

      if (response.statusCode == 200) {

        product = Product.fromMap(response.data['data']);

        return Right(product);
      } else {
        log(response.statusCode.toString());
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }
}

class PriceVariation {
  final String price;
  final String coin;

  PriceVariation({this.price, this.coin});

  factory PriceVariation.fromMap(Map<String, dynamic> json) => PriceVariation(
      price: json["price"].toString(), coin: json["coin"].toString());
}
