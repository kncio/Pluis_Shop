import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisButton.dart';

class DetailsPage extends StatefulWidget {
  final Product product;

  const DetailsPage({@required this.product});

  @override
  _DetailsPage createState() {
    return _DetailsPage(product: this.product);
  }
}

//TODO: FAlta maquetar el carousel para mostrar las diferentes fotos,
class _DetailsPage extends State<DetailsPage> {
  final Product product;
  bool addTapped = false;

  _DetailsPage({Key key, this.product});

  @override
  void initState() {
    super.initState();
    log(product.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: buildColumn(),
    );
  }

  Column buildColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Hero(
            tag: '${this.product.name}',
            child: Image.network(
             this.product.image,
            ),
          )),
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
            child: SizedBox(
              height: 50,
              child: ListTile(
                title: Text(
                  'PANTALONES BÁSICOS',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('39.99 cup'),
                trailing: IconButton(
                  onPressed: () => {},
                  icon:
                      Icon(Icons.arrow_downward, color: Colors.black, size: 20),
                ),
              ),
            ),
          )
        ],
      );

  SizedBox buildBottomNavigationBar() => SizedBox(
        height: 75,
        child: Row(children: [
          PLuisButton(
            press: () => {},
            label: 'AÑADIR',
          ),
          SizedBox(
            width: 100,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(DEFAULT_PADDING, 0, 1, 0),
              child: IconButton(
                icon: Icon(Icons.ios_share),
                onPressed: () => {},
                color: Colors.black,
              )),
          Container(
            padding: EdgeInsets.fromLTRB(DEFAULT_PADDING, 0, 1, 0),
            child: IconButton(
              icon: Icon(Icons.bookmark_border_sharp),
              onPressed: () => {},
              color: Colors.black,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(DEFAULT_PADDING, 0, 1, 0),
            child: IconButton(
              onPressed: () => {},
              color: Colors.black,
              icon: Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ]),
      );

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          onPressed: () => {
            Navigator.of(context).pop()
          },
          icon: Icon(Icons.clear_outlined),
          color: Colors.black,
        ),
      );
}
