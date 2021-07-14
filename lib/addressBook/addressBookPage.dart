import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/addressBook/addressBookCubit.dart';
import 'package:pluis_hv_app/addressBook/addressBookState.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/pluisWidgets/homeBottomBar.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage();

  @override
  _AddressBookPage createState() {
    return _AddressBookPage();
  }
}

class _AddressBookPage extends State<AddressBookPage> {
  @override
  void initState() {
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
          return ((state as AddressBookSuccessState).address.length > 0)
              ? ListView(
                  children: List<Widget>.from(
                  (state as AddressBookSuccessState)
                      .address
                      .map((address) => Padding(
                            padding: EdgeInsets.all(20),
                            child: buildListTileWidget(address),
                          )),
                ))
              : Center(
                  child: Text("Usted solo contiene la dirección de registro...",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                );
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

  Widget buildListTileWidget(ClientAddress e) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Text('${e.name}  ${e.lastName}'.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
          child: Text('${e.address}'.toUpperCase())),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
          child: Text('${e.address_number}'.toUpperCase())),
      Wrap(children: [
        Text('TELÉFONO:   '),
        Text('${e.phone_number}'),
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
}
