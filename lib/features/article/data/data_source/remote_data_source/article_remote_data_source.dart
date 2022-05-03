import 'dart:convert';

import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';

abstract class ArticleRemoteDataSource {
  Future<ArticleModel> getArticleDetail(String id);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final http.Client? client;
  const ArticleRemoteDataSourceImpl(this.client);

  @override
  Future<ArticleModel> getArticleDetail(String id) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
    http.Response response = await client!.get(url);

    if (response.statusCode == 200) {
      final decodeResponse = json.decode(response.body);
      return ArticleModel.fromJson(decodeResponse);
    } else {
      throw ServerException();
    }
  }
}
