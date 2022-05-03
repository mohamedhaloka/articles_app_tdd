

import 'package:equatable/equatable.dart';

class Failure extends Equatable{
  final List<Object>? properties ;
  const Failure([this.properties]): super();
  @override
  List<Object?> get props => properties ?? [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
