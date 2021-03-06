import 'dart:developer';

import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/observables/totalBloc.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCardCubit.dart';
import 'package:pluis_hv_app/pluisWidgets/shoppingCartDataModel.dart';

import 'package:pluis_hv_app/pluisWidgets/shoppingCartItem.dart';
import 'package:pluis_hv_app/pluisWidgets/snackBar.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import 'package:pluis_hv_app/shopCart/shopCartCubit.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';
import 'package:pluis_hv_app/shopCart/shopCartState.dart';

import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ShopCartPage extends StatefulWidget {
  final Function appBarCancelOnPressFunc;

  const ShopCartPage({Key key, this.appBarCancelOnPressFunc}) : super(key: key);

  @override
  _ShopCartPage createState() {
    return _ShopCartPage();
  }
}

class _ShopCartPage extends State<ShopCartPage> {
  //Data
  List<Cupon> userCupons;
  List<ClientAddress> userAddress;
  DeliveryPrice shipPrice;
  List<SiteCurrency> currencys;

  //State vars
  bool editing = false;
  bool details = true;
  SiteCurrency selectedCurrency;
  Cupon selectedCupon;
  ClientAddress selectedAddress;

  ShoppingCart shoppingCartReference;

  //Metodos de entrega checkbox Values
  bool onSore = true;
  bool onDefaultAddress = false;
  bool onCustomAddress = false;

  //Cash values
  double subTotal = 0;
  double discount = 0;
  double shipmentPrice = 0;
  double total = 0;

  //TOTal bloc observable
  TotalBloc _totalBloc = injectorContainer.sl<TotalBloc>();

  ProductCardRepository _repository =
      injectorContainer.sl<ProductCardRepository>();

  _ShopCartPage();

