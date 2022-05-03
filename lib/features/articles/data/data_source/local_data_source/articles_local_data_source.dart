import 'dart:convert';
import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArticlesLocalDataSource {
  Future<List<ArticleModel>> getLastArticlesData();

  Future<void> cacheLastData(List<ArticleModel> articles);
}

const String cacheArticlesKey = 'CACHED_ARTICLES_LIST';

class ArticlesLocalDataSourceImpl implements ArticlesLocalDataSource {
  final SharedPreferences _sharedPreferences;
  ArticlesLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<List<ArticleModel>> getLastArticlesData() async {
    final result = _sharedPreferences.getString(cacheArticlesKey);
    if (result != null) {
      final list = List.from(jsonDecode(result));
      List<ArticleModel> articles = <ArticleModel>[];
      for (var article in list) {
        articles.add(ArticleModel.fromJson(article));
      }
      return articles;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheLastData(List<ArticleModel> articles) async {
    final result = json.encode(articles);
    await _sharedPreferences.setString(cacheArticlesKey, result);
  }
}
