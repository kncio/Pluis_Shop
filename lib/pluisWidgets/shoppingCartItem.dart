import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';

class ShopCartItem extends StatelessWidget {
  final Product product;
  final String selectedTall;

  const ShopCartItem({Key key, this.product, this. selectedTall}) : super(key: key);

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
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Text(this.selectedTall,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
              Expanded(
                  child: Container(
                child: SizedBox(),
              )),
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
}
