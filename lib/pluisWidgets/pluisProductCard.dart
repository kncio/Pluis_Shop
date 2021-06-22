import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function press;

  const ProductCard({Key key, this.product, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: Text('\$ ${product.price} USD',
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ), //TO
        ],
      ),
    );
  }
}

class PriceSelector extends StatefulWidget {
  final String price;

  const PriceSelector({Key key, this.price}) : super(key: key);

  @override
  _PriceSelector createState() {
    return _PriceSelector(price);
  }
}

class _PriceSelector extends State<PriceSelector> {
  final String price;

  _PriceSelector(this.price);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class PriceSelectorCubit extends Cubit {
  PriceSelectorCubit() : super(PriceSelectorInitalState());


}

abstract class PriceSelectorState extends Equatable {
  const PriceSelectorState();

  @override
  List<Object> get props => [];
}

class PriceSelectorInitalState extends PriceSelectorState {
}

class PriceSelectorReadyState extends PriceSelectorState {
  final List<PriceVariation> priceVariations;

  PriceSelectorReadyState(this.priceVariations);
}

class PriceVariation {
  final String price;
  final String coin;

  PriceVariation({this.price, this.coin});

}
