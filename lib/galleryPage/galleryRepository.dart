import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/apiMethodsNames.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

class GalleryRepository {
  final ApiClient api;

  GalleryRepository({this.api});

  Future<Either<Failure, List<Product>>> getAllProducts(String genreId) async {
    List<Product> allProducts = [];
    log("agghhh");
    try {
      var response = await api.get(GET_ALL_DISCOUNT_PRODUCTS_By_GENDER, {"id": 5});

      if (response.statusCode == 200) {
        for (var product in response.data["data"]) {
          allProducts.add(Product.fromMap(product));
        }

        return Right(allProducts);
      } else {
        log(response.statusCode.toString());
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  Future<Either<Failure, List<Product>>> getAllProductByCategory(
      String categoryId) async {
    List<Product> allProducts = [];
    try {
      var response =
          await api.get(GET_ALL_PRODUCTS_BY_CATEGORY, {"id": categoryId});

      if (response.statusCode == 200) {
        for (var product in response.data["data"]) {
          allProducts.add(Product.fromMap(product));
        }
        return Right(allProducts);
      } else {
        log(response.statusCode.toString());
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
