

import 'package:equatable/equatable.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';

abstract class GalleryPageState extends Equatable {
  const GalleryPageState();

  @override
  List<Object> get props => [];

}

class GalleryPageInitialState extends GalleryPageState{

}

class GalleryPageLoadingState extends GalleryPageState{
  // final List<Product> products;
  //
  // GalleryPageLoadingState(this.products);
}
class GalleryPageErrorState extends GalleryPageState{
 final String message;

  GalleryPageErrorState(this.message);
}

class GalleryPageSuccessState extends GalleryPageState{
  final List<Product> products;

  GalleryPageSuccessState(this.products);
}