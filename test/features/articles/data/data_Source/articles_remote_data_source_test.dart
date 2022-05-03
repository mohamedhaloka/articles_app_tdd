import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/features/articles/data/data_source/remote_data_source/articles_remote_data_source.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../model/article_model_test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient? mockHttpClient;
  ArticlesRemoteDataSourceImpl? dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ArticlesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getArticles', () {
    test('should call http GEt request when call it', () async {
      //arrange
      Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      when(() => mockHttpClient!.get(url)).thenAnswer(
          (_) async => http.Response(fixture('cache_data.json'), 200));
      //act
      await dataSource!.getArticles();
      //assert
      verify(() => mockHttpClient!.get(url));
    });

    test('should call data that equal actual data when call it', () async {
      //arrange
      Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      when(() => mockHttpClient!.get(url, headers: any(named: 'headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('cache_data.json'), 200));
      //act
      final result = await dataSource!.getArticles();
      //assert
      expect(result, isA<List<ArticleModel>>());
    });

    test('should throw exception when call is failed', () async {
      //arrange
      Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      when(() => mockHttpClient!.get(url, headers: any(named: 'headers')))
          .thenAnswer(
              (_) async => http.Response('{status:200 ,\'msg\':error}', 404));
      //act
      final result = dataSource!.getArticles();
      //assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
