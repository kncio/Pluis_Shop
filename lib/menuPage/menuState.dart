import 'package:equatable/equatable.dart';
import 'package:pluis_hv_app/menuPage/MenuDataModel.dart';

abstract class MenuState extends Equatable {
  @override
  List<Object> get props => [];
}

class MenuStateInitial extends MenuState {

}

class MenuStateLoading extends MenuState {

}
class MenuStateSuccess extends MenuState {
  final List<CategoryData> categories;

  MenuStateSuccess({this.categories});
}

class MenuStateError extends MenuState {
  final String message;

  MenuStateError(this.message);
}