import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/pluisWidgets/shoppingCartDataModel.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

class ShopCartItem extends StatefulWidget {
  final Product product;
  final String selectedTall;
  final String hexColorCode;

  //An index tha represet the object on the cartSingleton
  final int index;

  const ShopCartItem(
      {Key key, this.product, this.selectedTall, this.hexColorCode, this.index})
      : super(key: key);

  @override
  _ShopCartItem createState() {
    return _ShopCartItem(
        product: this.product,
        selectedTall: this.selectedTall,
        hexColorCode: this.hexColorCode,
        index: this.index);
  }
}

class _ShopCartItem extends State<ShopCartItem> {
  final Product product;
  final String selectedTall;
  final String hexColorCode;

  //An index tha represet the object on the cartSingleton
  final int index;

  ShoppingCart shoppingCartReference;

  _ShopCartItem(
      {Key key,
      this.product,
      this.selectedTall,
      this.hexColorCode,
      this.index}) {
    shoppingCartReference = injectorContainer.sl<ShoppingCart>();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: Row(
        children: [
          Expanded(
              child: Image.network(
            this.product.image,
          )),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Text(
                    this.product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              Wrap(children: [
                Text("Talla: ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(this.selectedTall,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18))),
              ]),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(hexColor(this.hexColorCode))),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (this
                                .shoppingCartReference
                                .shoppingList[this.index]
                                .qty >
                            1) {
                          setState(() {
                            this
                                .shoppingCartReference
                                .shoppingList[this.index]
                                .qty -= 1;
                          });
                        }
                      }),
                  Text(this
                      .shoppingCartReference
                      .shoppingList[this.index]
                      .qty
                      .toString()),
                  IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        //validar si hay existencias
                        setState(() {
                          this
                              .shoppingCartReference
                              .shoppingList[this.index]
                              .qty += 1;
                        });
                      })
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Text(this.product.price,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 14))),
            ],
          ))
        ],
      ),
    );
  }

  int hexColor(String colorCodeString) {
    String xFormat = "0xff" + colorCodeString;
    xFormat = xFormat.replaceAll('#', '');
    int xIntFormat = int.parse(xFormat);
    return xIntFormat;
  }
}
