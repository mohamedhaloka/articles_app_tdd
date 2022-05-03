import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:articles_app_tdd/core/use_case/usecase.dart';
import 'package:articles_app_tdd/features/article/domain/repository/article_repository.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:dartz/dartz.dart';

class ArticleUseCase implements UseCase<ArticleModel, ArticleParam> {
  final ArticleRepository? _repository;
  ArticleUseCase(this._repository);

  @override
  Future<Either<Failure, ArticleModel>?> call(ArticleParam params) {
    return _repository!.getArticleDetail(params.id.toString());
  }
}
