import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:articles_app_tdd/core/platform/network_info.dart';
import 'package:articles_app_tdd/features/articles/data/data_source/local_data_source/articles_local_data_source.dart';
import 'package:articles_app_tdd/features/articles/data/data_source/remote_data_source/articles_remote_data_source.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:articles_app_tdd/features/articles/data/repository_impl/get_article_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticlesRemoteDataSource extends Mock
    implements ArticlesRemoteDataSource {}

class MockArticlesLocalDataSource extends Mock
    implements ArticlesLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  ArticlesRepositoryImpl? articlesRepositoryImpl;
  MockArticlesLocalDataSource? mockArticlesLocalDataSource;
  MockArticlesRemoteDataSource? mockArticlesRemoteDataSource;
  MockNetworkInfo? mockNetworkInfo;

  const articlesModel = [
    ArticleModel(title: 'Text', id: 0, userID: 1, body: 'Text Body'),
    ArticleModel(title: 'Text', id: 0, userID: 1, body: 'Text Body'),
    ArticleModel(title: 'Text', id: 0, userID: 1, body: 'Text Body'),
  ];

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockArticlesRemoteDataSource = MockArticlesRemoteDataSource();
    mockArticlesLocalDataSource = MockArticlesLocalDataSource();
    articlesRepositoryImpl = ArticlesRepositoryImpl(
      remoteDataSource: mockArticlesRemoteDataSource!,
      localDataSource: mockArticlesLocalDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });

  test('device is Connected', () {
    //append
    when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
    when(() => mockArticlesRemoteDataSource!.getArticles())
        .thenAnswer((_) async => articlesModel);
    when(() => mockArticlesLocalDataSource!.cacheLastData(any()))
        .thenAnswer((_) async => {});
    //act
    articlesRepositoryImpl!.getArticles();
    //assert
    verify(() => mockNetworkInfo!.isConnected);
  });

  group('device is online', () {
    setUp(() {
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
    });

    test('should return remote data source when call is success', () async {
      //append
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      when(() => mockArticlesRemoteDataSource!.getArticles())
          .thenAnswer((_) async => articlesModel);
      when(() => mockArticlesLocalDataSource!.cacheLastData(any()))
          .thenAnswer((_) async => {});
      //act
      final result = await articlesRepositoryImpl!.getArticles();
      //assert
      verify(() => mockArticlesRemoteDataSource!.getArticles());
      expect(result, equals(const Right(articlesModel)));
    });

    test('should cache data when call is success', () async {
      //append
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      when(() => mockArticlesRemoteDataSource!.getArticles())
          .thenAnswer((_) async => articlesModel);
      when(() => mockArticlesLocalDataSource!.cacheLastData(any()))
          .thenAnswer((_) async => {});
      //act
      await articlesRepositoryImpl!.getArticles();
      //assert
      verify(() => mockArticlesRemoteDataSource!.getArticles());
      verify(() => mockArticlesLocalDataSource!.cacheLastData(any()));
    });

    test('should return server exception when call is failed', () async {
      //append
      when(() => mockArticlesRemoteDataSource!.getArticles()).thenThrow(ServerException());
      //act
      final result = await articlesRepositoryImpl!.getArticles();
      //assert
      // verify(() => mockArticlesRemoteDataSource!.getArticles());
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
    });

    test('should return cache data  when cache data is present', () async {
      //append
      when(() => mockArticlesLocalDataSource!.getLastArticlesData())
          .thenAnswer((_) async => articlesModel);
      //act
      final result = await articlesRepositoryImpl!.getArticles();
      //assert
      verify(() => mockArticlesLocalDataSource!.getLastArticlesData());
      verifyNoMoreInteractions(mockArticlesLocalDataSource);
      expect(result, equals(const Right(articlesModel)));
    });

    test('should return CacheFailure when there is no data', () async {
      //append
      when(() => mockArticlesLocalDataSource!.getLastArticlesData())
          .thenThrow(CacheException());
      //act
      final result = await articlesRepositoryImpl!.getArticles();
      //assert
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
