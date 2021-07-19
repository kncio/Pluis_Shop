import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:pluis_hv_app/pluisWidgets/orderDetailsWidget.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisButton.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisPdfViewer.dart';
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
  bool cancelingOrder = false;

  //Buys
  BuysBloc _buysBloc;

  //Bills Observable
  BillsBloc _billsBloc;

  //Update pasword form key
  final GlobalKey<FormState> _formEditPassKey = GlobalKey<FormState>();
  UpdatePasswordDataForm _updatePassFormData =
      UpdatePasswordDataForm("", "", "");

  //Update email key
  final GlobalKey<FormState> _formEditEmailKey = GlobalKey<FormState>();
  UpdateEmailDataForm _updateEmailDataForm = UpdateEmailDataForm("", "", "");

  //Subscription checkboxs
  bool man = false;
  bool woman = false;
  bool boy = false;
  bool girl = false;
  bool sms = false;
  bool email = false;

  //downloading
  bool downloading = false;
  bool finishDownload = false;

  //
  Timer updateList;
  Timer updateListIcon;
  bool reloading = false;
  int overScrollCounter = 0;

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
        log(state.message);
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
          this.cancelingOrder = false;
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
        context
            .read<LoginCubit>()
            .getUserBills(state.message)
            .then((list) => this._billsBloc.updateBills(list));
        context
            .read<LoginCubit>()
            .getSubscriptionData(state.message)
            .then((data) => {updateSubscriptionUi(data)});
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

  //region AccessData
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
                    onSaved: (email) {
                      this._updateEmailDataForm.newEmail = email;
                    },
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
                    onSaved: (email) {
                      this._updateEmailDataForm.reNewEmail = email;
                    },
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
                      changeEmail();
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                    onSaved: (newValue) =>
                        {this._updatePassFormData.currentPassword = newValue},
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    decoration: PluisAppTheme.textFormFieldDecoration(
                        labelText: "Contraseña Antigua",
                        hintText: "Contraseña Antigua"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo requerido';
                      }
                      if (this._updatePassFormData.reNewPassword != value) {
                        return 'Las contraseñas deben coincidir';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      this._updatePassFormData.newPassword = value;
                    },
                    onSaved: (newValue) {
                      this._updatePassFormData.newPassword = newValue;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo requerido';
                      }
                      if (this._updatePassFormData.newPassword != value) {
                        return 'Las contraseñas deben coincidir';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      this._updatePassFormData.reNewPassword = value;
                    },
                    onSaved: (newValue) {
                      this._updatePassFormData.reNewPassword = newValue;
                    },
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
                      changePassword();
                    },
                  ),
                )
              ],
            )),
      ],
    );
  }

  void changePassword() {
    if (this._formEditPassKey.currentState.validate()) {
      this._formEditPassKey.currentState.save();
      context
          .read<LoginCubit>()
          .postPassswordChange(this._updatePassFormData)
          .then((value) => showModalBtnSheet(
              value,
              "Contraseña cambiada con éxito",
              "Ha ocurrido un error, verifique los campos"));
    }
  }

  void changeEmail() {
    this._formEditEmailKey.currentState.save();
    context.read<LoginCubit>().postEmailChange(this._updateEmailDataForm).then(
        (value) => showModalBtnSheet(value, "Correo actualizado con éxito",
            "Ha ocurrido un error verifique los campos"));
  }

  Future showModalBtnSheet(bool value, String trueString, String falseString) {
    return showModalBottomSheet(
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
                      (value) ? trueString : falseString,
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
        });
  }

  //endregion

  //region Facturas
  Column buildBills() {
    return Column(
      children: [
        this.downloading ? LinearProgressIndicator() : SizedBox.shrink(),
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
                                Text('${snapshot.data[index].invoice_number}')
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 12),
                              child: Wrap(children: [
                                Text("LINK DE FACTURA: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SelectableText((snapshot.data[index].pdf)),
                              ])),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: DarkButton(
                                        text: "Descargar",
                                        action: () {
                                          var filename = snapshot
                                              .data[index].pdf
                                              .split('/');
                                          download(snapshot.data[index].pdf,
                                              filename[filename.length - 1]);
                                        }),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: DarkButton(
                                        text: "Visualizar",
                                        action: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return SafeArea(
                                                    top: false,
                                                    child: PluisPdfViewer(
                                                        url: snapshot
                                                            .data[index].pdf));
                                              });
                                        }),
                                  ),
                                ),
                              ]),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Divider()),
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

  Future<bool> download(String url, String filename) async {
    requestPermissions().then((ready) => {
          Settings.getAppExternalStorageBaseDirectory.then((directory) => {
                log('${directory.path}'),
                context
                    .read<LoginCubit>()
                    .downloadBill(
                        url,
                        directory.path + '/facturas' + '/' + filename,
                        onProgressCallback)
                    .then((value) => {
                          this.downloading = false,
                          if (value)
                            {showSnackbar(context, text: "Descarga Finalizada")}
                        })
              })
        });
  }

  Future<Map<Permission, PermissionStatus>> requestPermissions() async {
    Map<Permission, PermissionStatus> status = await Settings.requestPermission(
        permissionsToRequest: [Permission.storage]);
    if (status.entries.any((element) => element.value.isDenied))
      return await requestPermissions();
    return status;
  }

  void onProgressCallback(int prog, int total) {
    setState(() {
      this.downloading = true;
    });
  }

  //endregion

  //region Compras
  Column buildBuys() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
            child: RefreshIndicator(
              onRefresh: _refreshBuys,
              child: (!this.reloading)
                  ? StreamBuilder(
                      stream: this._buysBloc.bysObservable,
                      builder: (context,
                          AsyncSnapshot<List<PendingOrder>> snapshot) {
                        return ListView.builder(
                            itemCount: (snapshot.data != null)
                                ? snapshot.data.length
                                : 0,
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            '${snapshot.data[index].order_number}')
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 0, 12),
                                      child: Wrap(children: [
                                        Text("ESTADO DE PEDIDO: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        properIcon(snapshot, index),
                                        Text(statusToString(
                                            snapshot.data[index].status)),
                                        showCancelButton(snapshot.data[index])
                                      ])),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Divider())
                                ],
                              );
                            });
                      },
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _refreshBuys() async {
    setState(() {
      this.reloading = true;
    });
    context.read<LoginCubit>().getFinishedOrders(this.userId).then((list) => {
          this._buysBloc.reloadOrders(list),
          this.setState(() {
            this.reloading = false;
          })
        });
  }

  //endregion

  //region Subscriptions
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
                    log(this.sms.toString());
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
                    .postSubmissions(createSubscriptionDataFromCurrentState())
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

  //endregion

  //region Pedidos
  Widget buildPendingOrdersListView() {
    return Column(
      children: [
        (this.cancelingOrder)
            ? Padding(
                padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
                child: LinearProgressIndicator(
                    minHeight: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
              )
            : SizedBox.shrink(),
        Expanded(
          child: RefreshIndicator(
            displacement: 70.0,
            onRefresh: _reloadPendingOrders,
            child: (!this.reloading)
                ? StreamBuilder(
                    stream: this._pendingOrdersBloc.counterObservable,
                    builder:
                        (context, AsyncSnapshot<List<PendingOrder>> snapshot) {
                      return ListView.builder(
                          itemCount: (snapshot.data != null)
                              ? snapshot.data.length
                              : 0,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (_) {
                                      return OrderDetails(
                                          orderNumber: snapshot
                                              .data[index].order_number);
                                    });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                                    child: Wrap(
                                      children: [
                                        Text(
                                          "NÚMERO DE PEDIDO: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            '${snapshot.data[index].order_number}')
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 0, 12),
                                      child: Wrap(children: [
                                        Text("ESTADO DE PEDIDO: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        properIcon(snapshot, index),
                                        Text(statusToString(
                                            snapshot.data[index].status)),
                                        showCancelButton(snapshot.data[index])
                                      ])),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Divider())
                                ],
                              ),
                            );
                          });
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        )
      ],
    );
  }

  Future<void> _reloadPendingOrders() async {
    setState(() {
      this.reloading = true;
    });
    context.read<LoginCubit>().getPendingOrders(this.userId).then((list) => {
          this._pendingOrdersBloc.reloadOrders(list),
          this.setState(() {
            this.reloading = false;
          })
        });
  }

  Widget properIcon(AsyncSnapshot<List<PendingOrder>> snapshot, int index) {
    switch (snapshot.data[index].status) {
      case '5':
        return Icon(
          Icons.cancel_outlined,
          color: Colors.red,
          size: 14,
        );
      case '4':
        return FaIcon(
          FontAwesomeIcons.truckMoving,
          color: Colors.green,
          size: 14,
        );
      case '2':
        return FaIcon(
          FontAwesomeIcons.userMinus,
          color: Colors.red,
          size: 14,
        );
      case '3':
        return Icon(
          Icons.update_rounded,
          color: Colors.lightGreen,
          size: 14,
        );
      default:
        return Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 14,
        );
    }
  }

  Widget showCancelButton(PendingOrder order) {
    if (order.status == "0" || order.status == "3") {
      return PLuisButton(
        press: () {
          setState(() {
            this.cancelingOrder = true;
          });
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

  //endregion

  //region FormularioLogin
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

  //endregion

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

  void updateSubscriptionUi(SubscriptionsData data) {
    if (data.is_email_recibed == "1") {
      setState(() {
        this.email = true;
      });
    }
    if (data.is_sms_recibed == "1") {
      setState(() {
        this.sms = true;
      });
    }
    var splittedString = data.preference.split(',');
    splittedString.forEach((element) {
      if (element == "5") {
        setState(() {
          this.man = true;
        });
      } else if (element == "6") {
        setState(() {
          this.woman = true;
        });
      } else if (element == "7") {
        setState(() {
          this.boy = true;
        });
      } else if (element == "8") {
        setState(() {
          this.girl = true;
        });
      }
    });
  }

  SubscriptionsData createSubscriptionDataFromCurrentState() {
    var preferenceString = "";

    if (this.boy) {
      preferenceString += "7,";
    }
    if (this.man) {
      preferenceString += "5,";
    }
    if (this.woman) {
      preferenceString += "6,";
    }
    if (this.girl) {
      preferenceString += "8,";
    }
    var correctFormat =
        preferenceString.substring(0, preferenceString.length - 1);

    return SubscriptionsData(
        user_id: this.userId,
        preference: correctFormat,
        email: "",
        is_email_recibed: this.email ? "1" : "0",
        is_sms_recibed: this.sms ? "1" : "0");
  }

  Future<void> doLogin() async {
    _formKey.currentState.save();

    var userData = UserLoginData(
        password: _formData.password, email: _formData.email, token_csrf: "");

    await context.read<LoginCubit>().login(userData);
  }
}
