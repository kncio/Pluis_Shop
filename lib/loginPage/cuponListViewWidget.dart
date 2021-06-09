import 'package:flutter/cupertino.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

class CuponsListView extends StatelessWidget {
  const CuponsListView({
    Key key,
    @required this.userCupons,
  }) : super(key: key);

  final List<Cupon> userCupons;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              itemCount: (this.userCupons != null) ? this.userCupons.length : 0,
              itemBuilder: (context, index) {
                return Text(
                    'Descuento de ${this.userCupons[index].value_discount}');
              }),
        )
      ],
    );
  }
}