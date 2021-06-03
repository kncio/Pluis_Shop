import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';
import 'package:pluis_hv_app/shopCart/shopCartRepository.dart';
import 'package:pluis_hv_app/shopCart/shopCartState.dart';

class ShopCartCubit extends Cubit<ShopCartState> {
  final ShopCartRepository repository;

  ShopCartCubit({this.repository}) : super(ShopCartInitialState());

  Future<void> getCupons(String productRowId) async {
    emit(ShopCartLoadingState());

    var eitherValue = await repository.getCuponsByUser(productRowId);

    eitherValue.fold(
        (errorFailure) => errorFailure.properties.isEmpty
            ? emit(ShopCartErrorState("Server unreachable"))
            : emit(ShopCartErrorState(errorFailure.properties.first)),
        (cupons) => cupons.length >= 0
            ? emit(ShopCartCuponsLoadedState(cupons: cupons))
            : emit(ShopCartErrorState("No hay cupones disponibles")));
  }

  Future<void> getClientAddress(String userId) async {
    emit(ShopCartLoadingState());

    var eitherValue = await repository.getClientAddress(userId);

    eitherValue.fold(
        (errorFailure) => errorFailure.properties.isEmpty
            ? emit(ShopCartErrorState("Server unreachable"))
            : emit(ShopCartErrorState(errorFailure.properties.first)),
        (address) => address.length >= 0
            ? emit(ShopCartAddressLoadedState(address: address))
            : emit(ShopCartErrorState("No hay direcciones disponibles")));
  }

  Future<void> getDeliveryPrice(String stateId) async {
    emit(ShopCartLoadingState());

    var eitherValue = await repository.getDeliveryPriceByMunicipeId(stateId);

    eitherValue.fold(
        (errorFailure) => errorFailure.properties.isEmpty
            ? emit(ShopCartErrorState("Server unreachable"))
            : emit(ShopCartErrorState(errorFailure.properties.first)),
        (price) => price != null
            ? emit(ShopCartDeliveryLoadedState(price: price))
            : emit(ShopCartErrorState("No hay precios disponibles")));
  }

  Future<void> getCurrency() async {
    emit(ShopCartLoadingState());
    var eitherValue = await repository.getCurrencys();

    eitherValue.fold(
        (errorFailure) => errorFailure.properties.isEmpty
            ? emit(ShopCartErrorState("Server unreachable"))
            : emit(ShopCartErrorState(errorFailure.properties.first)),
        (currencys) => currencys.length > 0
            ? emit(ShopCartCurrencyLoadedState(currencys: currencys))
            : emit(ShopCartErrorState("No hay precios disponibles")));
  }

  Future<void> setSuccess()async {
    emit(ShopCartSuccessState());
  }
}
