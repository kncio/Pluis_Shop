import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/register/registerDataModel.dart';
import 'package:pluis_hv_app/register/registerRepository.dart';
import 'package:pluis_hv_app/register/registerState.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository repository;

  RegisterCubit({this.repository}) : super(RegisterInitialState());

  Future<void> register(RegisterData data) async {
    emit(RegisterLoadingState());

    var eitherValue = await repository.register(data);

    //TODO: Improve UX, Failure system
    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(RegisterErrorState(message: "Server unreachable"))
            : emit(RegisterErrorState(message: failure.properties.first)),
        (logged) => logged
            ? emit(RegisterSuccessState(message: "Ok"))
            : emit(RegisterErrorState(message: "Campos Inválidos")));
  }
}
