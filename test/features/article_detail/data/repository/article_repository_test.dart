import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:articles_app_tdd/core/platform/network_info.dart';
import 'package:articles_app_tdd/features/article/data/data_source/local_data_source/article_local_data_source.dart';
import 'package:articles_app_tdd/features/article/data/data_source/remote_data_source/article_remote_data_source.dart';
import 'package:articles_app_tdd/features/article/data/repository_impl/article_repository_impl.dart';
import 'package:articles_app_tdd/features/article/domain/repository/article_repository.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleRemoteDataSource extends Mock
    implements ArticleRemoteDataSource {}

class MockArticleLocalDataSource extends Mock
    implements ArticleLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockArticleRemoteDataSource? remoteDataSource;
  MockArticleLocalDataSource? localDataSource;
  MockNetworkInfo? networkInfo;
  ArticleRepository? articleRepository;

  setUp(() {
    remoteDataSource = MockArticleRemoteDataSource();
    localDataSource = MockArticleLocalDataSource();
    networkInfo = MockNetworkInfo();
    articleRepository = ArticleRepositoryImpl(
        networkInfo: networkInfo,
        articleLocalDataSource: localDataSource,
        articleRemoteDataSource: remoteDataSource);
  });

  const tArticleId = '1';
  const articleModel = ArticleModel(id: 0, userID: 0, title: '', body: '');

  group('CheckNetworkConnection', () {
    test('should return True when connection success', () async {
      //arrange
      when(() => networkInfo!.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource!.getArticleDetail(tArticleId))
          .thenAnswer((_) async => articleModel);
      //act
      await articleRepository!.getArticleDetail(tArticleId);
      //assert
      verify(() => networkInfo!.isConnected);
      verifyNoMoreInteractions(networkInfo);
    });
  });

  group('NetworkConnection is true', () {
    setUp(() {
      when(() => networkInfo!.isConnected).thenAnswer((_) async => true);
    });

    test('should return article detail when connection is true', () async {
      //arrange
      when(() => remoteDataSource!.getArticleDetail(tArticleId))
          .thenAnswer((_) async => articleModel);
      //act
      final result = await articleRepository!.getArticleDetail(tArticleId);
      //assert
      expect(result, equals(const Right(articleModel)));
    });

    test('should return [ServerFailure] when remote throw error', () async {
      //arrange
      when(() => remoteDataSource!.getArticleDetail(tArticleId))
          .thenThrow(ServerException());
      //act
      final result = await articleRepository!.getArticleDetail(tArticleId);
      //assert
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('NetworkConnection is false', () {
    setUp(() {
      when(() => networkInfo!.isConnected).thenAnswer((_) async => false);
    });

    test('should return article detail from cache when connection is false',
        () async {
      //arrange
      when(() => localDataSource!.getArticleDetail())
          .thenAnswer((_) async => articleModel);
      //act
      final result = await articleRepository!.getArticleDetail(tArticleId);
      //assert
      verify(()=>localDataSource!.getArticleDetail());
      verifyNoMoreInteractions(localDataSource);
      expect(result, equals(const Right(articleModel)));
    });

    test('should return [CacheFailure] when local source throw exception',
        () async {
      //arrange
      when(() => localDataSource!.getArticleDetail())
          .thenThrow(CacheException());
      //act
      final result = await articleRepository!.getArticleDetail(tArticleId);
      //assert
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
