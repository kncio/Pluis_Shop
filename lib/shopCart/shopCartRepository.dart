import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

class ShopCartRepository {
  final ApiClient api;

  ShopCartRepository({this.api});

  Future<Either<Failure, List<Cupon>>> getCuponsByUser(String userId) async {
    List<Cupon> allCupons = [];
    try {
      var response = await api.get(GET_USER_CUPON, {'id': userId});

      if (response.statusCode == 200) {
        for (var cuponInfo in response.data["data"]) {
          log(cuponInfo.toString());
          allCupons.add(Cupon.fromJson(cuponInfo));
        }
        return Right(allCupons);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, List<ClientAddress>>> getClientAddress(
      String userId) async {
    List<ClientAddress> alladdress = [];

    try {

      var response = await api.get(GET_CLIENT_ADDRESS, {'id': userId});

      if (response.statusCode == 200) {
        for (var addressInfo in response.data["data"]) {
          log(addressInfo.toString());
          alladdress.add(ClientAddress.fromJson(addressInfo));
        }

        return Right(alladdress);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, DeliveryPrice>> getDeliveryPriceByMunicipeId(
      String stateId) async {
    DeliveryPrice deliveryPrice;

    try {
      var response =
          await api.get(GET_DELIVERY_PRICE_BY_STATE_ID, {'id': stateId});

      if (response.statusCode == 200) {
        deliveryPrice = DeliveryPrice.fromJson(response.data);
        return Right(deliveryPrice);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, List<SiteCurrency>>> getCurrencys() async {
    List<SiteCurrency> currencys = [];

    try {
      var response = await api.get(GET_CURRENCY, {});

      if (response.statusCode == 200) {
        log(response.data.toString());
        response.data["data"] = [
          {
            "id": "18",
            "coin_nomenclature": "EUR",
            "exchange_rate": "0.0410"
          },
          {
            "id": "19",
            "coin_nomenclature": "USD",
            "exchange_rate": "0.0810"
          }
        ];
        for (var currencyInfo in response.data["data"]) {
          log(currencyInfo.toString());
          currencys.add(SiteCurrency.fromJson(currencyInfo));
        }

        return Right(currencys);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }
}
