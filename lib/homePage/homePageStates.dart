import 'package:equatable/equatable.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageGenresLoaded extends HomePageState {
  final List<GenresInfo> genresInfo;

  HomePageGenresLoaded({ this.genresInfo});
}

class HomePageLoadingSliders extends HomePageState {

}

class HomePageSuccessState extends HomePageState {
  final List<List<SlidesInfo>> imagesUrl;

  HomePageSuccessState({this.imagesUrl});
}

class HomePageErrorState extends HomePageState {
  final String message;

  HomePageErrorState({this.message});
}
