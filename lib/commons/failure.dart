import 'package:equatable/equatable.dart';

///General failure
class Failure extends Equatable {
  final List<dynamic> properties;
  Failure(this.properties);

  @override
  List<Object> get props => properties;
}

class ServerFailure extends Failure {
  ServerFailure(List properties) : super(properties);
}

class LocalAccessFailure extends Failure {
  LocalAccessFailure(List properties) : super(properties);
}
