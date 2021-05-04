import 'package:equatable/equatable.dart';
import 'package:pluis_hv_app/register/registerDataModel.dart';

abstract class RegisterState extends Equatable{
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitialState extends RegisterState{
  final List<Province> provinces;

  RegisterInitialState({this.provinces});
}

class RegisterLoadingState extends RegisterState{

}

class RegisterSuccessState extends RegisterState{
  final String message;

  RegisterSuccessState({this.message});
}

class RegisterErrorState extends RegisterState{
  final String message;

  RegisterErrorState({this.message});
}