import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
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
}
