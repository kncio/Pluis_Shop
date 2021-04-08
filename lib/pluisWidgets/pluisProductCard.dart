//TODO: Implementar las cartas de venta de productos.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/commons/localResourcesPool.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductCard extends StatelessWidget {
  //TODO: Implementar el modelo de datos de cada producto
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
                      image: this.product.image,
                      placeholder: kTransparentImage)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 2.0),
            child: Text(product.name,
                //TODO: Sustituir por la informacion dinamica
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ), //TODO: sustituir 20 por el default padding eventualmente
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 2.0, 0.0, 0.0),
            child: Text('\$22 cup',
                //TODO: SUstituir por la informacion dinamica
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ), //TO
        ],
      ),
    );
  }
}
