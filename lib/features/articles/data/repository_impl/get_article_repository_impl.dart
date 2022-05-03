import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:articles_app_tdd/core/platform/network_info.dart';
import 'package:articles_app_tdd/features/articles/data/data_source/local_data_source/articles_local_data_source.dart';
import 'package:articles_app_tdd/features/articles/data/data_source/remote_data_source/articles_remote_data_source.dart';
import 'package:articles_app_tdd/features/articles/domain/entity/article.dart';
import 'package:articles_app_tdd/features/articles/domain/repository/article_repository.dart';
import 'package:dartz/dartz.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesLocalDataSource localDataSource;
  final ArticlesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  ArticlesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Article>>?> getArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getArticles();
        localDataSource.cacheLastData(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
     try{
       final data = await localDataSource.getLastArticlesData();
       return Right(data);
     } on CacheException {
       return Left(CacheFailure());
     }
    }
  }
}
