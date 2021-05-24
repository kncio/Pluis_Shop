import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';

import 'detailsPageRemoteDataSource.dart';

class DetailsRepository {
  final ApiClient api;

  DetailsRepository({this.api});

  Future<Either<Failure, List<ColorByProductsDataModel>>> getColorsByProduct(
      String productRowId) async {
    List<ColorByProductsDataModel> allColorsBy = [];

    try {
      var response = await api.get(GET_COLORS_BY, {'id': productRowId});

      if (response.statusCode == 200) {
        log("getColorsByProduct called" + response.data["data"][0].toString());

        for (var colorInfo in response.data["data"]) {
          log(colorInfo.toString());
          allColorsBy.add(ColorByProductsDataModel.fromMap(colorInfo));
        }
        log("list lenght" + allColorsBy.length.toString());
        return Right(allColorsBy);
      } else {
        log(response.statusCode.toString());
        return Left(Failure([response.statusMessage]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }
}
