import 'dart:convert';

import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:articles_app_tdd/core/platform/network_info.dart';
import 'package:articles_app_tdd/features/article/data/data_source/local_data_source/article_local_data_source.dart';
import 'package:articles_app_tdd/features/article/data/data_source/remote_data_source/article_remote_data_source.dart';
import 'package:articles_app_tdd/features/article/domain/repository/article_repository.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:dartz/dartz.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource? remoteData;
  final ArticleLocalDataSource? localData;
  final NetworkInfo? networkInfo;

  ArticleRepositoryImpl({this.networkInfo, this.localData, this.remoteData});

  @override
  Future<Either<Failure, ArticleModel>> getArticleDetail(
      ArticleModel articleModel) async {
    String articleId = (articleModel.id ?? 0).toString();
    if (await networkInfo!.isConnected) {
      try {
        final result = await remoteData!.getArticleDetail(articleId.toString());
        localData!.cacheArticleDetail(articleModel);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await localData!.getArticleDetail(articleId);
        final articleJson = json.decode(result[articleId]);
        return Right(ArticleModel.fromJson(articleJson));
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
