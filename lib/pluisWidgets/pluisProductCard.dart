import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/observables/aviablepPricesObservable.dart';
import 'package:transparent_image/transparent_image.dart';

import 'pluisProductCardCubit.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final Function press;
  final SelectedCurrencyBloc currencyBloc;

  const ProductCard({Key key, this.product, this.press, this.currencyBloc})
      : super(key: key);

  @override
  _ProductCard createState() {
    return _ProductCard(
        product: this.product,
        press: this.press,
        currencyBloc: this.currencyBloc);
  }
}

class _ProductCard extends State<ProductCard> {
  final Product product;
  final Function press;
  final SelectedCurrencyBloc currencyBloc;

  _ProductCard({this.product, this.press, this.currencyBloc});

  //prices variation and price to show
  List<PriceVariation> pricesVariations = [];
  int selectedPriceVariation = 0;

  @override
  void initState() {
    context.read<ProductCardCubit>().getPriceVariations(this.product.price);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCardCubit, ProductCardState>(
        listener: (context, state) async {
          if (state is ProductCardSuccessState) {
            setState(() {
              this.pricesVariations = state.variations;
            });
          }
        },
        buildWhen: (previous, current) => current is ProductCardSuccessState,
        builder: (context, state) {
          return GestureDetector(
            onTap: press,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Hero(
                        tag: '${this.product.name}',
                        child: FadeInImage.memoryNetwork(
                            imageScale: 0.5,
                            image: this.product.image,
                            placeholder: kTransparentImage)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 2.0),
                  child: Text(product.name,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 2.0, 0.0, 0.0),
                  child: StreamBuilder(
                      stream: this.currencyBloc.currencyObservable,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.data != null) {
                          return buildPriceContainer(snapshot);
                        }
                        return SizedBox.shrink();
                      }),
                ), //TO
              ],
            ),
          );
        });
  }

  Widget buildPriceContainer(AsyncSnapshot<String> snapshot) {
    var normalPrice =
        "${(this.pricesVariations.length > 0) ? this.pricesVariations[this.selectedPriceVariation].price : this.product.price} ${snapshot.data}";

    var discountPercent = (this.product.is_discount == "1")
        ? "  -${this.product.discount_percentaje}%"
        : "";

    return RichText(
        text: TextSpan(style: TextStyle(color: Colors.black),children: <TextSpan>[
      TextSpan(
          text: normalPrice,
          style: TextStyle(
              color: Colors.black,
              decorationThickness: 2.85,
              decorationColor: Colors.red,
              decoration: (this.product.is_discount == "1")
                  ? TextDecoration.lineThrough
                  : TextDecoration.none)),
          TextSpan(text: discountPercent)
    ]));
  }
}
