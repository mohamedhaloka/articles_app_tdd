import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:articles_app_tdd/core/platform/network_info.dart';
import 'package:articles_app_tdd/features/article/data/data_source/local_data_source/article_local_data_source.dart';
import 'package:articles_app_tdd/features/article/data/data_source/remote_data_source/article_remote_data_source.dart';
import 'package:articles_app_tdd/features/article/domain/repository/article_repository.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:dartz/dartz.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource? articleRemoteDataSource;
  final ArticleLocalDataSource? articleLocalDataSource;
  final NetworkInfo? networkInfo;

  ArticleRepositoryImpl(
      {this.networkInfo,
      this.articleLocalDataSource,
      this.articleRemoteDataSource});

  @override
  Future<Either<Failure, ArticleModel>> getArticleDetail(String id) async {
    if (await networkInfo!.isConnected) {
      try {
        final result = await articleRemoteDataSource!.getArticleDetail(id);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await articleLocalDataSource!.getArticleDetail();
        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
