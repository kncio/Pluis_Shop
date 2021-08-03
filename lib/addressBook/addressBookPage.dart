import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/addressBook/addressBookCubit.dart';
import 'package:pluis_hv_app/addressBook/addressBookRepository.dart';
import 'package:pluis_hv_app/addressBook/addressBookState.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/observables/aviableSizesObservable.dart';
import 'package:pluis_hv_app/observables/municipesObservable.dart';
import 'package:pluis_hv_app/pluisWidgets/DarkButton.dart';
import 'package:pluis_hv_app/pluisWidgets/homeBottomBar.dart';
import 'package:pluis_hv_app/pluisWidgets/snackBar.dart';
import 'package:pluis_hv_app/register/registerDataModel.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage();

  @override
  _AddressBookPage createState() {
    return _AddressBookPage();
  }
}

class _AddressBookPage extends State<AddressBookPage>
    with SingleTickerProviderStateMixin {
  bool deleting = false;
  TabController _tabController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddressForm addressForm = AddressForm();

  Province _selectedProvince;
  Municipe _selectedMunicipe;
  AviableMunicipesBloc _municipesBloc =
      AviableMunicipesBloc(aviableMunicipes: []);
  Stream _provinces;

  @override
  void initState() {
    _provinces = context.read<AddressBookCubit>().getProvinces().asStream();

    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    context.read<AddressBookCubit>().isLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: buildBlocConsumer(),
        bottomNavigationBar: buildBottomNavigationBar());
  }

  BlocConsumer<Cubit, dynamic> buildBlocConsumer() {
    return BlocConsumer<AddressBookCubit, AddressBookState>(
        builder: (context, state) {
      switch (state.runtimeType) {
        case AddressBookNotLoggedState:
          return Column(children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                    child: Text(
                        "Necesitas tener la sesión activa para acceder a la lista de direcciones",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
              ),
            ),
          ]);
        case AddressBookSuccessState:
          return TabBarView(controller: _tabController, children: [
            ((state as AddressBookSuccessState).address.length > 0)
                ? ListView(
                    children: List<Widget>.from(
                    (state as AddressBookSuccessState)
                        .address
                        .map((address) => Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: buildListTileWidget(address),
                            )),
                  ))
                : Center(
                    child: Text("Usted solo contiene la dirección de registro.",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
            buildCreateForm()
          ]);
        default:
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
          );
      }
    }, listener: (context, state) async {
      if (state is AddressBookLoggedState) {
        context.read<AddressBookCubit>().getClientAddress(state.userId);
      }
    });
  }

  SingleChildScrollView buildCreateForm() {
    return SingleChildScrollView(
        child: Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
              onSaved: (newValue) => {this.addressForm.name = newValue},
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: PluisAppTheme.textFormFieldDecoration(
                  labelText: "Nombre", hintText: "Introduzca el nombre"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
              onSaved: (newValue) => {this.addressForm.last_name = newValue},
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: PluisAppTheme.textFormFieldDecoration(
                  labelText: "Apellidos", hintText: "Apellidos"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
              onSaved: (newValue) => {this.addressForm.phone_number = newValue},
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: PluisAppTheme.textFormFieldDecoration(
                  labelText: "Teléfono", hintText: "Introduzca el Teléfono"),
            ),
          ),
          buildProvinceSelector(),
          buildMunicipeSelector(),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
              onSaved: (newValue) => {this.addressForm.address = newValue},
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.next,
              decoration: PluisAppTheme.textFormFieldDecoration(
                  labelText: "Dirección", hintText: "Introduzca la Dirección"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
              onSaved: (newValue) =>
                  {this.addressForm.address_number = newValue},
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.next,
              decoration: PluisAppTheme.textFormFieldDecoration(
                  labelText: "Dirección Detalles", hintText: "Detalles"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: DarkButton(
              action: () {
                sumbit();
              },
              text: "AÑADIR",
            ),
          )
        ],
      ),
    ));
  }

  void sumbit() {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      context
          .read<AddressBookCubit>()
          .createAddress(addressForm)
          .then((status) => {
                if (status)
                  {
                    showSnackbar(context, text: "Dirección creada con éxito"),
                    this.initState(),
                  }
                else
                  {showSnackbar(context, text: "Ha ocurrido un error")}
              });
    }
  }

  Widget buildProvinceSelector() {
    return StreamBuilder<List<Province>>(
        stream: this._provinces,
        builder: (context, snapshot) {
          return Padding(
              padding: EdgeInsets.all(20),
              child: DropdownButton(
                isExpanded: true,
                hint: Text("Provincia"),
                value: this._selectedProvince,
                // icon: Icon(Icons.arrow_downward),
                style: TextStyle(color: Colors.black54),
                underline: Container(
                  height: 1,
                  color: Colors.black54,
                ),
                onChanged: (Province newProvince) {
                  this.setState(() {
                    _selectedProvince = newProvince;
                    this.addressForm.state_id = newProvince.id;
                    getMunicipes();
                  });
                },
                items: snapshot.data
                        ?.map<DropdownMenuItem<Province>>((Province value) {
                      return DropdownMenuItem<Province>(
                        value: value,
                        child: Text(value.province),
                      );
                    })?.toList() ??
                    <DropdownMenuItem<Province>>[],
              ));
        });
  }

  Widget buildMunicipeSelector() {
    return StreamBuilder<List<Municipe>>(
        stream: this._municipesBloc.sizesObservable,
        builder: (context, snapshot) {
          return Padding(
              padding: EdgeInsets.all(20),
              child: DropdownButton(
                isExpanded: true,
                hint: Text("Municipio"),
                value: this._selectedMunicipe,
                // icon: Icon(Icons.arrow_downward),
                style: TextStyle(color: Colors.black54),
                underline: Container(
                  height: 1,
                  color: Colors.black54,
                ),
                onChanged: (Municipe newMunicipe) {
                  this.setState(() {
                    this._selectedMunicipe = newMunicipe;
                    this.addressForm.city_id = newMunicipe.id;
                    // log("municipe selected-> :" + this.formData.municipe);
                  });
                },
                items: snapshot.data
                        ?.map<DropdownMenuItem<Municipe>>((Municipe value) {
                      return DropdownMenuItem<Municipe>(
                        value: value,
                        child: Text(value.name),
                      );
                    })?.toList() ??
                    <DropdownMenuItem<Municipe>>[],
              ));
        });
  }

  Widget buildListTileWidget(ClientAddress e) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Wrap(children: [
            Text('NOMBRE:   '),
            Text('${e.name}  ${e.lastName}'.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black45)),
          ]),
          Spacer(),
          (this.deleting
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    context
                        .read<AddressBookCubit>()
                        .deleteAddress(e.id)
                        .then((value) => {
                              if (value)
                                {
                                  showSnackbar(context,
                                      text: "Dirección eliminada"),
                                  context.read<AddressBookCubit>().isLogged()
                                }
                            });
                  })
              : SizedBox.shrink())
        ],
      ),
      Wrap(children: [
        Text('DIRECCIÓN:   '),
        Text('${e.address}'.toUpperCase(),
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black45)),
      ]),
      Wrap(children: [
        Text('DETALLES:   '),
        Text('${e.address_number}'.toUpperCase(),
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black45)),
      ]),
      Wrap(children: [
        Text('TELÉFONO:   '),
        Text('${e.phone_number}',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black45)),
      ]),
      Divider(
        color: Colors.black26,
      )
    ]);
  }

  AppBar buildAppBar() => AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: Icon(Icons.clear_outlined),
          color: Colors.black,
        ),
        title: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text("LIBRETA DE DIRECCIONES",
                style: TextStyle(color: Colors.black))),
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete,
                color: (this.deleting) ? Colors.black12 : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  this.deleting = !this.deleting;
                });
              })
        ],
        bottom: TabBar(
          labelPadding: EdgeInsets.all(0),
          indicatorColor: Colors.black,
          controller: this._tabController,
          tabs: [
            Text(
              "Direcciones",
              style: PluisAppTheme.themeDataLight.textTheme.headline1,
            ),
            Text(
              "Añadir",
              style: PluisAppTheme.themeDataLight.textTheme.headline1,
            )
          ],
          indicatorSize: TabBarIndicatorSize.label,
        ),
      );

  BottomBar buildBottomNavigationBar() {
    return BottomBar(
      onPressSearch: () => Navigator.of(context)
          .pushNamedAndRemoveUntil(HOME_PAGE_ROUTE, ModalRoute.withName('/')),
      onPressShopBag: () => Navigator.of(context).pushNamed(SHOP_CART),
      onPressAccount: () => Navigator.of(context).pushNamed(LOGIN_PAGE_ROUTE),
      onPressMenu: () => Navigator.of(context).pushNamed(MENU_PAGE),
    );
  }

  Future<void> getMunicipes() async {
    await context
        .read<AddressBookCubit>()
        .getMunicipeByProvinceId(this._selectedProvince.id)
        .then((value) {
      this.setState(() {
        this._municipesBloc.updateMunicipes(value);
        log(value.length.toString());
        this._selectedMunicipe = value[0];
      });
    });
  }
}
