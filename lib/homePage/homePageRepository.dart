import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/settings/settings.dart';

import 'homeDataModel.dart';

class HomePageRepository {
  final ApiClient api;

  HomePageRepository({this.api});

  Future<Either<Failure, List<SlidesInfo>>> loadImageUrl(String genreId) async {
    try {
      var response = await api.get(GET_SLIDES_IMAGES, {"id": genreId});

      if (response.statusCode == 200) {
        var slidesImageList = List<SlidesInfo>.from(
            response.data['data'].map((x) => SlidesInfo.fromJson(x)));

        return Right(slidesImageList);
      } else {
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
        var slidesImageList = List<GenresInfo>.from(
            response.data['data'].map((x) => GenresInfo.fromJson(x)));

        return Right(slidesImageList);
      } else {
        return Left(Failure([response.data.toString()]));
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }

  }
}
