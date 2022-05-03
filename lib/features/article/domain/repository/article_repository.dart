import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:dartz/dartz.dart';

abstract class ArticleRepository {
  Future<Either<Failure, ArticleModel>> getArticleDetail(String id);
}
