import 'dart:convert';

import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:http/http.dart' as http;

abstract class ArticlesRemoteDataSource {
  Future<List<ArticleModel>> getArticles();
}

class ArticlesRemoteDataSourceImpl implements ArticlesRemoteDataSource {
  http.Client? client;
  ArticlesRemoteDataSourceImpl({this.client});

  @override
  Future<List<ArticleModel>> getArticles() async {
    Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final result = await client!.get(url);
    if (result.statusCode == 200) {
      final responseDecoded = json.decode(result.body);
      List<ArticleModel> articles = <ArticleModel>[];
      for (var article in responseDecoded) {
        articles.add(ArticleModel.fromJson(article));
      }
      return articles;
    } else {
      throw ServerException();
    }
  }
}
