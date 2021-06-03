import 'package:equatable/equatable.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

abstract class ShopCartState extends Equatable {
  const ShopCartState();

  @override
  List<Object> get props => [];
}

class ShopCartInitialState extends ShopCartState {}

class ShopCartLoadingState extends ShopCartState {}

class ShopCartCuponsLoadedState extends ShopCartState {
  final List<Cupon> cupons;

  ShopCartCuponsLoadedState({this.cupons});
}

class ShopCartAddressLoadedState extends ShopCartState {
  final List<ClientAddress> address;

  ShopCartAddressLoadedState({this.address});
}

class ShopCartDeliveryLoadedState extends ShopCartState {
  final DeliveryPrice price;

  ShopCartDeliveryLoadedState({this.price});
}

class ShopCartCurrencyLoadedState extends ShopCartState {
  final List<SiteCurrency> currencys;

  ShopCartCurrencyLoadedState({this.currencys});
}

class ShopCartSuccessState extends ShopCartState {
  //TODO: info
}

class ShopCartErrorState extends ShopCartState {
  final String message;

  ShopCartErrorState(this.message);
}
