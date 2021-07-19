

import 'package:flutter/material.dart';

import 'DarkButton.dart';

class OrderDetails extends StatefulWidget {
  final String orderNumber;

  const OrderDetails({Key key, this.orderNumber}) : super(key: key);

  @override
  _OrderDetailsWidget createState() {
    return _OrderDetailsWidget();
  }
}

class _OrderDetailsWidget extends State<OrderDetails> {
  final String orderNumber;

  _OrderDetailsWidget({this.orderNumber});

  bool shipped = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 75,
        ),
        Center(
          child: Text(
            'Informacion de la orden'.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          ),
        ),
        //ProductList
        Expanded(
            child: ListView(
          children: [
            _buildListItem("pName", "color", "tall", "und", "price", "total")
          ],
        )),
        //informacion de envio
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Informacion de envío'.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                Text('Metodo de Envio:'),
                Spacer(),
                Text((this.shipped) ? 'Domicilio' : 'Recoger en tienda')
              ],
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Divider(),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [Text('Entregar a:'), Spacer(), Text('EL cojo')],
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Divider(),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [Text('Enviar a:'), Spacer(), Text('Stgo')],
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Divider(),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                Text('Numero de Telefono:'),
                Spacer(),
                Text('58379145')
              ],
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Divider(),
        ),
        Padding(
            padding: EdgeInsets.all(16),
            child: DarkButton(
                text: "Atras",
                action: () {
                  Navigator.of(context).pop();
                }))
      ],
    );
  }
}

Widget _buildListItem(String pName, String color, String tall, String und,
    String price, String total) {
  return Card(
    child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [Text("sa")],
        )),
  );
}

