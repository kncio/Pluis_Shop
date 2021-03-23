import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/homePage/homePageStates.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial());

  Future<void> initialState() {

  }

}
