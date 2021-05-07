import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:pluis_hv_app/homePage/homePageStates.dart';

import 'homePageRepository.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final HomePageRepository repository;

  HomePageCubit({this.repository}) : super(HomePageInitial());

  Future<bool> loadImageUrl() async {
    var eitherValue = await repository.loadImageUrl();

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(HomePageErrorState(message: "Server unreachable"))
            : emit(HomePageErrorState(message: failure.properties.first)),
        (slideInfo) => slideInfo != null
            ? emit(HomePageImagesLoaded(imagesUrl: slideInfo))
            : emit(
                HomePageErrorState(message: "No hay provincias disponibles")));
  }

  Future<bool> loadGenres() async {
    emit(HomePageLoading());
    var eitherValue = await repository.loadGenres();

    var slidersEither = await repository.loadImageUrl();
    var slidersList = List<SlidesInfo>();
    slidersEither.fold((l) => null, (r) => slidersList = r);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(HomePageErrorState(message: "Server unreachable"))
            : emit(HomePageErrorState(message: failure.properties.first)),
        (genres) => genres != null
            ? emit(HomePageImagesLoaded(
                genresInfo: genres, imagesUrl: slidersList))
            : emit(
                HomePageErrorState(message: "No hay provincias disponibles")));
  }
}
