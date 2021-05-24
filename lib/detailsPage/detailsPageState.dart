import 'package:equatable/equatable.dart';

import 'detailsPageRemoteDataSource.dart';

abstract class DetailsPageState extends Equatable{
  const DetailsPageState();

  @override
  List<Object> get props => [];
}

class DetailsPageInitialState extends DetailsPageState{

}

class DetailsPageSuccess extends DetailsPageState{
    final List<ColorByProductsDataModel> colorsBy;

  DetailsPageSuccess({this.colorsBy});

}

class DetailsLoading extends DetailsPageState{
  final String message = "Cargando...";
}

class DetailsError extends DetailsPageState{
  final String message;

  const DetailsError(this.message);
}