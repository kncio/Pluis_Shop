import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageRemoteDataSource.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCardCubit.dart';

import 'detailsPageRepository.dart';
import 'detailsPageState.dart';

class DetailsCubit extends Cubit<DetailsPageState> {
  DetailsRepository repository;

  DetailsCubit({this.repository}) : super(DetailsPageInitialState());

  Future<List<SizeVariationByColor>> getSizeByColor(String colorRowId) async {

    List<SizeVariationByColor> returnvalue = [];

    var eitherValue = await repository.getColorsVariation(colorRowId);

    eitherValue.fold(
            (errorFailure) => errorFailure.properties.isEmpty
            ? emit(DetailsError("Server unreachable"))
            : emit(DetailsError(errorFailure.properties.first)),
            (sizes) => sizes.length >= 0
            ? returnvalue = sizes
            : emit(DetailsError(
            "Error durante la carga de tallas")));

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
  
  Future<List<ProductDetailsImages>> getDetailsImages(String productRowId) async {
    var resultList = <ProductDetailsImages>[];

    var eitherValue = await repository.getDetailsImages(productRowId);

    eitherValue.fold(
            (errorFailure) => errorFailure.properties.isEmpty
            ? emit(DetailsError("Server unreachable"))
            : emit(DetailsError(errorFailure.properties.first)),
            (imagesList) => imagesList.length >= 0
            ? resultList = imagesList
            : emit(DetailsError(
            "Error Cargando las Imagenes")));
    return resultList;
  }
  Future<void> setSuccess() async {
    emit(DetailsPageSuccess());
  }

  Future<List<PriceVariation>> getPriceVariations(String price) async {
    var priceVariation = <PriceVariation>[];
    var eitherValue = await repository.getPriceVariation(price);

    eitherValue.fold(
            (failure) => failure.properties.isEmpty
            ? emit(DetailsError("Server unreachable"))
            : emit(DetailsError(failure.properties.first)),
            (list) => list.length >= 0
            ? priceVariation = list
            : emit(DetailsError("Error")));

    return priceVariation;
  }

  Future<Product> getProductDetail(String rowId) async {
    var productDet;
    var eitherValue = await repository.getProductDetail(rowId);

    eitherValue.fold(
            (failure) => failure.properties.isEmpty
            ? emit(DetailsError("Server unreachable"))
            : emit(DetailsError(failure.properties.first)),
            (product) => product !=null
            ? productDet = product
            : emit(DetailsError("Error")));

    return productDet;
  }
}
