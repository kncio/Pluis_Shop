import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/loginPage/loginCubit.dart';
import 'package:pluis_hv_app/loginPage/loginLocalDataSource.dart';
import 'package:pluis_hv_app/loginPage/loginStates.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/snackBar.dart';
import 'package:pluis_hv_app/settings/settings.dart';

import 'loginRepository.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  LoginDataForm _formData = LoginDataForm();

  @override
  void initState() {
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
        await showSnackbar(context, text: state.message,timeLimit: 5);
      }
      else if(state is LoginSuccessfulState){
        var token = await Settings.storedToken;
        log("Secured : ${token}");
        Navigator.of(context).pushNamedAndRemoveUntil(HOME_PAGE_ROUTE,ModalRoute.withName("/"));
      }
    }, builder: (context, state) {
      switch (state.runtimeType) {
        case LoginSendingState:
          return Column(
            children: [
              LinearProgressIndicator(
                  minHeight: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
              Expanded(child: buildForm()),
              buildDarkButton(),
              buildRegisterText(context),
            ],
          );
        default:
          return Column(
            children: [
              Expanded(child: buildForm()),
              buildDarkButton(),
              buildRegisterText(context),
            ],
          );
      }

      return Column(
        children: [
          Expanded(child: buildForm()),
          buildDarkButton(),
          buildRegisterText(context),
        ],
      );
    });
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
      );

  Future<void> doLogin() async {
    _formKey.currentState.save();

    var userData = UserLoginData(
        password: _formData.password, email: _formData.email, token_csrf: "");

    await context.bloc<LoginCubit>().login(userData);

    log("Awaited test http ");
  }
}
