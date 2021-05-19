import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/menuPage/MenuRepository.dart';
import 'package:pluis_hv_app/menuPage/menuState.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuPageRepository repository;

  MenuCubit({this.repository}) : super(MenuStateInitial());

  Future<void> getCategoryByGender(String genderId) async {
    emit(MenuStateLoading());
    var eitherValue = await repository.getCategoryByGender(genderId);
    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(MenuStateError("Server Unreachable"))
            : emit(MenuStateError(failure.properties.first)),
        (categories) => categories != null
            ? emit(MenuStateSuccess(categories: categories))
            : emit(MenuStateError("Error desconocido")));
  }

  Future<void> loadGenres() async {
    emit(MenuStateLoading());
    var eitherValue = await repository.loadGenres();

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(MenuStateError("Server unreachable"))
            : emit(MenuStateError(failure.properties.first)),
        (genres) => genres != null
            ? emit(MenuStateLoading())
            : emit(MenuStateError("No hay información disponible")));
  }
}
