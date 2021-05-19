import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/snackBar.dart';
import 'package:pluis_hv_app/register/registerCubit.dart';
import 'package:pluis_hv_app/register/registerDataModel.dart';
import 'package:pluis_hv_app/register/registerState.dart';

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
          showSnackbar(context, text: "Registro Satisfactorio");
          Navigator.of(context).pushReplacementNamed(HOME_PAGE_ROUTE);
        } else if (state is RegisterErrorState) {
          showSnackbar(context, text: state.message);
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

  Form buildForm(RegisterState state) {
    return Form(
        key: this._formKey,
        child: ListView(
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
            buildRegisterButton()
          ],
        ));
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
            setState(() {
              selectedMunicipe = newMunicipe;
              formData.municipe = newMunicipe.id;
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

  CheckboxListTile buildCheckboxPrivacy() {
    return CheckboxListTile(
        activeColor: Colors.black,
        title: Text("Acepto la política de privacidad"),
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
            setState(() {
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
        onSaved: (newValue) => {formData.addressLines = newValue.trim()},
        onChanged: (newValue) => {formData.addressLines = newValue.trim()},
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.next,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Dirección", hintText: "Dirección"),
      ),
    );
  }

  Padding buildPhoneField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        onSaved: (newValue) => {formData.phone = newValue.trim()},
        onChanged: (newValue) => {formData.phone = newValue.trim()},
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Teléfono", hintText: "Teléfono"),
      ),
    );
  }

  Padding buildLastNameField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
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
        textInputAction: TextInputAction.next,
        onSaved: (newValue) => {formData.passwordConfirm = newValue.trim()},
        onChanged: (newValue) => {formData.passwordConfirm = newValue.trim()},
        keyboardType: TextInputType.visiblePassword,
        obscureText: this._hideRePassword,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Verificar Contraseña",
            hintText: "Verificar Contraseña",
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
        textInputAction: TextInputAction.next,
        onSaved: (newValue) => {formData.password = newValue.trim()},
        onChanged: (newValue) => {formData.password = newValue.trim()},
        keyboardType: TextInputType.visiblePassword,
        obscureText: this._hidePassword,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Contraseña",
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
    );
  }

  Padding buildEmailField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        onSaved: (newValue) => {formData.email = newValue.trim()},
        onChanged: (newValue) => {formData.email = newValue.trim()},
        keyboardType: TextInputType.emailAddress,
        decoration: PluisAppTheme.textFormFieldDecoration(
            labelText: "Correo", hintText: "Correo"),
      ),
    );
  }

  Future<void> doRegister(
      BuildContext context) async {
    _formKey.currentState.save();

    if (this.formData.privacyCheck) {
      var data = RegisterData(
          email: this.formData.email,
          password: this.formData.password,
          passwordConfirm: this.formData.passwordConfirm,
          firstName: this.formData.firstName,
          lastName: this.formData.lastName,
          phone: this.formData.phone,
          privacyCheck: this.formData.privacyCheck,
          province: this.formData.province,
          addressLines: this.formData.addressLines,
          addressLines_1: this.formData.addressLines,
          isCompany: false,
          activation: "phone_act");
      log(data.toMap().toString());
      await context.read<RegisterCubit>().register(data);
    } else {
      //TODO: shoe error card
    }
  }

  Future<void> getMunicipes() async {
    log("Municipes");
    await context
        .read<RegisterCubit>()
        .getMunicipeByProvinceId(this.selectedProvince.id)
        .then((value) {
      setState(() {
        this.municipes = value;
        log(value.length.toString());
        this.selectedMunicipe = this.municipes[0];
      });
    });
  }
  
}
