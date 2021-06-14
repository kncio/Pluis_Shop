import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/loginPage/loginCubit.dart';
import 'package:pluis_hv_app/loginPage/loginLocalDataSource.dart';
import 'package:pluis_hv_app/loginPage/loginRemoteDatasource.dart';
import 'package:pluis_hv_app/loginPage/loginStates.dart';
import 'package:pluis_hv_app/observables/billsObservable.dart';
import 'package:pluis_hv_app/observables/buysObservable.dart';
import 'package:pluis_hv_app/observables/pendingOrdersObservable.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisButton.dart';
import 'package:pluis_hv_app/pluisWidgets/snackBar.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

import 'cuponListViewWidget.dart';
import 'loginRepository.dart';
import 'loginUtils.dart';

enum OrderStatus {
  COMPLETADO,
  PENDIENTE,
  RECHAZADO,
  PROCESANDO,
  TRASNPORTACION,
  CANCELADO_POR_USUARIO
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _hidePassword = true;
  LoginDataForm _formData = LoginDataForm();
  TabController _tabController;
  bool isLogged = false;

  String userId = '';

  //Cupons
  List<Cupon> userCupons;

  //Pending Orders
  List<PendingOrder> pendingOrders;
  PendingOrdersBloc _pendingOrdersBloc;

  //Buys
  BuysBloc _buysBloc;

  //Bills Observable
  BillsBloc _billsBloc;

  //Update pasword form key
  final GlobalKey<FormState> _formEditPassKey = GlobalKey<FormState>();
  UpdatePasswordDataForm _updatePassFormData = UpdatePasswordDataForm();

  //Update email key
  final GlobalKey<FormState> _formEditEmailKey = GlobalKey<FormState>();
  UpdateEmailDataForm _updateEmailDataForm = UpdateEmailDataForm();

  //Subscription checkboxs
  bool man = false;
  bool woman = false;
  bool boy = false;
  bool girl = false;
  bool sms = false;
  bool email = false;

