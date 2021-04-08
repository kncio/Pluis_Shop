

import 'package:equatable/equatable.dart';

abstract class SplashScreenState extends Equatable{
  @override
  List<Object> get props => [];

}

class SplashScreenInitialState extends SplashScreenState{
  
}

class SplashScreenAppInitializedSuccess extends SplashScreenState{

}

class SplashScreenError extends SplashScreenState{}