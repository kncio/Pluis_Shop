import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:pluis_hv_app/menuPage/MenuDataModel.dart';

class MenuPageRepository {
  final ApiClient api;

  MenuPageRepository({this.api});

  Future<Either<Failure, List<CategoryData>>> getCategoryByGender(
      String genreId) async {
    try {
      var response = await api.get(ALL_CATEGORY_BY_GENDER, {"id": genreId});

      if (response.statusCode == 200) {
        log("ALL_CATEGORY_BY_GENDER called" + response.data.toString());

        var categoryByGenderList = List<CategoryData>.from(
            response.data['data'].map((x) => CategoryData.fromJson(x)));

        return Right(categoryByGenderList);
      } else {
        log(response.statusCode.toString());
        return Left(Failure([response.data.toString()]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, List<CategoryOnDiscountData>>>
      getCategoryOnDiscountByGender(String genreId) async {
    try {
      var response =
          await api.get(GET_ALL_DISCOUNT_CATEGORY_By_GENDER, {"id": genreId});

      if (response.statusCode == 200) {
        var categoryByGenderList = List<CategoryOnDiscountData>.from(
            response.data['data'].map((categoryData) =>
                CategoryOnDiscountData.fromJson(categoryData)));

        return Right(categoryByGenderList);
      } else {
        log(response.statusCode.toString());
        return Left(Failure([response.data.toString()]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, List<GenresInfo>>> loadGenres() async {
    try {
      var response = await api.get(ALL_GENDER, {});

      if (response.statusCode == 200) {
        log("GET Genres called" + response.data.toString());

        var slidesImageList = List<GenresInfo>.from(
            response.data['data'].map((x) => GenresInfo.fromJson(x)));

        return Right(slidesImageList);
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
