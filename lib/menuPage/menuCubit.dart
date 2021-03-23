

import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/menuPage/menuState.dart';

class MenuCubit extends Cubit<MenuState>{
  MenuCubit() : super(MenuStateInitial());

}