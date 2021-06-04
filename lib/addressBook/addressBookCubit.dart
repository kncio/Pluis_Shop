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
      emit(AddressBookLoadingState());
    }
  }
}
