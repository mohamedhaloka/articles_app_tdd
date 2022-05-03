import 'dart:convert';
import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/features/article/data/data_source/remote_data_source/article_remote_data_source.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import '../../../articles/data/model/article_model_test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient? mockHttpClient;
  ArticleRemoteDataSource? articleRemoteDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    articleRemoteDataSource = ArticleRemoteDataSourceImpl(mockHttpClient);
  });

  group('GetArticleData', () {
    const tArticleId = '1';

    test('should call GET request when cal method', () async {
      //arrange
      Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
      when(() => mockHttpClient!.get(url))
          .thenAnswer((_) async => http.Response(fixture('article.json'), 200));
      //act
      await articleRemoteDataSource!.getArticleDetail(tArticleId);
      //assert
      verify(() => mockHttpClient!.get(url));
    });

    test('should return [SUCCESS] when response status code is 200', () async {
      //arrange
      Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
      when(() => mockHttpClient!.get(url))
          .thenAnswer((_) async => http.Response(fixture('article.json'), 200));
      //act
      final result =
          await articleRemoteDataSource!.getArticleDetail(tArticleId);
      final articleJson = json.decode(fixture('article.json'));
      final articleModel = ArticleModel.fromJson(articleJson);
      //assert
      expect(result, articleModel);
    });

    test('should throw [SERVER EXCEPTION] when response status code is not 200',
        () async {
      //arrange
      Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
      when(() => mockHttpClient!.get(url))
          .thenAnswer((_) async => http.Response('', 400));
      //act
      final result = articleRemoteDataSource!.getArticleDetail(tArticleId);
      //assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });
}