  @override
  void initState() {
    shoppingCartReference = injectorContainer.sl<ShoppingCart>();

    this.editing = false;
    super.initState();
    context.read<ShopCartCubit>().getCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: BlocConsumer<ShopCartCubit, ShopCartState>(
        listener: (context, state) async {
          switch (state.runtimeType) {
            case ShopCartOrderSentSuccess:
              // showSnackbar(context, text: "Orden Creada satisfactoriamente");
              this.shoppingCartReference.resetCart();
              // Future.delayed(Duration(seconds: 4)).whenComplete(() =>
              //     Navigator.of(context).pushNamedAndRemoveUntil(
              //         HOME_PAGE_ROUTE, ModalRoute.withName('/')));
              showSuccessDialog(context);
              return log("Cambio!");

            case ShopCartCuponsLoadedState:
              //CAll to getAddress
              Settings.userId.then((value) =>
                  context.read<ShopCartCubit>().getClientAddress(value));
              return this.userCupons =
                  (state as ShopCartCuponsLoadedState).cupons;
            case ShopCartAddressLoadedState:
              this.userAddress = (state as ShopCartAddressLoadedState).address;
              context.read<ShopCartCubit>().setSuccess();
              return null;
            case ShopCartCurrencyLoadedState:
              setState(() {
                this.selectedCurrency =
                    (state as ShopCartCurrencyLoadedState).currencys[0];
                _totalBloc.updateTotal(
                    this.selectedCurrency.coin_nomenclature.trim());
              });
              return this.currencys =
                  (state as ShopCartCurrencyLoadedState).currencys;
            case ShopCartErrorState:
              log("Error" + (state as ShopCartErrorState).message);
              return null;
            default:
              log(state.runtimeType.toString());
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case ShopCartSuccessState:
              return itemsBody();
            case ShopCartCurrencyLoadedState:
              if (Settings.isLoggedIn) {
                Settings.userId.then(
                    (value) => context.read<ShopCartCubit>().getCupons(value));
                return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                );
              }
              return Center(
                child: Text(
                    "Debe iniciar sesi??n para porder realizar la compra",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              );
            case ShopCartErrorState:
              if ((state as ShopCartErrorState).message.contains("timeout")) {
                showSnackbar(context,
                    text:
                        "Intente denuevo. El servidor est?? tardando en responder",
                    timeLimit: 5);
              }
              return itemsBody();
            default:
              return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
              );
          }
        },
      ),
      bottomNavigationBar: buildBuyInfo(context),
    );
  }

  Widget buildBuyInfo(BuildContext context) {
    return SizedBox(
      child: Container(
        height: 150,
        padding: EdgeInsets.all(10),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Flexible(
                child: Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 16),
                    child: buildTotalFormatText()),
              ),
              DarkButton(
                text: (this.details) ? "DATOS DE COMPRA" : "VER LISTADO",
                action: () {
                  setState(() {
                    this.details = !this.details;
                  });
                },
              )
            ],
          ),
        ),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 2.0,
            spreadRadius: 1.5,
            offset: Offset(2.0, 2.0),
          )
        ]),
      ),
    );
  }

  Widget buildTotalFormatText() {
    return Wrap(
      direction: Axis.vertical,
      children: [
        StreamBuilder(
          stream: _totalBloc.counterObservable,
          builder: (context, AsyncSnapshot<double> snapshot) {
            return Text(
              'SUBTOTAL:  ' +
                  '${applyDiscountAndDelivery(snapshot.data)}' +
                  ((this.selectedCurrency != null)
                      ? "  " + this.selectedCurrency.coin_nomenclature
                      : ""),
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            );
          },
        ),
        (this.selectedCurrency != null)
            ? StreamBuilder(
                stream: this
                    .getPriceVariation(this.shipmentPrice.toString(),
                        this.selectedCurrency.coin_nomenclature)
                    .asStream(),
                builder: (_, AsyncSnapshot<String> snapshot) {
                  return (snapshot.data != null)
                      ? Text(
                          "+ DOMICILIO: ${snapshot.data}" +
                              " ${((this.selectedCurrency != null) ? "  " + this.selectedCurrency.coin_nomenclature : "")}",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 16))
                      : SizedBox.shrink();
                })
            : SizedBox.shrink()
      ],
    );
  }

  String applyDiscountAndDelivery(double subTotal) {
    if (subTotal != null) {
      double sicount = 0;
      if (this.selectedCupon != null) {
        if (this.selectedCupon.type_discount == "1") {
          sicount =
              (subTotal * double.parse(this.selectedCupon.value_discount)) /
                  100;
        } else if (this.selectedCupon.type_discount == "2") {
          sicount = double.parse(this.selectedCupon.value_discount);
        }
      }

      return (subTotal - sicount).toString();
    }
    return "0.00";
  }

  Widget buildDetailsSelector(BuildContext context) {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //METODO DE ENTREGA
        Wrap(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 20),
              child: Text("M??todo de entrega",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            Wrap(
              children: [
                Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Checkbox(
                      activeColor: Colors.black,
                      value: this.onSore,
                      onChanged: (value) {
                        setState(() {
                          if (!this.onSore) {
                            this.onSore = !this.onSore;

                            this.onCustomAddress = !this.onSore;
                            this.onDefaultAddress = !this.onSore;
                            this.shipmentPrice = 0;
                          }
                        });
                      }),
                  Text(
                    "Recoger en tienda",
                  )
                ]),
                Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Checkbox(
                      activeColor: Colors.black,
                      value: this.onDefaultAddress,
                      onChanged: (value) {
                        setState(() {
                          if (!this.onDefaultAddress) {
                            this.onDefaultAddress = !this.onDefaultAddress;

                            this.onSore = !this.onDefaultAddress;
                            this.onCustomAddress = !this.onDefaultAddress;
                            //setprice
                            Settings.userId.then((user_id) => context
                                .read<ShopCartCubit>()
                                .getDefaultClientAddress(user_id)
                                .then((value) => context
                                    .read<ShopCartCubit>()
                                    .getDeliveryPrice(value.city_id)
                                    .then((value) => this.setState(() {
                                          this.shipmentPrice = value;
                                        }))));
                          }
                        });
                      }),
                  Text(
                    "Mi direcci??n de registro",
                  )
                ]),
                Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Checkbox(
                      activeColor: Colors.black,
                      value: (this.onCustomAddress),
                      onChanged: (value) {
                        setState(() {
                          if (!this.onCustomAddress) {
                            this.onCustomAddress = !this.onCustomAddress;

                            this.onDefaultAddress = !this.onCustomAddress;
                            this.onSore = !this.onCustomAddress;
                            if (this.selectedAddress != null) {
                              context
                                  .read<ShopCartCubit>()
                                  .getDeliveryPrice(
                                      this.selectedAddress.city_id)
                                  .then((value) => this.setState(() {
                                        this.shipmentPrice = value;
                                      }));
                            }
                          }
                        });
                      }),
                  Text(
                    "Otra direcci??n",
                  )
                ]),
              ],
            ),
          ],
        ),
        Wrap(children: [
          (this.onCustomAddress)
              ? Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 64),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text("Sin Direcciones"),
                    value: this.selectedAddress,
                    // icon: Icon(Icons.arrow_downward),
                    style: TextStyle(color: Colors.black54),
                    underline: Container(
                      height: 1,
                      color: Colors.black54,
                    ),
                    onChanged: (ClientAddress address) {
                      setState(() {
                        this.selectedAddress = address;
                      });
                      context
                          .read<ShopCartCubit>()
                          .getDeliveryPrice(address.city_id)
                          .then((value) => this.setState(() {
                                this.shipmentPrice = value;
                              }));
                    },
                    items: this
                        .userAddress
                        .map<DropdownMenuItem<ClientAddress>>(
                            (ClientAddress value) {
                      return DropdownMenuItem<ClientAddress>(
                        value: value,
                        child: Text(value.address),
                      );
                    }).toList(),
                  ))
              : SizedBox.shrink(),
        ]),
        //CUPONES
        Wrap(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
              child: Text("Cupones",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: DropdownButton(
                  isExpanded: true,
                  hint: Text("Sin Cupon"),
                  value: this.selectedCupon,
                  // icon: Icon(Icons.arrow_downward),
                  style: TextStyle(color: Colors.black54),
                  underline: Container(
                    height: 1,
                    color: Colors.black54,
                  ),
                  onChanged: (Cupon cupon) {
                    setState(() {
                      this.selectedCupon = cupon;
                    });
                  },
                  items: this
                      .userCupons
                      .map<DropdownMenuItem<Cupon>>((Cupon value) {
                    return DropdownMenuItem<Cupon>(
                      value: value,
                      child: Text('DESCUENTO: ${value.value_discount}' +
                          ' ${discountTipe(value)}' + " Cantidad: ${value.qty}"),
                    );
                  }).toList(),
                ))
          ],
        ),
        //MONEDAS
        Wrap(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
            child: Text("Tipo de moneda",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: DropdownButton(
                isExpanded: true,
                hint: Text("Moneda"),
                value: this.selectedCurrency,
                // icon: Icon(Icons.arrow_downward),
                style: TextStyle(color: Colors.black54),
                underline: Container(
                  height: 1,
                  color: Colors.black54,
                ),
                onChanged: (SiteCurrency currency) {
                  setState(() {
                    this.selectedCurrency = currency;
                  });
                },
                items: this
                    .currencys
                    .map<DropdownMenuItem<SiteCurrency>>((SiteCurrency value) {
                  return DropdownMenuItem<SiteCurrency>(
                    value: value,
                    child: Text(value.coin_nomenclature),
                  );
                }).toList(),
              ))
        ]),
        Padding(
          padding: EdgeInsets.all(10),
          child: DarkButton(
            text: "COMPRAR",
            action: () async {
              await postBuyOrder();
            },
          ),
        )
      ],
    );
  }

  Widget itemsBody() {
    return Container(
      child: (this.details)
          ? ListView.builder(
              itemCount: this.shoppingCartReference.shoppingList.length,
              itemBuilder: (context, index) {
                return Wrap(alignment: WrapAlignment.end, children: [
                  this.editing
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              this
                                  .shoppingCartReference
                                  .shoppingList
                                  .removeAt(index);
                            });
                          })
                      : SizedBox.shrink(),
                  ShopCartItem(
                    index: index,
                    hexColorCode: this
                        .shoppingCartReference
                        .shoppingList[index]
                        .hexColorInfo,
                    selectedTall:
                        this.shoppingCartReference.shoppingList[index].tall,
                    product: this
                        .shoppingCartReference
                        .shoppingList[index]
                        .productData,
                    coinNomenclature: ((this.selectedCurrency != null)
                        ? "  " + this.selectedCurrency.coin_nomenclature
                        : ""),
                  )
                ]);
              })
          : buildDetailsSelector(context),
    );
  }

  @override
  void dispose() {
    // _totalBloc.dispose();
    super.dispose();
  }

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () => {Navigator.of(context).pop()},
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  this.editing = !this.editing;
                });
              },
              child: (this.details)
                  ? Text(
                      'EDITAR',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  : SizedBox.shrink())
        ],
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  child: Text(
                'CARRITO DE COMPRAS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                  child: Text(
                '${this.shoppingCartReference.shoppingList.length != null ? this.shoppingCartReference.shoppingList.length : 3} producto(s)',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              )),
            ],
          ),
        ),
      );

  Future<String> getPriceVariation(
      String Price, String selectedCoinNomencalture) async {
    var currentPrice = "";

    var priceVariations = <PriceVariation>[];
    var eitherValue = await this._repository.getPriceVariation(Price);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? log("Failure")
            : log(failure.properties.first),
        (priceVariation) => priceVariation.length >= 0
            ? priceVariations = priceVariation
            : log("agg error"));

    currentPrice = priceVariations
        .where((variation) => variation.coin == selectedCoinNomencalture.trim())
        .first
        .price;

    return currentPrice;
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Orden Realizada satisfactoriamente",
                style: PluisAppTheme.themeDataLight.textTheme.headline1),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'Usted podr?? verificar el estado del pedido en cualquier momento.'),
                  Text('Vuelva pronto.'),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HOME_PAGE_ROUTE, ModalRoute.withName('/'));
                  },
                  child: Text("Entendiddo"))
            ],
          );
        });
  }
  String discountTipe(Cupon cupon) {
    return (cupon.type_discount == "1") ? " TIPO: %" : " TIPO:  cantidad fija";
  }

  Future<void> postBuyOrder() async {
    if (this.shoppingCartReference.shoppingList.length > 0) {
      var token = await Settings.storedApiToken;
      var pickUp = storePickUp;
      if (this.onDefaultAddress) {
        pickUp = userDefaultAddress;
      }
      if (this.onCustomAddress) {
        pickUp = '${this.shipmentPrice}|${this.selectedAddress.id}';
        log(pickUp);
      }
      if (this.onDefaultAddress) {
        pickUp = '${this.shipmentPrice}' + userDefaultAddress;
      }
      //Retrieve buy data
      BuyOrderData buyOrder = BuyOrderData(
          token_csrf: token,
          shippingMethod: pickUp,
          shippingCurrency: this.selectedCurrency.id,
          cupon: (this.selectedCupon != null)
              ? this.selectedCupon.row_ticket
              : "0",
          cart_session: this.shoppingCartReference.toMap());

      await context.read<ShopCartCubit>().postBuyOrder(buyOrder);
    } else {
      showSnackbar(context, text: "No hay productos en el carrito");
    }
  }
}
