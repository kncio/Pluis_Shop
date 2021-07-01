import 'dart:developer';

import 'package:pluis_hv_app/pluisWidgets/pluisProductCardCubit.dart';
import 'package:pluis_hv_app/pluisWidgets/shoppingCartDataModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

//Singleton
class TotalBloc {
  double sum =
      0; //if the data is not passed by paramether it initializes with 0
  BehaviorSubject<double> _subjectCounter;

  ProductCardRepository _repository =
      injectorContainer.sl<ProductCardRepository>();

  final ShoppingCart shoppingCartReference;

  TotalBloc({this.sum, this.shoppingCartReference}) {
    _subjectCounter = new BehaviorSubject<double>.seeded(
        this.sum); //initializes the subject with element already
  }

  Stream<double> get counterObservable => _subjectCounter.stream;

  void updateTotal(String coinNomenclature) {
    sum = 0;
    this.shoppingCartReference.shoppingList.forEach((product) {
      sum += double.tryParse(product.productData.price) * product.qty;
    });

    currentPriceVariation(sum.toString(), coinNomenclature)
        .then((value) => {_subjectCounter.sink.add(double.parse(value))});
  }

  Future<String> currentPriceVariation(
      String Price, String selectedCoinNomencalture) async {
    var currentPrice = Price;
    var priceVariations = <PriceVariation>[];
    var eitherValue = await this._repository.getPriceVariation(Price);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? log("Failure")
            : log(failure.properties.first),
        (priceVariation) => priceVariation.length >= 0
            ? priceVariations = priceVariation
            : log("agg error"));

    currentPrice = priceVariations
        .where((variation) => variation.coin == selectedCoinNomencalture.trim())
        .first
        .price;

    return currentPrice;
  }

  void dispose() {
    _subjectCounter.close();
  }
}
