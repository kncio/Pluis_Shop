import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisButton.dart';
import 'package:pluis_hv_app/settings/settings.dart';

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

class OrderDetailsCubit extends Cubit<OrderDetailState> {
  OrderDetailsCubit() : super(OrderDetailStateInitial());
}

class OrderDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderDetailStateInitial extends OrderDetailState {}

class OrderDetailStateSuccess extends OrderDetailState {
  final OrderDetailData data;

  OrderDetailStateSuccess(this.data);
}

class OrderDetailData {
  final String id;
  final String order_number;
  final String id_account;
  final String price_subtotal;
  final String address_send;
  final String price_delivery;
  final String shipping_method;
  final String status;
  final String updated_at;
  final String created_at;
  final String currency_shipping;
  final String exchange_rate;
  final String buff;

  OrderDetailData(
      {this.id,
      this.order_number,
      this.id_account,
      this.price_subtotal,
      this.address_send,
      this.price_delivery,
      this.shipping_method,
      this.status,
      this.updated_at,
      this.created_at,
      this.currency_shipping,
      this.exchange_rate,
      this.buff});

  static fromJson(Map<String, dynamic> json) => OrderDetailData(
        id: json['id'],
        order_number: json['order_number'],
        id_account: json['id_account'],
        price_delivery: json['price_delivery'],
        address_send: json['address_send'],
        price_subtotal: json['price_subtotal'],
        shipping_method: json['shipping_method'],
        status: json['status'],
        updated_at: json['updated_at'],
        created_at: json['created_at'],
        currency_shipping: json['currency_shipping'],
        exchange_rate: json['exchange_rate'],
        buff: json['buff'],
      );
}
