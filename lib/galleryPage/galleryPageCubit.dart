import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/galleryPage/galleryPageState.dart';
import 'package:pluis_hv_app/galleryPage/galleryRepository.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

class GalleryPageCubit extends Cubit<GalleryPageState> {
  GalleryRepository repository;

  GalleryPageCubit({this.repository}) : super(GalleryPageInitialState());

  Future<void> getAllProducts() async {
    emit(GalleryPageLoadingState());

    var eitherValue = await repository.getAllProducts();

    //TODO: Improve UX, Failure system
    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(GalleryPageErrorState("Server unreachable"))
            : emit(GalleryPageErrorState(failure.properties.first)),
        (products) => products.length >= 0
            ? emit(GalleryPageSuccessState(products))
            : emit(GalleryPageErrorState("Error desconocido")));
  }

  Future<void> getProductsByCategory(categoryId) async {
    emit(GalleryPageLoadingState());

    var eitherValue = await repository.getAllProductByCategory(categoryId);

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(GalleryPageErrorState("Server unreachable"))
            : emit(GalleryPageErrorState(failure.properties.first)),
        (products) => products.length >= 0
            ? emit(GalleryPageSuccessState(products))
            : emit(GalleryPageErrorState("Error desconocido")));
  }

  Future<List<SiteCurrency>> getSiteCurrencys() async {
    List<SiteCurrency> currencyList = [];

    var eitherValue = await repository.getCurrencys();

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(GalleryPageErrorState("Server unreachable"))
            : emit(GalleryPageErrorState(failure.properties.first)),
        (currencys) => currencys.length >= 0
            ? currencyList = currencys
            : emit(GalleryPageErrorState("Error desconocido")));

    return currencyList;
  }
}
