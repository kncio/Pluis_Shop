import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/snackBar.dart';
import 'package:pluis_hv_app/register/activationCode.dart';
import 'package:pluis_hv_app/register/registerCubit.dart';
import 'package:pluis_hv_app/register/registerDataModel.dart';
import 'package:pluis_hv_app/register/registerState.dart';
import 'package:pluis_hv_app/settings/settings.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPage createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegisterDataForm formData = RegisterDataForm();
  bool _hidePassword = true;
  bool _hideRePassword = true;
  Province selectedProvince;
  Municipe selectedMunicipe;
  List<Municipe> municipes;
  List<Province> provinces = [];

  //true, sms activation, on false, email
  bool _smsXOREmailActivation = true;

  //phone
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  @override
  void initState() {
    context.read<RegisterCubit>().getProvinces();
    super.initState();
  }

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
      );

  BlocConsumer<RegisterCubit, RegisterState> buildBody() {
    return BlocConsumer<RegisterCubit, RegisterState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case RegisterLoadingState:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("REGISTRARSE",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                LinearProgressIndicator(
                    minHeight: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                Expanded(child: buildForm(state))
              ],
            );
          case RegisterInitialState:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("REGISTRARSE",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Expanded(child: buildForm(state))
              ],
            );
          case RegisterErrorState:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("REGISTRARSE",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Spacer(flex: 2),
                Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                ),
                Spacer(),
                Center(
                  child: Text("No hay conexi??n a Internet ...",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(64, 16, 64, 0),
                  child: Center(
                    child: DarkButton(
                        text: "Reintentar",
                        action: () {
                          context.read<RegisterCubit>().getProvinces();
                        }),
                  ),
                ),
                Spacer(flex: 5)
              ],
            );
          default:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("REGISTRARSE",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                )
              ],
            );
        }
      },
      listener: (context, state) async {
        if (state is RegisterSuccessState) {
          if (!state.message.contains("field_errors")) {
            buildShowDialog(context);
          } else {
            log(state.message);
            buildShowDialogError(context);
          }
        } else if (state is RegisterErrorState) {
          log(state.message);
        } else if (state is RegisterInitialState) {
          this.provinces = state.provinces;
          this.selectedProvince = state.provinces[0];
          await context
              .read<RegisterCubit>()
              .getMunicipeByProvinceId(this.selectedProvince.id);
        }
      },
    );
  }

  Future buildShowDialogError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text("Imposible Registrar"),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Su direcci??n de correo o tel??fono ya est??n en uso ..."),
                  // Text('Verifique que contiene un lector de .docxs'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Entendido'),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HOME_PAGE_ROUTE, ModalRoute.withName("/"));
                },
              )
            ],
          );
        },
        barrierDismissible: false);
  }

  Future buildShowDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false, // must click btn
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: const Text(
                "Registro satisfactorio",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'Se le env??ara un c??digo mediante sms para validar el registro'),
                  // Text('Verifique que contiene un lector de .docxs'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Entendido'),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      ACTIVATION_CODE_PAGE, ModalRoute.withName("/home"),
                      arguments: ActivationPageArgs(
                          phone: this.formData.phone,
                          email: this.formData.email,
                          pass: this.formData.password));
                },
              )
            ],
          );
        });
  }

  Form buildForm(RegisterState state) {
    return Form(
        key: this._formKey,
        child: SingleChildScrollView(
            child: Column(
          children: [
            buildEmailField(),
            buildPasswordField(),
            buildRePasswordField(),
            buildNameField(),
            buildLastNameField(),
            buildPhoneField(),
            buildAddressField(),
            buildProvinceSelector(state),
            buildMunicipeSelector(state),
            buildCheckboxPrivacy(),
            phoneOrEmailAct(),
            buildRegisterButton(),
          ],
        )));
  }

  Padding buildMunicipeSelector(RegisterState state) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: DropdownButton(
          isExpanded: true,
          hint: Text("Municipio"),
          value: this.selectedMunicipe,
          // icon: Icon(Icons.arrow_downward),
          style: TextStyle(color: Colors.black54),
          underline: Container(
            height: 1,
            color: Colors.black54,
          ),
          onChanged: (Municipe newMunicipe) {
            this.setState(() {
              this.selectedMunicipe = newMunicipe;
              this.formData.municipe = newMunicipe.id;
              log("municipe selected-> :" + this.formData.municipe);
            });
          },
          items:
              this.municipes?.map<DropdownMenuItem<Municipe>>((Municipe value) {
                    return DropdownMenuItem<Municipe>(
                      value: value,
                      child: Text(value.name),
                    );
                  })?.toList() ??
                  <DropdownMenuItem<Municipe>>[],
        ));
  }

  Widget phoneOrEmailAct() {
    return Wrap(
      children: [
        CheckboxListTile(
            activeColor: Colors.black,
            title: Text("Activar por SMS"),
            value: this._smsXOREmailActivation,
            onChanged: (value) {
              setState(() {
                this._smsXOREmailActivation = value;
                log(this._smsXOREmailActivation.toString());
              });
            }),
        CheckboxListTile(
            activeColor: Colors.black,
            title: Text("Activar por EMAIL"),
            value: !this._smsXOREmailActivation,
            onChanged: (value) {
              setState(() {
                this._smsXOREmailActivation = !value;
                log(this._smsXOREmailActivation.toString());
              });
            })
      ],
    );
  }

  CheckboxListTile buildCheckboxPrivacy() {
    return CheckboxListTile(
        activeColor: Colors.black,
        title: Text("Acepto la pol??tica de privacidad"),
        value: formData.privacyCheck,
        onChanged: (value) {
          setState(() {
            formData.privacyCheck = value;
          });
        });
  }

  Padding buildRegisterButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: DarkButton(
        text: "REGISTRARSE",
        action: () => doRegister(context),
      ),
    );
  }

  Padding buildProvinceSelector(RegisterState state) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: DropdownButton(
          isExpanded: true,
          hint: Text("La Habana"),
          value: this.selectedProvince,
          // icon: Icon(Icons.arrow_downward),
          style: TextStyle(color: Colors.black54),
          underline: Container(
            height: 1,
            color: Colors.black54,
          ),
          onChanged: (Province newProvince) {
            this.setState(() {
              selectedProvince = newProvince;
              formData.province = int.parse(newProvince.id);
              getMunicipes();
            });
          },
          items:
              this.provinces.map<DropdownMenuItem<Province>>((Province value) {
            return DropdownMenuItem<Province>(
              value: value,
              child: Text(value.province),
            );
          }).toList(),
        ));
  }

  Padding buildAddressField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
        onSaved: (newValue) => {formData.addressLines = newValue.trim()},
        onChanged: (newValue) => {formData.addressLines = newValue.trim()},
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.next,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Direcci??n", hintText: "Direcci??n"),
      ),
    );
  }

  Padding buildPhoneField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
        onSaved: (newValue) => {formData.phone = newValue.trim()},
        onChanged: (newValue) => {formData.phone = newValue.trim()},
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Tel??fono", hintText: "Tel??fono"),
      ),
    );
  }

  Padding buildLastNameField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
        onSaved: (newValue) => {formData.lastName = newValue.trim()},
        onChanged: (newValue) => {formData.lastName = newValue.trim()},
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Apellidos", hintText: "Apellidos"),
      ),
    );
  }

  Padding buildNameField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
        onSaved: (newValue) => {formData.firstName = newValue.trim()},
        onChanged: (newValue) => {formData.firstName = newValue.trim()},
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Nombre", hintText: "Nombre"),
      ),
    );
  }

  Padding buildRePasswordField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          } else if (value.length < 6) {
            return 'La contrase??a debe exceder de 6 caracteres';
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onSaved: (newValue) => {formData.passwordConfirm = newValue.trim()},
        onChanged: (newValue) => {formData.passwordConfirm = newValue.trim()},
        keyboardType: TextInputType.visiblePassword,
        obscureText: this._hideRePassword,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Verificar Contrase??a",
            hintText: "Verificar Contrase??a",
            suffixIcon: IconButton(
                icon: Icon(this._hideRePassword
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye_rounded),
                onPressed: () => {
                      this.setState(() {
                        this._hideRePassword = !this._hideRePassword;
                      })
                    })),
      ),
    );
  }

  Padding buildPasswordField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          } else if (value.length < 6) {
            return 'La contrase??a debe exceder de 6 caracteres';
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onSaved: (newValue) => {formData.password = newValue.trim()},
        onChanged: (newValue) => {formData.password = newValue.trim()},
        keyboardType: TextInputType.visiblePassword,
        obscureText: this._hidePassword,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Contrase??a",
            hintText: "Contrase??a",
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
    );
  }

  Padding buildEmailField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        onSaved: (newValue) => {formData.email = newValue.trim()},
        onChanged: (newValue) => {formData.email = newValue.trim()},
        keyboardType: TextInputType.emailAddress,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Correo", hintText: "Correo"),
      ),
    );
  }

  Future<void> doRegister(BuildContext context) async {
    _formKey.currentState.save();
    this.phone = this.formData.phone;
    if (this.formData.privacyCheck && _formKey.currentState.validate()) {
      var data = RegisterData(
          email: this.formData.email,
          password: this.formData.password,
          passwordConfirm: this.formData.passwordConfirm,
          firstName: this.formData.firstName,
          lastName: this.formData.lastName,
          phone: this.formData.phone,
          privacyCheck: this.formData.privacyCheck,
          province: this.formData.province,
          municipe: this.formData.municipe,
          addressLines: this.formData.addressLines,
          addressLines_1: this.formData.addressLines,
          isCompany: false,
          activation: (_smsXOREmailActivation) ? "phone_act" : "email_act");
      await context.read<RegisterCubit>().register(data);
    } else {
      showSnackbar(context, text: "Debes aceptar las pol??ticas de privacidad");
    }
  }

  Future<void> getMunicipes() async {
    log("Municipes");
    await context
        .read<RegisterCubit>()
        .getMunicipeByProvinceId(this.selectedProvince.id)
        .then((value) {
      this.setState(() {
        this.municipes = value;
        log(value.length.toString());
        this.selectedMunicipe = this.municipes[0];
      });
    });
  }
}
