import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

class CuponsListView extends StatelessWidget {
  const CuponsListView({
    Key key,
    @required this.userCupons,
  }) : super(key: key);

  final List<Cupon> userCupons;

  @override
  Widget build(BuildContext context) {
    return (this.userCupons != null && this.userCupons.length > 0)
        ? Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Text(
                    "Cupones disponibles",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ))),
              Expanded(
                child: ListView.builder(
                    itemCount:
                        (this.userCupons != null) ? this.userCupons.length : 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Descuento:'.toUpperCase() +
                                  ' ${this.userCupons[index].value_discount}' +
                                  ' ${discountTipe(this.userCupons[index])}'),
                              Text('Cantidad disponible:'.toUpperCase() +
                                  ' ${this.userCupons[index].qty}'),
                              Divider()
                            ]),
                      );
                    }),
              )
            ],
          )
        : Center(
            child: Text(
              "Usted no posee cupones de descuento",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16),
            ),
          );
  }

  String discountTipe(Cupon cupon) {
    return (cupon.type_discount == "1")
        ? "    TIPO: %"
        : " TIPO:  cantidad fija";
  }
}
