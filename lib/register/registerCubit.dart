import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/register/registerDataModel.dart';
import 'package:pluis_hv_app/register/registerRepository.dart';
import 'package:pluis_hv_app/register/registerState.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository repository;

  RegisterCubit({this.repository}) : super(RegisterBuildingState());

  Future<void> register(RegisterData data) async {
    emit(RegisterLoadingState());

    var eitherValue = await repository.register(data);

    //TODO: Improve UX, Failure system
    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(RegisterErrorState(message: "Server unreachable"))
            : emit(RegisterErrorState(message: failure.properties.first)),
        (logged) => logged.isNotEmpty
            ? emit(RegisterSuccessState(message: logged))
            : emit(RegisterErrorState(message: "Campos Inválidos")));
  }

  Future<List<Province>> getProvinces() async {
    var eitherValue = await repository.getProvinces();

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(RegisterErrorState(message: "Server unreachable"))
            : emit(RegisterErrorState(message: failure.properties.first)),
        (provinces) => provinces != null
            ? emit(RegisterInitialState(provinces: provinces))
            : emit(
                RegisterErrorState(message: "No hay provincias disponibles")));
  }

  Future<List<Municipe>> getMunicipeByProvinceId(String id) async {

    var eitherValue = await repository.getMunicipes(id);

    List<Municipe> result = [];

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(RegisterErrorState(message: "Server unreachable"))
            : emit(RegisterErrorState(message: failure.properties.first)),
        (municipes) => municipes != null
            ? result = municipes
            : emit(
                RegisterErrorState(message: "No hay provincias disponibles")));

    return result;
  }


}
