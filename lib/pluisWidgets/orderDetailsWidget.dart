import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/pluisWidgets/orderDetailsWidgetRemote.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCardCubit.dart';
import 'package:pluis_hv_app/pluisWidgets/productInfoOrderCard.dart';

import 'DarkButton.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

class OrderDetails extends StatefulWidget {
  final String orderNumber;

  const OrderDetails({Key key, this.orderNumber}) : super(key: key);

  @override
  _OrderDetailsWidget createState() {
    return _OrderDetailsWidget(orderNumber: this.orderNumber);
  }
}

class _OrderDetailsWidget extends State<OrderDetails> {
  final String orderNumber;

  _OrderDetailsWidget({this.orderNumber});

  bool shipped = false;

  OrderDetailFullData _fullData;
  double totalApagar = 0;
  ProductCardRepository _repository =
      injectorContainer.sl<ProductCardRepository>();

  @override
  void initState() {
    super.initState();
    context.read<OrderDetailsCubit>().getDetails(this.orderNumber);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailsCubit, OrderDetailState>(
        listener: (context, state) async {
      log(state.runtimeType.toString());
      if (state is OrderDetailStateGetData) {
        log("finished order data now address");

        var st = double.tryParse(state.data.data.price_subtotal);
        var delivery = double.tryParse(state.data.data.price_delivery);
        var buff = double.tryParse(state.data.data.buff);
        totalApagar = (st + delivery) - buff;

        setState(() {
          this._fullData = state.data;
          this.shipped = this._fullData.data.shipping_method == "1";
        });
        context.read<OrderDetailsCubit>().getAddress(
            this._fullData.data.id_account,
            (this._fullData.data.address_send != "0")
                ? this._fullData.data.address_send
                : "Address User");
      }
    }, builder: (context, state) {
      switch (state.runtimeType) {
        case OrderDetailStateSuccess:
          return Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 75,
                ),
                Center(
                  child: Text(
                    'Información de la orden'.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18),
                  ),
                ),
                //ProductList
                Expanded(
                    child: ListView.separated(
                        separatorBuilder: (contex, index) {
                          return Divider(
                            indent: 16,
                            endIndent: 16,
                            color: Colors.black26,
                          );
                        },
                        itemCount: this._fullData.pinfo.length,
                        itemBuilder: (context, index) {
                          return ProductItem(
                            productRowId:
                                this._fullData.pinfo[index].product_id,
                            pricePerUnit:
                                this._fullData.pinfo[index].price_product,
                            total: this._fullData.pinfo[index].price_total,
                            selectedTall: this._fullData.pinfo[index].tall,
                            colorRowId: this._fullData.pinfo[index].color,
                            coinNomenclature: "CUP",
                            qty: this._fullData.pinfo[index].qty,
                          );
                        })),
                //informacion de envio
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Información de envío'.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16),
                  ),
                ),
                StreamBuilder(
                    stream: currentPriceVariation(
                            '${this._fullData.data.price_subtotal}', "CUP")
                        .asStream(),
                    builder: (context, snapshot) {
                      return _buildInfoCell(
                          "SubTotal:",
                          (snapshot.hasData)
                              ? '${snapshot.data}   CUP'
                              : 'Calculando');
                    }),
                (this._fullData.data.shipping_method != "0")
                    ? StreamBuilder(
                        stream: currentPriceVariation(
                                '${this._fullData.data.price_delivery}', "CUP")
                            .asStream(),
                        builder: (context, snapshot) {
                          return _buildInfoCell(
                              "Costo Domicilio:",
                              (snapshot.hasData)
                                  ? '${snapshot.data}   CUP'
                                  : 'Calculando');
                        })
                    : SizedBox.shrink(),
                (this._fullData.data.buff != "0")
                    ? StreamBuilder(
                        stream: currentPriceVariation(
                                '${this._fullData.data.buff}', "CUP")
                            .asStream(),
                        builder: (context, snapshot) {
                          return _buildInfoCell(
                              "Descuento:",
                              (snapshot.hasData)
                                  ? '${snapshot.data}   CUP'
                                  : 'Calculando');
                        })
                    : SizedBox.shrink(),
                StreamBuilder(
                    stream: currentPriceVariation(
                            '${this.totalApagar.toStringAsFixed(2)}', "CUP")
                        .asStream(),
                    builder: (context, snapshot) {
                      return _buildInfoCell(
                          "Total a Pagar",
                          (snapshot.hasData)
                              ? '${double.parse(snapshot.data).toStringAsFixed(2)}   CUP'
                              : 'Calculando');
                    }),

                _buildInfoCell("Método de envío: ",
                    (this.shipped) ? 'Domicilio' : 'Recoger en tienda'),
                _buildInfoCell(
                    "Entregar a: ",
                    '${(state as OrderDetailStateSuccess).address.name}' +
                        ' ' +
                        '${(state as OrderDetailStateSuccess).address.lastName}'),
                _buildInfoCell("Enviar a: ",
                    '${(state as OrderDetailStateSuccess).address.address}'),
                _buildInfoCell("Número de Teléfono: ",
                    '${(state as OrderDetailStateSuccess).address.phone_number}'),
                Padding(
                    padding: EdgeInsets.all(16),
                    child: DarkButton(
                        text: "Atras",
                        action: () {
                          Navigator.of(context).pop();
                        }))
              ],
            ),
          );
        default:
          return Center(
            child: CircularProgressIndicator(),
          );
      }
    });
  }

  Future<String> currentPriceVariation(
      String price, String selectedCoinNomencalture) async {
    var currentPrice = price;
    var priceVariations = <PriceVariation>[];
    var eitherValue = await this._repository.getPriceVariation(price);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? log("Failure")
            : log(failure.properties.first),
        (priceVariation) => priceVariation.length >= 0
            ? priceVariations = priceVariation
            : log("agg error"));

    currentPrice = priceVariations
        .where((variation) => variation.coin == selectedCoinNomencalture)
        .first
        .price;

    return currentPrice;
  }
}

Widget _buildInfoCell(String tag, String value) {
  return Column(
    children: [
      Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [Text(tag), Spacer(), Text(value)],
          )),
      Padding(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: Divider(),
      ),
    ],
  );
}

Widget _buildListItem(String pName, String color, String tall, String und,
    String price, String total) {
  return Card(
    child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [Text("Producto".toUpperCase()), Text("${pName}")],
            ),
            Row(
              children: [Text("Color & Talla".toUpperCase()), Text("${pName}")],
            ),
            Row(
              children: [Text("Und".toUpperCase()), Text("${und}")],
            ),
            Row(
              children: [Text("Precio".toUpperCase()), Text("${price}")],
            ),
            Row(
              children: [Text("Precio Total".toUpperCase()), Text("${total}")],
            ),
          ],
        )),
  );
}
