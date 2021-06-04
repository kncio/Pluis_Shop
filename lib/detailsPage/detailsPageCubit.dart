import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageRemoteDataSource.dart';

import 'detailsPageRepository.dart';
import 'detailsPageState.dart';

class DetailsCubit extends Cubit<DetailsPageState> {
  DetailsRepository repository;

  DetailsCubit({this.repository}) : super(DetailsPageInitialState());

  Future<List<SizeVariationByColor>> getSizeByColor(String colorRowId) async {
    emit(DetailsLoading());
    List<SizeVariationByColor> returnvalue = [];

    var eitherValue = await repository.getColorsVariation(colorRowId);

    eitherValue.fold(
            (errorFailure) => errorFailure.properties.isEmpty
            ? emit(DetailsError("Server unreachable"))
            : emit(DetailsError(errorFailure.properties.first)),
            (sizes) => sizes.length >= 0
            ? emit(DetailsSizesLoaded(sizeList: sizes))
            : emit(DetailsError(
            "Actualmente no existen ejemplares de este producto")));

    return  returnvalue;
  }
  Future<void> getColorsBy(String productRowId) async {
    emit(DetailsLoading());

    var eitherValue = await repository.getColorsByProduct(productRowId);

    eitherValue.fold(
        (errorFailure) => errorFailure.properties.isEmpty
            ? emit(DetailsError("Server unreachable"))
            : emit(DetailsError(errorFailure.properties.first)),
        (colorsList) => colorsList.length > 0
            ? emit(DetailsPageSuccessColor(colorsBy: colorsList))
            : emit(DetailsError(
                "Actualmente no existen ejemplares de este producto")));
  }
  Future<void> getDetailsImages(String productRowId) async {
    emit(DetailsLoading());

    var eitherValue = await repository.getDetailsImages(productRowId);

    eitherValue.fold(
            (errorFailure) => errorFailure.properties.isEmpty
            ? emit(DetailsError("Server unreachable"))
            : emit(DetailsError(errorFailure.properties.first)),
            (imagesList) => imagesList.length >= 0
            ? emit(DetailsImagesLoaded( imagesList))
            : emit(DetailsError(
            "Actualmente no existen ejemplares de este producto")));
  }
  Future<void> setSuccess() async {
    emit(DetailsPageSuccess());
  }
}
