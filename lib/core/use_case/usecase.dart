import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Out, Params> {
  Future<Either<Failure, Out>?> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class ArticleParam extends Equatable {
  final String? id;
  const ArticleParam(this.id);
  @override
  List<Object?> get props => [];
}
