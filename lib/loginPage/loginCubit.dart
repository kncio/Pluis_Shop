import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/loginPage/loginLocalDataSource.dart';
import 'package:pluis_hv_app/loginPage/loginRemoteDatasource.dart';
import 'package:pluis_hv_app/loginPage/loginRepository.dart';
import 'package:pluis_hv_app/loginPage/loginStates.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

class LoginCubit extends Cubit<LoginState> {


  LoginRepository repository;

  LoginCubit({this.repository}) : super(LoginInitialState());

  Future<void> login(UserLoginData data) async {
    emit(LoginSendingState());

    var eitherValue = await repository.login(data);

    //TODO: Improve UX, Failure system
    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(LoginErrorState("Server unreachable"))
            : emit(LoginErrorState(failure.properties.first)),
        (logged) => logged
            ? emit(LoginSuccessfulState())
            : emit(LoginErrorState("Credenciales inválidas")));
  }

  Future<void> isLogged() async {
    emit(LoginInitialState());
    if(Settings.isLoggedIn){
      var userId = await Settings.userId;
      emit(LoginIsLoggedState(userId));
    }
  }

  Future<List<Cupon>> getCupons(String productRowId) async {

    var returnList = <Cupon>[];
    var eitherValue = await repository.getCuponsByUser(productRowId);

    eitherValue.fold(
            (errorFailure) => errorFailure.properties.isEmpty
            ? emit(LoginErrorState("Server unreachable"))
            : emit(LoginErrorState(errorFailure.properties.first)),
            (cupons) => cupons.length >= 0
            ? returnList = cupons
            : emit(LoginErrorState("No hay cupones disponibles")));


    return returnList;
  }

  Future<List<PendingOrder>> getPendingOrders(String userId) async {
    log("Pending orders");
    var returnList = <PendingOrder>[];
    var eitherValue = await repository.getUserPendingOrders(userId);

    eitherValue.fold(
            (errorFailure) => errorFailure.properties.isEmpty
            ? emit(LoginErrorState("Server unreachable"))
            : emit(LoginErrorState(errorFailure.properties.first)),
            (ordersPending) => ordersPending.length >= 0
            ? returnList = ordersPending
            : emit(LoginErrorState("No hay cupones disponibles")));


    return returnList;
  }

  Future<bool> postCancelOrder(String orderNumber) async {
    var value = false;

    var eitherValue = await repository.postCancelOrder(orderNumber);

    eitherValue.fold(
            (errorFailure) => errorFailure.properties.isEmpty
            ? emit(LoginErrorState("Server unreachable"))
            : emit(LoginErrorState(errorFailure.properties.first)),
            (success) => success
            ? value = success
            : emit(LoginErrorState("No hay cupones disponibles")));

    return value;
  }
}
