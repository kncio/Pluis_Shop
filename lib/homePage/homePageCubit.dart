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

  Future<void> loadSlidersInfo(List<GenresInfo> genres) async {
    emit(HomePageLoadingSliders());

    List<List<SlidesInfo>> sliders = [];
    getSliders(genres)
        .then((value) => {sliders = value})
        .catchError((err) => log("Error: $err"))
        .whenComplete(() => {
          emit(HomePageSuccessState(imagesUrl: sliders))

        });

    log("SLIDERS" + sliders.toString());
  }

  Future<List<List<SlidesInfo>>> getSliders(List<GenresInfo> genres) async {
    List<List<SlidesInfo>> sliders = List<List<SlidesInfo>>();

    genres.forEach((element) {
      repository
          .loadImageUrl(element.gender_id)
          .then((value) => {value.fold((l) => [], (r) => sliders.add(r))});
    });
    return sliders;
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
                HomePageErrorState(message: "No hay provincias disponibles")));
  }
}
