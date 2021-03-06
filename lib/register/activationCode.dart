import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/loginPage/loginLocalDataSource.dart';
import 'package:pluis_hv_app/loginPage/loginRepository.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/snackBar.dart';
import 'package:pluis_hv_app/register/registerCubit.dart';
import 'package:pluis_hv_app/register/registerRepository.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

class ActivateCodePage extends StatefulWidget {
  final ActivationPageArgs phone;

  const ActivateCodePage({Key key, this.phone}) : super(key: key);

  @override
  _ActivateCodePage createState() {
    log(this.phone.phone);
    return _ActivateCodePage(
        phone: this.phone.phone,
        email: this.phone.email,
        pass: this.phone.pass);
  }
}

class _ActivateCodePage extends State<ActivateCodePage> {
  final String phone;
  final String pass;
  final String email;

  _ActivateCodePage({
    this.phone,
    this.pass,
    this.email,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterRepository _repository = injectorContainer.sl<RegisterRepository>();
  LoginRepository _loginRepository = injectorContainer.sl<LoginRepository>();

  String _code = '';

  @override
  void initState() {
    log(phone.toString() + " " + email.toString() + " " + pass.toString());
    if (this.pass != null && this.email != null) {
      UserLoginData data =
          UserLoginData(email: this.email, password: this.pass);
      this._loginRepository.login(data);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Introduzca el código de activación recibido",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: Form(
                key: this._formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 6) {
                              return 'El código debe tener 6 dígitos ';
                            }
                            return null;
                          },
                          onSaved: (newValue) => {
                            this.setState(() {
                              this._code = newValue;
                            })
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: PluisAppTheme.textFormFieldDecoration(
                              labelText: "Código", hintText: "******"),
                        ),
                      ),
                      SizedBox(
                        height: 75,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: DarkButton(
                          text: "Activar",
                          action: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              this
                                  ._repository
                                  .activateCode(this._code, this.phone)
                                  .then((value) => {
                                        value.fold(
                                            (failure) => null,
                                            (status) => status
                                                ? buildShowDialog(context)
                                                : showSnackbar(context,
                                                    text: "Código inválido."))
                                      });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: DarkButton(
                          text: "Reenviar Código",
                          action: () {
                            _repository.sendCode().then((value) => {
                                  value.fold(
                                      (failure) => null,
                                      (status) => status
                                          ? showSnackbar(context,
                                              text: "Código Reenviado.")
                                          : showSnackbar(context,
                                              text:
                                                  "Correo o Teléfono inválido."))
                                });
                          },
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Future buildShowDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Cuenta Activada con Exito!",
                style: PluisAppTheme.themeDataLight.textTheme.headline1),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HOME_PAGE_ROUTE, ModalRoute.withName("/"));
                  },
                  child: Text("Entendido"))
            ],
          );
        });
  }

  AppBar buildAppBar() => AppBar(
        centerTitle: true,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Text(
          "Activar".toUpperCase(),
          style: PluisAppTheme.themeDataLight.textTheme.headline1,
        ),
      );
}

class ActivationPageArgs {
  final String phone;
  final String email;
  final String pass;

  ActivationPageArgs({this.phone, this.email, this.pass});
}
