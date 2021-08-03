import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/commons/keyStorage.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/loginPage/loginStates.dart';
import 'package:pluis_hv_app/register/registerDataModel.dart';
import 'package:pluis_hv_app/settings/settings.dart';

class RegisterRepository {
  final ApiClient api;

  RegisterRepository({this.api});

  Future<Either<Failure, String>> register(RegisterData registerData) async {
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
          privacyCheck: registerData.privacyCheck,
          activation: registerData.activation);
      // log("Register called" + registerFinalData.toMap().toString());
      var response = await api.post("user_register", registerFinalData.toMap());

      if (response.statusCode == 200) {
        // log("Register called" + response.data.toString());
        return Right(response.data.toString());
      } else {
        log(response.statusCode.toString());
        return Left(Failure([response.data.toString()]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }

    return Left(Failure(["No hay conexión con el servidor"]));
  }

  Future<Either<Failure, List<Province>>> getProvinces() async {
    try {
      var response = await api.get("get_state", {});
      if (response.statusCode == 200) {
        var listProvinces = List<Province>.from(
            response.data["data"].map((x) => Province.fromJson(x)));
        log("Register called" + response.data["data"].toString());
        return Right(listProvinces);
      } else {
        log(response.statusCode.toString());
        return Left(Failure([response.data.toString()]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, List<Municipe>>> getMunicipes(String id) async {
    try {
      var response = await api.get("get_city", {"id": id});
      if (response.statusCode == 200) {
        log("Register called" + response.data.toString());
        var listMunicipes = List<Municipe>.from(
            response.data["data"].map((x) => Municipe.fromJson(x)));

        return Right(listMunicipes);
      } else {
        log(response.statusCode.toString());
        return Left(Failure([response.data.toString()]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, bool>> activateCode(String code, String phone) async {
    try {
      var apiToken = await Settings.storedApiToken;
      log(phone);
      var response = await api.post(ACTIVATE_CODE,
          {"token_csrf": apiToken, "phone": phone, "code": code});
      if (response.statusCode == 200) {
        var json = jsonEncode(response.data);

        bool success = json.contains("success");

        if (!success) {
          return Right(true);
        }
        return Right(false);
      } else {
        log(response.statusCode.toString());
        return Left(Failure([response.data.toString()]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, bool>> sendCode() async {
    try {
      var sessionTOken = await Settings.storedToken;
      api.client.options.headers = {
        '$API_KEY_NAME': '$API_KEY',
        'Authorization': sessionTOken
      };
      var response = await api.post(SEND_CODE, {});
      if (response.statusCode == 200) {
        var json = jsonEncode(response.data);

        bool success = json.contains("success");

        if (!success) {
          return Right(true);
        }
        return Right(false);
      } else {
        log(response.statusCode.toString());
        return Left(Failure([response.data.toString()]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }
}
