import 'package:equatable/equatable.dart';

abstract class MenuState extends Equatable {
  @override
  List<Object> get props => [];
}

class MenuStateInitial extends MenuState {}
