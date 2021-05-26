import 'package:bloc/bloc.dart';

import 'detailsPageRepository.dart';
import 'detailsPageState.dart';

class DetailsCubit extends Cubit<DetailsPageState> {
  DetailsRepository repository;

  DetailsCubit({this.repository}) : super(DetailsPageInitialState());

  Future<void> getColorsBy(String productRowId) async {
    emit(DetailsLoading());

    var eitherValue = await repository.getColorsByProduct(productRowId);

    eitherValue.fold(
        (errorFailure) => errorFailure.properties.isEmpty
            ? emit(DetailsError("Server unreachable"))
            : emit(DetailsError(errorFailure.properties.first)),
        (colorsList) => colorsList.length > 0
            ? emit(DetailsPageSuccess(colorsBy: colorsList))
            : emit(DetailsError(
                "Actualmente no existen ejemplares de este producto")));
  }
}
