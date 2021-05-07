import 'package:equatable/equatable.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageImagesLoaded extends HomePageState {
  final List<SlidesInfo> imagesUrl;
  final List<GenresInfo> genresInfo;
  HomePageImagesLoaded({this.imagesUrl, this.genresInfo});
}

class HomePageErrorState extends HomePageState {
  final String message;

  HomePageErrorState({this.message});
}
