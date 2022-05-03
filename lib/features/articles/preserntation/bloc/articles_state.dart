import 'package:articles_app_tdd/features/articles/domain/entity/article.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ArticlesState extends Equatable {
  final List? properties;
  const ArticlesState([this.properties]);

  @override
  List<Object?> get props => properties!;
}

class Empty extends ArticlesState {}

class Loading extends ArticlesState {}

class Loaded extends ArticlesState {
  final List<Article> articles;

  Loaded({required this.articles}) : super([articles]);
}

class Error extends ArticlesState {
  final String message;

  Error({required this.message}) : super([message]);
}
