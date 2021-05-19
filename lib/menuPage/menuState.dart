import 'package:equatable/equatable.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:pluis_hv_app/menuPage/MenuDataModel.dart';

abstract class MenuState extends Equatable {
  @override
  List<Object> get props => [];
}

class MenuStateInitial extends MenuState {

}

class MenuStateLoading extends MenuState {

}

class MenuStateLoaded extends MenuState {
  final List<GenresInfo> genresTabs;

  MenuStateLoaded(this.genresTabs);
}

class MenuStateSuccess extends MenuState {

}

class MenuStateError extends MenuState {
  final String message;

  MenuStateError(this.message);
}