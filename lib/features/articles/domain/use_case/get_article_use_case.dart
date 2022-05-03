import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:articles_app_tdd/core/use_case/usecase.dart';
import 'package:articles_app_tdd/features/articles/domain/entity/article.dart';
import 'package:articles_app_tdd/features/articles/domain/repository/article_repository.dart';
import 'package:dartz/dartz.dart';

class GetArticles implements UseCase<List<Article>, NoParams> {
  final ArticlesRepository _articleRepository;
  GetArticles(this._articleRepository);

  @override
  Future<Either<Failure, List<Article>>?> call(NoParams params) {
    return _articleRepository.getArticles();
  }
}
