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


class GalleryRepository {
  final ApiClient api;

  GalleryRepository({this.api});

  static Future<void> testGetAllProduct() async {
    var api = ApiClient(serviceUri: WEB_SERVICE);
    Response response = await api.get("getAllProduct", {});
    log(response.data.toString());
  }

  Future<Either<Failure, List<Product>>> getAllProducts() async {
    List<Product> allProducts = [];

    try {
      var response = await api.get("getAllProduct", {});

      if (response.statusCode == 200) {
        log("GetAll Products called" + response.data["data"][0].toString());

        for (var product in response.data["data"]) {
          log(product.toString());
          allProducts.add(Product.fromMap(product));
        }
        log("list lenght" + allProducts.length.toString());
        return Right(allProducts);
      } else {
        log(response.statusCode.toString());
      }
    } catch (error) {
      return Left(Failure([error.toString()]));
    }
  }

  static Future<void> testGetAllProductByCategory() async {
    var api = ApiClient(serviceUri: WEB_SERVICE);
    Response response = await api.get("getAllProductByCategory", {"id": 15});
    log(response.data.toString());
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
}
