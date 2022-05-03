import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:articles_app_tdd/features/articles/domain/entity/article.dart';
import 'package:dartz/dartz.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<Article>>?> getArticles();
}
