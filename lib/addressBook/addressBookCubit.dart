import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pluis_hv_app/addressBook/addressBookRepository.dart';
import 'package:pluis_hv_app/addressBook/addressBookState.dart';
import 'package:pluis_hv_app/settings/settings.dart';

class AddressBookCubit extends Cubit<AddressBookState> {
  AddressBookRepository repository;

  AddressBookCubit({this.repository}) : super(AddressBookInitialState());

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
}
