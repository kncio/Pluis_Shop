import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/loginPage/loginRemoteDatasource.dart';
import 'package:pluis_hv_app/settings/settings.dart';

import 'loginLocalDataSource.dart';

//TODO: Currently for testing
class LoginRepository {
  final ApiClient api;

  LoginRepository({this.api});

  static Future<void> testHttp() async {
    var api = ApiClient(serviceUri: WEB_SERVICE);
    var response = await api.getToken("get_token", null);

    var token = response.data["message"]["token_hash"];
    log("TOKEN: " + token.toString());
    var data = {
      "token_csrf": token.toString(),
      "email": "danny@domain.com",
      "password": "danito00"
    };

    await api.login(data);
  }

  static Future<void> testGetAllGender() async {
    var api = ApiClient(serviceUri: WEB_SERVICE);
    Response response = await api.get("getallGender", {});
    log(response.data.toString());
  }

  static Future<void> testGetAllCategory() async {
    var api = ApiClient(serviceUri: WEB_SERVICE);
    Response response = await api.get("getallCategory", {});
    log(response.data.toString());
  }

  static Future<void> testGetAllCategoryByGender() async {
    var api = ApiClient(serviceUri: WEB_SERVICE);
    Response response = await api.get("getallCategoryByGender", {"id": 1});
    log(response.data.toString());
  }

  static Future<void> testGetAllProduct() async {
    var api = ApiClient(serviceUri: WEB_SERVICE);
    Response response = await api.get("getAllProduct", {});
    log(response.data.toString());
  }

  static Future<void> testGetAllProductByCategory() async {
    var api = ApiClient(serviceUri: WEB_SERVICE);
    Response response = await api.get("getAllProductByCategory", {"id": 15});
    log(response.data.toString());
  }

  static Future<void> testGetCheckDiscountProductIsGender() async {
    var api = ApiClient(serviceUri: WEB_SERVICE);
    Response response =
        await api.get("getCheckDiscountProductIsGender", {"id": 2});
    log(response.data.toString());
  }

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

  //TODO: Implement RealLogin Methods
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
        //TODO: STORE THE INFO ON SHAREDPREFERENCES
        // log("Login sussces + ${result.data.toString()}");
        if(result.data['status']){
          var loginResponse = LoginResponse.fromMap(result.data['data']);
          await Settings.setCredentials(userEmail: loginResponse.email, token: loginResponse.token, rememberMe: false);
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
}
