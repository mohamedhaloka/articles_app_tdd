import 'dart:convert';
import 'dart:math';

import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/features/article/data/data_source/local_data_source/article_local_data_source.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../articles/data/model/article_model_test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences? mockSharedPreferences;
  ArticleLocalDataSource? articleLocalDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    articleLocalDataSource = ArticleLocalDataSourceImpl(mockSharedPreferences);
  });

  group('GetArticleData', () {
    test('should get article data when has data in local', () async {
      //arrange
      when(() => mockSharedPreferences!.getString(cacheArticle))
          .thenReturn(json.encode(fixture('article.json')));
      //act
      final result = await articleLocalDataSource!.getArticleDetail();
      final articleModel =
          ArticleModel.fromJson(json.decode(fixture('article.json')));
      //assert
      expect(result, equals(articleModel));
    });

    test('should get [CACHE EXCEPTION] when does\'nt has data', () async {
      //arrange
      when(() => mockSharedPreferences!.getString(cacheArticle))
          .thenReturn(null);
      //act
      final result = articleLocalDataSource!.getArticleDetail();
      //assert
      expect(() => result, throwsA(isA<CacheException>()));
    });
  });

  group('SaveArticleData', () {
    const article = ArticleModel(id: 0, userID: 0, title: '', body: '');

    test('should save data when method is called', () async {
      //arrange
      when(() => mockSharedPreferences!.setString(cacheArticle, any()))
          .thenAnswer((_) async => true);
      //act
      await articleLocalDataSource!.cacheArticleDetail(article);
      //assert
      verify(() => mockSharedPreferences!.setString(cacheArticle, any()));
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });
}
