import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/commons/keyStorage.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

class AddressBookRepository {
  final ApiClient api;

  AddressBookRepository({this.api});

  Future<Either<Failure, List<ClientAddress>>> getClientAddress(
      String userId) async {
    List<ClientAddress> alladdress = [];

    try {
      var response = await api.get(GET_CLIENT_ADDRESS, {'id': userId});

      if (response.statusCode == 200) {
        for (var addressInfo in response.data["data"]["Libraries Address"]) {
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

  Future<Either<Failure, bool>> deleteAddress(String userId) async {
    bool status = false;

    try {
      var sessionTOken = await Settings.storedToken;
      var token_csrf = await Settings.storedApiToken;
      api.client.options.headers = {
        '$API_KEY_NAME': '$API_KEY',
        'Authorization': sessionTOken
      };

      var response = await api.post(
          DELETE_ADDRESS, {'token_csrf': token_csrf, 'address_id': userId});

      if (response.statusCode == 200) {
        log(response.data.toString());
        var responseString = response.data.toString();
        if (responseString.contains("Exito")) {
          status = true;
        }
        return Right(status);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, bool>> createAddress(AddressForm addressForm) async {
    bool status = false;

    try {
      var sessionTOken = await Settings.storedToken;
      var token_csrf = await Settings.storedApiToken;
      api.client.options.headers = {
        '$API_KEY_NAME': '$API_KEY',
        'Authorization': sessionTOken
      };
      addressForm.token_csrf = token_csrf;
      log(addressForm.toMap().toString());
      var response = await api.post(CREATE_ADDRESS, addressForm.toMap());

      if (response.statusCode == 200) {
        log(response.data.toString());
        var responseString = response.data.toString();
        if (responseString.contains("Exito")) {
          status = true;
        }
        return Right(status);
      } else {
        log("Error");
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }
}

class AddressForm {
  String token_csrf;
  String name;
  String last_name;
  String city_id;
  String state_id;
  String phone_number;
  String address_number;
  String address;

  AddressForm(
      {this.token_csrf,
      this.name,
      this.last_name,
      this.city_id,
      this.state_id,
      this.address,
      this.phone_number,
      this.address_number});

  Map<String, dynamic> toMap() {
    return {
      "token_csrf": this.token_csrf,
      'name': this.name,
      'last_name': this.last_name,
      'city_id': this.city_id,
      'state_id': this.state_id,
      'phone_number': this.phone_number,
      'address_number': this.address_number,
      'address': this.address,
    };
  }
}
