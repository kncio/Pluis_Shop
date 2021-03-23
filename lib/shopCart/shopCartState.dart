import 'package:equatable/equatable.dart';

abstract class ShopCartState extends Equatable{
  const ShopCartState();

  @override
  List<Object> get props => [];
}

class ShopCartInitialState extends ShopCartState{

}