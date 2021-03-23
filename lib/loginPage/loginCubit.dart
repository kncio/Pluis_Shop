import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/loginPage/loginLocalDataSource.dart';
import 'package:pluis_hv_app/loginPage/loginRepository.dart';
import 'package:pluis_hv_app/loginPage/loginStates.dart';

class LoginCubit extends Cubit<LoginState> {


  LoginRepository repository;

  LoginCubit({this.repository}) : super(LoginInitialState());

  Future<void> login(UserLoginData data) async {
    emit(LoginSendingState());

    var eitherValue = await repository.login(data);

    //TODO: Improve UX, Failure system
    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(LoginErrorState("Server unreachable"))
            : emit(LoginErrorState(failure.properties.first)),
        (logged) => logged
            ? emit(LoginSuccessfulState())
            : emit(LoginErrorState("Credenciales inválidas")));
  }

}
