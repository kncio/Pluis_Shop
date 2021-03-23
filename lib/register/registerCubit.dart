

import 'package:bloc/bloc.dart';
import 'package:pluis_hv_app/register/registerState.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

}