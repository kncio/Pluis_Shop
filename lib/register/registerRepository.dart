import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/register/registerDataModel.dart';
import 'package:pluis_hv_app/settings/settings.dart';

class RegisterRepository {
  final ApiClient api;

  RegisterRepository({this.api});

  static Future<void> testRegister() async {
    var api = ApiClient(serviceUri: WEB_SERVICE);

    var token = await api.getToken("get_token", {});

    log(token.toString());

    Response response = await api.post("user_register", {
      'token_csrf': '${token.data["message"]["token_hash"]}',
      'isCompany': '1',
      'email': 'davidcancio@gmail.com',
      'password': '12345678',
      'passwordConfirm': '12345678',
      'firstName': 'David',
      'lastName': 'Cancio',
      'province': '3',
      'municipe': '2301',
      'addressLines': 'zona#4',
      'addressLines_1': 'casa4 ',
      'phone': '58379145',
      'privacyCheck': '1'
    });

    log(response.data.toString());
  }

  Future<Either<Failure, bool>> register(RegisterData registerData) async {
    try {
      var apiToken = await Settings.storedApiToken;

      var registerFinalData = RegisterData(
          token_csrf: apiToken,
          isCompany: registerData.isCompany,
          email: registerData.email,
          password: registerData.password,
          passwordConfirm: registerData.passwordConfirm,
          firstName: registerData.firstName,
          lastName: registerData.lastName,
          province: registerData.province,
          municipe: registerData.municipe,
          addressLines: registerData.addressLines,
          addressLines_1: registerData.addressLines_1,
          phone: registerData.phone,
          privacyCheck: registerData.privacyCheck);
      log("Register called" + registerFinalData.toMap().toString());
      var response = await api.post("user_register", registerFinalData.toMap());

      if (response.statusCode == 200) {
        log("Register called" + response.data.toString());

        return Right(true);
      } else {
        log(response.statusCode.toString());
        return Left(Failure([response.data.toString()]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }

    return Left(Failure(["No hay conexión con el servidor"]));
  }
}
