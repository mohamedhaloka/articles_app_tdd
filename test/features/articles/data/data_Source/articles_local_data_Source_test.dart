import 'dart:convert';
import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/features/articles/data/data_source/local_data_source/articles_local_data_source.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/article_model_test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences? mockSharedPreferences;
  ArticlesLocalDataSourceImpl? dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ArticlesLocalDataSourceImpl(mockSharedPreferences!);
  });

  group('getDataFromCache', () {
    test('should return data from cache when it\'s found', () async {
      //append
      when(() => mockSharedPreferences!.getString(cacheArticlesKey))
          .thenReturn(json.encode(fixture('cache_data.json')));
      //act
      final result = await dataSource!.getLastArticlesData();
      final t = json.decode(fixture('cache_data.json'));
      List<ArticleModel> tArticles = <ArticleModel>[];
      for (var article in t) {
        tArticles.add(ArticleModel.fromJson(article));
      }
      //assert
      expect(result, equals(tArticles));
    });

    test('should throw CACHE EXCEPTION when no data found - null', () async {
      //append
      when(() => mockSharedPreferences!.getString(cacheArticlesKey))
          .thenReturn(null);
      //act
      final result = dataSource!.getLastArticlesData();
      //assert
      expect(() => result, throwsA(isA<CacheException>()));
    });
  });

  group('saveDataInCache', () {
    final articles = <ArticleModel>[
      const ArticleModel(title: 'test', body: 'test1', userID: 1, id: 0),
      const ArticleModel(title: 'test', body: 'test2', userID: 2, id: 1),
      const ArticleModel(title: 'test', body: 'test3', userID: 3, id: 2),
    ];

    test('should save data in cache', () async {
      //append
      List<Map<String, dynamic>> articlesMap = <Map<String, dynamic>>[];
      for (var article in articles) {
        articlesMap.add(article.toJson());
      }
      when(() => mockSharedPreferences!.setString(cacheArticlesKey, any()))
          .thenAnswer((_) async => true);

      //act
      await dataSource!.cacheLastData(articles);

      //assert
      verify(() => mockSharedPreferences!.setString(cacheArticlesKey, any()));
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });
}
