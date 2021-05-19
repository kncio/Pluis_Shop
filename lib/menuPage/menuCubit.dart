import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/menuPage/MenuRepository.dart';
import 'package:pluis_hv_app/menuPage/menuState.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuPageRepository repository;

  MenuCubit({this.repository}) : super(MenuStateInitial());



  Future<void> loadGenres() async {
    emit(MenuStateLoading());
    var eitherValue = await repository.loadGenres();

    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(MenuStateError("Server unreachable"))
            : emit(MenuStateError(failure.properties.first)),
        (genres) => genres != null
            ? emit(MenuStateLoaded(genres))
            : emit(MenuStateError("No hay información disponible")));
  }

  Future<void> setSuccess() async {
    emit(MenuStateSuccess());
  }
}
