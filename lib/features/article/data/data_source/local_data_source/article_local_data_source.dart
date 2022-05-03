import 'dart:convert';
import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArticleLocalDataSource {
  Future<Map<String, dynamic>> getArticleDetail(String id);

  Future<void> cacheArticleDetail(ArticleModel articleModel);
}

const String cacheArticle = 'CACHE_ARTICLE';

class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  final SharedPreferences? _sharedPreferences;
  ArticleLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<Map<String, dynamic>> getArticleDetail(String id) async {
    final result = _sharedPreferences!.getString(cacheArticle);
    if (result != null) {
      final decodeData = json.decode(result);
      return Map<String, dynamic>.from(json.decode(decodeData));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheArticleDetail(ArticleModel articleModel) async {
    String articleId = (articleModel.id ?? 0).toString();
    final articleString = json.encode(articleModel.toJson());
    Map articleMap = {};
    try {
      articleMap = await getArticleDetail(articleId);
    } on CacheException {}
    articleMap[articleId] = articleString;
    await _sharedPreferences!.setString(cacheArticle, json.encode(articleMap));
  }
}
