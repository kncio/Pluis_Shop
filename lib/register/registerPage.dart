
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
  String province = "La Habana";

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

  AppBar buildAppBar() =>
      AppBar(
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
                Expanded(child: buildForm(state))
              ],
            );
        }
      },
      listener: (context, state) async {
        if(state is RegisterSuccessState){
          Navigator.of(context).pushReplacementNamed(HOME_PAGE_ROUTE);
        }
        else if(state is RegisterErrorState){
          showSnackbar(context,text:state.message);
        }
      },
    );
  }

  Form buildForm(RegisterState state) {
    return Form(
        key: this._formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) =>
                {
                  formData.email = newValue
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration:
                PluisAppTheme.textFormFieldDecoration(hintText: "Correo"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) =>
                {
                  formData.password = newValue
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: this._hidePassword,
                decoration: PluisAppTheme.textFormFieldDecoration(
                    hintText: "Contraseña",
                    suffixIcon: IconButton(
                        icon: Icon(this._hidePassword
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye_rounded),
                        onPressed: () =>
                        {
                          this.setState(() {
                            this._hidePassword = !this._hidePassword;
                          })
                        })),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) =>
                {
                  formData.passwordConfirm = newValue
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: this._hideRePassword,
                decoration: PluisAppTheme.textFormFieldDecoration(
                    hintText: "Verificar Contraseña",
                    suffixIcon: IconButton(
                        icon: Icon(this._hideRePassword
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye_rounded),
                        onPressed: () =>
                        {
                          this.setState(() {
                            this._hideRePassword = !this._hideRePassword;
                          })
                        })),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) =>
                {
                  formData.firstName = newValue
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration:
                PluisAppTheme.textFormFieldDecoration(hintText: "Nombre"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) =>
                {
                  formData.lastName = newValue
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: PluisAppTheme.textFormFieldDecoration(
                    hintText: "Apellidos"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) =>
                {
                  formData.phone = newValue
                },
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration:
                PluisAppTheme.textFormFieldDecoration(hintText: "Teléfono"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                onSaved: (newValue) =>
                {
                  formData.addressLines = newValue
                },
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
                  hint: Text("La Habana"),
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
                      formData.province = 3;
                    });
                  },
                  items: (state as RegisterInitialState).provinces.map<DropdownMenuItem<String>>((Province value) {
                    return DropdownMenuItem<String>(
                      value: value.province,
                      child: Text(value.province),
                    );
                  }).toList(),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(20,40,20,40),
              child: DarkButton(
                text: "REGISTRARSE",
                action: () =>
                {
                   doRegister(context, formData)
                },
              ),
            )
          ],
        ));
  }

  Future<void> doRegister(BuildContext context,
      RegisterDataForm dataForm) async {

    _formKey.currentState.save();

    var data = RegisterData(
      email: dataForm.email,
      password: dataForm.password,
      passwordConfirm: dataForm.passwordConfirm,
      firstName: dataForm.firstName,
      lastName: dataForm.lastName,
      phone: dataForm.phone,
      privacyCheck: true,
      province: dataForm.province,
      addressLines: dataForm.addressLines,
      addressLines_1: dataForm.addressLines,
      isCompany: false,
      activation: "phone_act"
    );
    await context.read<RegisterCubit>().register(data);
  }
}
