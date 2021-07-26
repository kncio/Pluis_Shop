import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/commons/keyStorage.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/loginPage/loginRemoteDatasource.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

import 'loginLocalDataSource.dart';

class LoginRepository {
  final ApiClient api;

  LoginRepository({this.api});

  Future<Either<Failure, bool>> login(UserLoginData data) async {
    try {
      var response = await api.getToken("get_token", null);

      var token = response.data["message"]["token_hash"];

      var finalData = UserLoginData(
          password: data.password, email: data.email, token_csrf: token);

      //TODO: Check connection status
      var userData = finalData.toMap();
      var result = await api.login(userData);
      if (result.statusCode == 200) {
        if (result.data['status']) {
          var loginResponse = LoginResponse.fromMap(result.data['data']);

          await Settings.setCredentials(
              userEmail: loginResponse.email,
              token: loginResponse.token,
              rememberMe: false,
              id: loginResponse.user_id);

          log(loginResponse.email);
        }
        return Right(true);
      } else {
        return Left(Failure(["Nombre de usuario o contraseña incorrecta."]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

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

  Future<Either<Failure, List<PendingOrder>>> getUserPendingOrders(
      String userId) async {
    List<PendingOrder> pendingOrders = [];
    try {
      var response = await api.get(GET_PENDING_ORDERS, {'id': userId});

      if (response.statusCode == 200) {
        for (var orderInfo in response.data["data"]) {
          pendingOrders.add(PendingOrder.fromJson(orderInfo));
        }
        var result = pendingOrders.reversed.toList();
        log("dasd");
        return Right(result);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, List<PendingOrder>>> getUserCompleteOrders(
      String userId) async {
    List<PendingOrder> pendingOrders = [];
    try {
      var response = await api.get(GET_COMPLETE_ORDERS, {'id': userId});

      if (response.statusCode == 200) {
        for (var orderInfo in response.data["data"]) {
          pendingOrders.add(PendingOrder.fromJson(orderInfo));
        }
        var result = pendingOrders.reversed.toList();
        log("dasd");
        return Right(result);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, List<BillData>>> getBills(String userId) async {
    List<BillData> bills = [];
    try {
      var response = await api.get(GET_BILLS, {'id': userId});

      if (response.statusCode == 200) {
        for (var billInfo in response.data["data"]) {
          bills.add(BillData.fromJson(billInfo));
        }
        return Right(bills);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, bool>> downloadBill(
      String storePath, String url, Function(int, int) progressCallback) async {
    try {
      var response = await api.downloadFile(url, storePath, progressCallback);
      log("entro a descargar lo guardara en: ${storePath}");
      if (response.statusCode == 200) {
        return Right(true);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, bool>> postCancelOrder(String orderNumber) async {
    try {
      var sessionTOken = await Settings.storedToken;
      api.client.options.headers = {
        '$API_KEY_NAME': '$API_KEY',
        'Authorization': sessionTOken
      };

      var tokenCsrf = await Settings.storedApiToken;
      var response = await api.post(POST_CANCEL_ORDER,
          {"token_csrf": tokenCsrf, "order_number": orderNumber});

      if (response.statusCode == 200) {
        log("CANCEL ORDER");
        return Right(true);
      } else {
        log(response.data);
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, SubscriptionsData>> getSumbissionData(
      String userId) async {
    try {
      log("u id" + userId);
      var response = await api.get(GET_SUBSCRIPTION_DATA, {'id': userId});

      if (response.statusCode == 200) {
        log("Status of subs" + response.data["data"].toString());
        if (response.data["data"].toString() == "null") {
          return Right(SubscriptionsData(
              id: "none",
              user_id: userId,
              preference: "",
              email: "",
              is_sms_recibed: "0",
              is_email_recibed: "0"));
        }
        var subData = SubscriptionsData.fromJson(response.data["data"]);

        return Right(subData);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, UserDetails>> getUserDetails(String userId) async {
    try {
      var response = await api.get(GET_USER_INFO, {'id': userId});

      if (response.statusCode == 200) {
        var uData = UserDetails.fromJson(response.data["data"]);
        log("uData" + response.data["data"].toString());
        return Right(uData);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, bool>> postUpdateSubscriptionData(
      SubscriptionsData data) async {
    try {
      var sessionTOken = await Settings.storedToken;
      api.client.options.headers = {
        '$API_KEY_NAME': '$API_KEY',
        'Authorization': sessionTOken
      };

      var tokenCsrf = await Settings.storedApiToken;
      var params = data.getMapToPostMethod(tokenCsrf);

      var response = await api.post(POST_SUBSCRIPTION_DATA, params);

      if (response.statusCode == 200) {
        log("post update subs" + response.data);
        return Right(true);
      } else {
        log(response.data);
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, bool>> postUpdateEmail(
      UpdateEmailDataForm data) async {
    try {
      var sessionTOken = await Settings.storedToken;
      api.client.options.headers = {
        '$API_KEY_NAME': '$API_KEY',
        'Authorization': sessionTOken
      };

      var tokenCsrf = await Settings.storedApiToken;
      data.token_csrf = tokenCsrf;
      var params = data.toMap();

      var response = await api.post(POST_CHANGE_EMAIL, params);

      if (response.statusCode == 200) {
        if (response.data.toString().contains("field_errors")) {
          return Right(false);
        }
        return Right(true);
      } else {
        log(response.data);
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, bool>> postUpdatePassword(
      UpdatePasswordDataForm data) async {
    try {
      var sessionTOken = await Settings.storedToken;
      api.client.options.headers = {
        '$API_KEY_NAME': '$API_KEY',
        'Authorization': sessionTOken
      };

      var tokenCsrf = await Settings.storedApiToken;
      data.token_csrf = tokenCsrf;
      var params = data.toMap();
      log("rr : " + params.toString());
      var response = await api.post(POST_CHANGE_PASSWORD, params);

      if (response.statusCode == 200) {
        log("post update subs" + response.data);
        if (response.data.toString().contains("field_errors")) {
          return Right(false);
        }
        return Right(true);
      } else {
        log(response.data);
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }
}
