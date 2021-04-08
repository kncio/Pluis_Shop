import 'package:equatable/equatable.dart';

abstract class MenuState extends Equatable {
  @override
  List<Object> get props => [];
}

class MenuStateInitial extends MenuState {

}

class MenuStateLoading extends MenuState {

}
class MenuStateSuccess extends MenuState {

}
