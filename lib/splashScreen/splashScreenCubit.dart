import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/splashScreen/SplashScreenRepository.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenStates.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {

  final SplashScreenRepository initializeApp;

  SplashScreenCubit({this.initializeApp}) : super(SplashScreenInitialState());

  Future<void> start() async {
    emit(SplashScreenAnimationStartState("Iniciando Animación"));
    var eitherValue = await initializeApp.initializeApp();

    eitherValue.fold(
      (failure) => emit(SplashScreenError(failure.properties.first)),
      (credentials) {
        emit(SplashScreenAppInitializedSuccess());
      },
    );
  }

  Future<void> startAnimation()async {
    emit(SplashScreenAnimationStartState("Iniciando Animación"));
  }


}
