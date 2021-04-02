import 'package:equatable/equatable.dart';

abstract class DetailsPageState extends Equatable{
  const DetailsPageState();

  @override
  List<Object> get props => [];
}

class DetailsPageInitialState extends DetailsPageState{

}

class DetailsPageSuccess extends DetailsPageState{

}

class DetailsLoading extends DetailsPageState{
  final String message = "Cargando...";
}

class LoginErrorState extends DetailsPageState{
  final String message;

  const LoginErrorState(this.message);
}