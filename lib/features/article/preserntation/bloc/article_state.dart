import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:equatable/equatable.dart';

abstract class ArticleState extends Equatable {
  final List? properties;
  const ArticleState([this.properties]);

  @override
  List<Object?> get props => properties!;
}

class ArticleEmpty extends ArticleState {}
class ArticleLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final ArticleModel article;
  ArticleLoaded(this.article) : super([article]);
}

class ArticleError extends ArticleState {
  final String msg;
  ArticleError(this.msg) : super([msg]);
}
