import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/register/registerCubit.dart';
import 'package:pluis_hv_app/register/registerState.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPage createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  String province = "Provincia";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
        ),
      );

  BlocConsumer<RegisterCubit, RegisterState> buildBody() {
    return BlocConsumer<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("REGISTRARSE",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Expanded(child: buildForm())
          ],
        );
      },
      listener: (context, state) async {},
    );
  }

  Form buildForm() {
    return Form(
        key: this._formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) => {},
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration:
                    PluisAppTheme.textFormFieldDecoration(hintText: "Correo"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) => {},
                keyboardType: TextInputType.visiblePassword,
                obscureText: this._hidePassword,
                decoration: PluisAppTheme.textFormFieldDecoration(
                    hintText: "Contraseña",
                    suffixIcon: IconButton(
                        icon: Icon(this._hidePassword
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye_rounded),
                        onPressed: () => {
                              this.setState(() {
                                this._hidePassword = !this._hidePassword;
                              })
                            })),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) => {},
                keyboardType: TextInputType.visiblePassword,
                obscureText: this._hidePassword,
                decoration: PluisAppTheme.textFormFieldDecoration(
                    hintText: "Verificar Contraseña",
                    suffixIcon: IconButton(
                        icon: Icon(this._hidePassword
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye_rounded),
                        onPressed: () => {
                              this.setState(() {
                                this._hidePassword = !this._hidePassword;
                              })
                            })),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) => {},
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration:
                    PluisAppTheme.textFormFieldDecoration(hintText: "Nombre"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) => {},
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: PluisAppTheme.textFormFieldDecoration(
                    hintText: "Apellidos"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) => {},
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration:
                    PluisAppTheme.textFormFieldDecoration(hintText: "Teléfono"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) => {},
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                decoration: PluisAppTheme.textFormFieldDecoration(
                    hintText: "Dirección"),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: DropdownButton(
                  isExpanded: true,
                  hint: Text("Provincia"),
                  value: this.province,
                  // icon: Icon(Icons.arrow_downward),
                  style: TextStyle(color: Colors.black54),
                  underline: Container(
                    height: 1,
                    color: Colors.black54,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      this.province = newValue;
                    });
                  },
                  items: <String>[
                    'Provincia',
                    'One',
                    'Two',
                    'Free',
                    'Four',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
            Padding(
              padding: EdgeInsets.all(20),
              child: DarkButton(
                text: "REGISTRARSE",
                action: () => {log('registrarse')},
              ),
            )
          ],
        ));
  }
}
