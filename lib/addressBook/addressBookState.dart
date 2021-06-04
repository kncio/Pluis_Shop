

import 'package:equatable/equatable.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

abstract class AddressBookState extends Equatable{
  const AddressBookState();

  @override
  List<Object> get props => [];
}

class AddressBookInitialState extends AddressBookState{

}


class AddressBookSuccessState extends AddressBookState{
  final List<ClientAddress> address;

  AddressBookSuccessState({this.address});
}


class AddressBookErrorState extends AddressBookState{
  final String message;

  AddressBookErrorState(this.message);
}

class AddressBookNotLoggedState extends AddressBookState{

}
class AddressBookLoadingState extends AddressBookState{

}