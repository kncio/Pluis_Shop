

import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState{

}
class LoginSendingState extends LoginState{
  final String message = "En proceso...";
}
class LoginSuccessfulState extends LoginState{
  final String message = "Acceso satisfactorio!";
}
class LoginErrorState extends LoginState{
  final String message;

  const LoginErrorState(this.message);
}