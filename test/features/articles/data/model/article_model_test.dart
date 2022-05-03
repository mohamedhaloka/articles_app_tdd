import 'dart:convert';
import 'dart:io';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:articles_app_tdd/features/articles/domain/entity/article.dart';
import 'package:flutter_test/flutter_test.dart';

String fixture(String file) =>
    File('test/fixture/' + file).readAsStringSync();

void main() {
  final articleModel =
      ArticleModel(title: 'title', body: 'body', id: 0, userID: 1);

  test('Model should be a subclass of entity', () {
    //assert
    expect(articleModel, isA<Article>());
  });

  group('fromJson', () {
    test('should return model from json', () async {
      //append
      final Map<String, dynamic> data = json.decode(fixture('response.json'));
      //act
      ArticleModel article = ArticleModel.fromJson(data);
      //assert
      expect(article, articleModel);
    });
  });

  group('toJSon', () {
    test('should convert model to json', () async {
      //append
      Map<String, dynamic> article = articleModel.toJson();

      //act
      Map<String, dynamic> actualMap = {
        'title': 'title',
        'id': 0,
        'userId': 1,
        'body': 'body',
      };
      //assert
      expect(article, actualMap);
    });
  });
}
