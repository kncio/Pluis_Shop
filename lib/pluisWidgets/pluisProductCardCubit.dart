
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';

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
        log(response.toString());
        for (var price in response.data["data"]) {
          variations.add(PriceVariation.fromMap(price));
        }
        log("list lenght" + variations.length.toString());
        return Right(variations);
      } else {
        log(response.statusCode.toString());
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

  factory PriceVariation.fromMap(Map<String, dynamic> json) =>
      PriceVariation(price: json["price"], coin: json["coin"]);
}