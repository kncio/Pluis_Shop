

import 'package:equatable/equatable.dart';

abstract class SplashScreenState extends Equatable{
  @override
  List<Object> get props => [];

}

class SplashScreenInitialState extends SplashScreenState{
  
}

class SplashScreenAnimationStartState extends SplashScreenState{
  final String Message;

  SplashScreenAnimationStartState(this.Message);
}

class SplashScreenAppInitializedSuccess extends SplashScreenState{

}

class SplashScreenError extends SplashScreenState{
  final String errorMessage;

  SplashScreenError(this.errorMessage);
}