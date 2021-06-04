import 'package:equatable/equatable.dart';

import 'detailsPageRemoteDataSource.dart';

abstract class DetailsPageState extends Equatable{
  const DetailsPageState();

  @override
  List<Object> get props => [];
}

class DetailsPageInitialState extends DetailsPageState{

}

class DetailsPageSuccessColor extends DetailsPageState{
    final List<ColorByProductsDataModel> colorsBy;

    DetailsPageSuccessColor({this.colorsBy});

}

class DetailsPageSuccess extends DetailsPageState{


}

class DetailsLoading extends DetailsPageState{
  final String message = "Cargando...";
}

class DetailsImagesLoaded extends DetailsPageState{
  final List<ProductDetailsImages> imagesList;

  DetailsImagesLoaded(this.imagesList);
}

class DetailsSizesLoaded extends DetailsPageState{
  final List<SizeVariationByColor> sizeList;

  DetailsSizesLoaded({this.sizeList});
}

class DetailsError extends DetailsPageState{
  final String message;

  const DetailsError(this.message);
}