import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pluis_hv_app/addressBook/addressBookRepository.dart';
import 'package:pluis_hv_app/addressBook/addressBookState.dart';
import 'package:pluis_hv_app/register/registerDataModel.dart';
import 'package:pluis_hv_app/register/registerRepository.dart';
import 'package:pluis_hv_app/settings/settings.dart';

class AddressBookCubit extends Cubit<AddressBookState> {
  AddressBookRepository repository;
  RegisterRepository registerRepository;

  AddressBookCubit({this.repository,this.registerRepository}) : super(AddressBookInitialState());

  Future<void> isLogged() async {
    var logged = Settings.isLoggedIn;
    if (!logged) {
      emit(AddressBookNotLoggedState());
    } else {
      log((await Settings.userId));
      var userId = await Settings.userId;
      emit(AddressBookLoggedState(userId: userId));
    }
  }

  Future<void> getClientAddress(String userId) async {
    emit(AddressBookLoadingState());

    var eitherValue = await repository.getClientAddress(userId);

    eitherValue.fold(
        (errorFailure) => errorFailure.properties.isEmpty
            ? emit(AddressBookErrorState("Server unreachable"))
            : emit(AddressBookErrorState(errorFailure.properties.first)),
        (address) => address.length >= 0
            ? emit(AddressBookSuccessState(address: address))
            : emit(AddressBookErrorState("No hay direcciones disponibles")));
  }

  Future<List<Province>> getProvinces() async {
    var eitherValue = await registerRepository.getProvinces();

    List<Province> _result = [];

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(AddressBookErrorState("Server unreachable"))
            : emit(AddressBookErrorState(failure.properties.first)),
        (provinces) => provinces != null
            ? _result = provinces
            : emit(AddressBookErrorState("No hay provincias disponibles")));

    return _result;
  }

  Future<List<Municipe>> getMunicipeByProvinceId(String id) async {
    var eitherValue = await registerRepository.getMunicipes(id);

    List<Municipe> result = [];

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(AddressBookErrorState("Server unreachable"))
            : emit(AddressBookErrorState(failure.properties.first)),
        (municipes) => municipes != null
            ? result = municipes
            : emit(AddressBookErrorState("No hay provincias disponibles")));

    return result;
  }
  Future<bool> deleteAddress(String id) async {
    var eitherValue = await repository.deleteAddress(id);

    bool result = false;

    eitherValue.fold(
            (failure) => failure.properties.isEmpty
            ? emit(AddressBookErrorState("Server unreachable"))
            : emit(AddressBookErrorState(failure.properties.first)),
            (status) => status != null
            ? result = status
            : emit(AddressBookErrorState("No hay provincias disponibles")));

    return result;
  }

  Future<bool> createAddress(AddressForm addr) async {
    var eitherValue = await repository.createAddress(addr);

    bool result = false;

    eitherValue.fold(
            (failure) => failure.properties.isEmpty
            ? emit(AddressBookErrorState("Server unreachable"))
            : emit(AddressBookErrorState(failure.properties.first)),
            (status) => status != null
            ? result = status
            : emit(AddressBookErrorState("No hay provincias disponibles")));

    return result;
  }
}
