

import 'package:equatable/equatable.dart';
import 'package:pluis_hv_app/loginPage/loginRemoteDatasource.dart';

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

class LoginIsLoggedState extends LoginState{
  final String message;
  final UserDetails udata;

  LoginIsLoggedState(this.message,this.udata);
}
class LoginLoadingState extends LoginState{

}
class LoginErrorState extends LoginState{
  final String message;


  const LoginErrorState(this.message);
}