  @override
  void initState() {
    _billsBloc = BillsBloc(bills: []);
    _pendingOrdersBloc = PendingOrdersBloc(pendingOrders: []);
    _buysBloc = BuysBloc(buys: []);
    this._tabController = TabController(length: 6, vsync: this);
    context.read<LoginCubit>().isLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
      if (state is LoginErrorState) {
        //ShowSnackbar
        log("error");
        if (state.message.contains("Connection timed out")) {
          await showSnackbar(context,
              text: "El servidor está tardando en responder. Intente denuevo",
              timeLimit: 5);
        } else {
          await showSnackbar(context, text: state.message, timeLimit: 5);
        }
      } else if (state is LoginSuccessfulState) {
        var token = await Settings.storedToken;
        log("Secured : ${token}");
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HOME_PAGE_ROUTE, ModalRoute.withName("/"));
      }
      if (state is LoginIsLoggedState) {
        log("Called here");
        setState(() {
          this.isLogged = true;
          this.userId = (state as LoginIsLoggedState).message;
        });
        context
            .read<LoginCubit>()
            .getCupons((state as LoginIsLoggedState).message)
            .then((value) => this.userCupons = value);
        context
            .read<LoginCubit>()
            .getPendingOrders((state as LoginIsLoggedState).message)
            .then((list) => this._pendingOrdersBloc.updateOrders(list));
        context
            .read<LoginCubit>()
            .getFinishedOrders(state.message)
            .then((list) => this._buysBloc.updateOrders(list));
      }
    }, builder: (context, state) {
      switch (state.runtimeType) {
        case LoginSendingState:
          return ListView(
            children: [
              LinearProgressIndicator(
                  minHeight: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
              buildForm(),
              buildDarkButton(),
              buildRegisterText(context),
            ],
          );
        case LoginIsLoggedState:
          return Scaffold(
            body: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  controller: this._tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.black,
                  tabs: [
                    Text(
                      "CUPONES",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    Text(
                      "PEDIDOS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    Text(
                      "COMPRAS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    Text(
                      "FACTURAS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    Text(
                      "SUBSCRIPCIONES",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    Text(
                      "ACCESO",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    child:
                        TabBarView(controller: this._tabController, children: [
                      CuponsListView(userCupons: userCupons),
                      buildPendingOrdersListView(),
                      buildBuys(),
                      buildBills(),
                      buildSubs(),
                      buildAccessData(),
                    ]),
                  ),
                )
              ],
            ),
          );
        default:
          return ListView(
            children: [
              buildForm(),
              buildDarkButton(),
              buildRegisterText(context),
            ],
          );
      }
    });
  }

  ListView buildAccessData() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
            child: Text(
              "Cambio de dirección de correo electrónico",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
                " Si deseas cambiar la dirección de correo electrónico asociada a tu cuenta rellena los campos siguientes. Se solicita tu contraseña por motivos de seguridad.",
                style: TextStyle(fontSize: 14)),
          ),
        ),
        Center(
          child: Text(" Tu email actual es ejemplo@gmail.com "),
        ),
        Form(
            key: this._formEditEmailKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    onSaved: (newValue) =>
                        {this._updateEmailDataForm.currentPassword = newValue},
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    decoration: PluisAppTheme.textFormFieldDecoration(
                        labelText: "Contraseña Actual",
                        hintText: "Contraseña Actual"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: PluisAppTheme.textFormFieldDecoration(
                        labelText: "Introduce tu correo electrónico",
                        hintText: "Nuevo Email"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: PluisAppTheme.textFormFieldDecoration(
                        labelText: "Introduce tu correo electrónico",
                        hintText: "Repetir Email"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: DarkButton(
                    text: "ACTUALIZAR EMAIL",
                    action: () {
                      //TODO: call  the cubit for post the infotrmation
                    },
                  ),
                )
              ],
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Center(
            child: Text(
              "Cambio de contraseña",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        Form(
            key: this._formEditPassKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    onSaved: (newValue) =>
                        {this._updateEmailDataForm.currentPassword = newValue},
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    decoration: PluisAppTheme.textFormFieldDecoration(
                        labelText: "Contraseña Actual",
                        hintText: "Contraseña Actual"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: PluisAppTheme.textFormFieldDecoration(
                        labelText: "Introduce tu nueva contraseña",
                        hintText: "Nueva Contraseña"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: PluisAppTheme.textFormFieldDecoration(
                        labelText: "Introduce tu nueva contraseña",
                        hintText: "Repetir Contraseña"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: DarkButton(
                    text: "ACTUALIZAR CONTRASEÑA",
                    action: () {
                      //TODO: call  the cubit for post the infotrmation
                    },
                  ),
                )
              ],
            )),
      ],
    );
  }

  //TODO: repository, download pdf, pdfViewer.
  //Facturas
  Column buildBills() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
            child: StreamBuilder(
              stream: this._billsBloc.billsObservable,
              builder: (context, AsyncSnapshot<List<BillData>> snapshot) {
                return ListView.builder(
                    itemCount:
                        (snapshot.data != null) ? snapshot.data.length : 0,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                            child: Wrap(
                              children: [
                                Text(
                                  "NÚMERO DE PEDIDO: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${snapshot.data[index].link}')
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 12),
                              child: Wrap(children: [
                                Text("ESTADO DE PEDIDO: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(statusToString(snapshot.data[index].info)),
                              ])),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Divider())
                        ],
                      );
                    });
              },
            ),
          ),
        )
      ],
    );
  }

  Column buildBuys() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
            child: StreamBuilder(
              stream: this._buysBloc.bysObservable,
              builder: (context, AsyncSnapshot<List<PendingOrder>> snapshot) {
                return ListView.builder(
                    itemCount:
                        (snapshot.data != null) ? snapshot.data.length : 0,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                            child: Wrap(
                              children: [
                                Text(
                                  "NÚMERO DE PEDIDO: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${snapshot.data[index].order_number}')
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 12),
                              child: Wrap(children: [
                                Text("ESTADO DE PEDIDO: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(statusToString(
                                    snapshot.data[index].status)),
                                showCancelButton(snapshot.data[index])
                              ])),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Divider())
                        ],
                      );
                    });
              },
            ),
          ),
        )
      ],
    );
  }

  ListView buildSubs() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              "Configura tu newsletter y, semanalmente, recibirás novedades y tendencias de las secciones que hayas seleccionado.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Subscribirse al contenido de:",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Wrap(
            children: [
              CheckboxListTile(
                activeColor: Colors.black,
                value: this.man,
                onChanged: (bool value) {
                  setState(() {
                    this.man = value;
                  });
                },
                title: Text("Hombre"),
              ),
              CheckboxListTile(
                activeColor: Colors.black,
                value: this.woman,
                onChanged: (bool value) {
                  setState(() {
                    this.woman = value;
                  });
                },
                title: Text("Mujer"),
              ),
              CheckboxListTile(
                activeColor: Colors.black,
                value: this.boy,
                onChanged: (bool value) {
                  setState(() {
                    this.boy = value;
                  });
                },
                title: Text("Niño"),
              ),
              CheckboxListTile(
                activeColor: Colors.black,
                value: this.girl,
                onChanged: (bool value) {
                  setState(() {
                    this.girl = value;
                  });
                },
                title: Text("Niña"),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Deseo recibir notificaciones mediante:	:",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Wrap(
            children: [
              CheckboxListTile(
                activeColor: Colors.black,
                value: this.email,
                onChanged: (bool value) {
                  setState(() {
                    this.email = value;
                  });
                },
                title: Text("Correo"),
              ),
              CheckboxListTile(
                activeColor: Colors.black,
                value: this.sms,
                onChanged: (bool value) {
                  setState(() {
                    this.sms = value;
                  });
                },
                title: Text("Sms"),
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.all(20),
            child: DarkButton(
              text: "ACEPTAR",
              action: () {
                context
                    .read<LoginCubit>()
                    .postSubmissions(userId)
                    .then((value) => showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 200,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(
                                    child: Text(
                                      (value)
                                          ? "A partir de ahora recibirá notificaciones mediante la vía solicitada."
                                          : "Ha ocurrido un error, Intente nuevamente.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: DarkButton(
                                    text: "CANCELAR",
                                    action: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        }));
              },
            ))
      ],
    );
  }

  Widget buildPendingOrdersListView() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: this._pendingOrdersBloc.counterObservable,
            builder: (context, AsyncSnapshot<List<PendingOrder>> snapshot) {
              return ListView.builder(
                  itemCount: (snapshot.data != null) ? snapshot.data.length : 0,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                          child: Wrap(
                            children: [
                              Text(
                                "NÚMERO DE PEDIDO: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('${snapshot.data[index].order_number}')
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 12),
                            child: Wrap(children: [
                              Text("ESTADO DE PEDIDO: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              (snapshot.data[index].status == '5')
                                  ? Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                      size: 14,
                                    )
                                  : SizedBox.shrink(),
                              Text(statusToString(snapshot.data[index].status)),
                              showCancelButton(snapshot.data[index])
                            ])),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Divider())
                      ],
                    );
                  });
            },
          ),
        )
      ],
    );
  }

  Widget showCancelButton(PendingOrder order) {
    if (order.status == "0" || order.status == "3") {
      return PLuisButton(
        press: () {
          context
              .read<LoginCubit>()
              .postCancelOrder(order.order_number)
              .then((value) => context.read<LoginCubit>().isLogged());
        },
        label: "CANCELAR",
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildDarkButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DarkButton(
        text: "ACCEDER",
        action: doLogin,
      ),
    );
  }

  Container buildRegisterText(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: "No tienes cuenta?", style: TextStyle(color: Colors.black)),
          TextSpan(
              text: "   Regístrate",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  Navigator.of(context).pushNamed(REGISTER_PAGE_ROUTE);
                }),
        ]),
      ),
    );
  }

  Form buildForm() {
    return Form(
        key: this._formKey,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              child: Text(
                "Acceder con Correo",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) {
                  _formData.email = newValue.trim();
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Correo Electrónico",
                  // prefixIcon: Icon(Icons.email_outlined),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) {
                  _formData.password = newValue.trim();
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: this._hidePassword,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
            )
          ],
        ));
  }

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () => {Navigator.of(context).pop()},
        ),
        title: (this.isLogged)
            ? Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Text(
                  "INFORMACIÓN PERSONAL",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ))
            : SizedBox.shrink(),
      );

  Future<void> doLogin() async {
    _formKey.currentState.save();

    var userData = UserLoginData(
        password: _formData.password, email: _formData.email, token_csrf: "");

    await context.read<LoginCubit>().login(userData);
  }
}
