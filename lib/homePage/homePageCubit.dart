import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:pluis_hv_app/homePage/homePageStates.dart';

import 'homePageRepository.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final HomePageRepository repository;

  HomePageCubit({this.repository}) : super(HomePageInitial());

  // Future<bool> loadImageUrl(String id) async {
  //   var eitherValue = await repository.loadImageUrl();
  //
  //   eitherValue.fold(
  //       (failure) => failure.properties.isEmpty
  //           ? emit(HomePageErrorState(message: "Server unreachable"))
  //           : emit(HomePageErrorState(message: failure.properties.first)),
  //       (slideInfo) => slideInfo != null
  //           ? emit(HomePageSuccessState(imagesUrl: slideInfo))
  //           : emit(
  //               HomePageErrorState(message: "No hay provincias disponibles")));
  // }

  Future<bool> downloadFile(String url, String path, Function (int,int) callback) async {
    var start = false;

    var eitherValue = await repository.download(
        path, url, callback);

    eitherValue.fold((errorFailure) =>
    errorFailure.properties.isEmpty
        ? emit(HomePageErrorState(message:"Server unreachable"))
        : emit(HomePageErrorState(message:errorFailure.properties.first)), (r) =>
    r ? start = r : HomePageErrorState(message:"No se pudo descargar la factura"));

    return start;
  }

  Future<void> setSuccess()async {
    emit(HomePageSuccessState());
  }

  Future<void> loadGenres() async {
    emit(HomePageLoading());
    var eitherValue = await repository.loadGenres();

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(HomePageErrorState(message: "Server unreachable"))
            : emit(HomePageErrorState(message: failure.properties.first)),
        (genres) => genres != null
            ? emit(HomePageGenresLoaded(genresInfo: genres))
            : emit(
                HomePageErrorState(message: "No hay información disponible")));
  }
}
