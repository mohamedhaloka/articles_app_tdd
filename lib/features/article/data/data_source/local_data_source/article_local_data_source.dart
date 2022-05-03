import 'dart:convert';
import 'package:articles_app_tdd/core/error/exception.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArticleLocalDataSource {
  Future<ArticleModel> getArticleDetail();

  Future<void> cacheArticleDetail(ArticleModel articleModel);
}

const String cacheArticle = 'CACHE_ARTICLE';

class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  final SharedPreferences? _sharedPreferences;
  ArticleLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<ArticleModel> getArticleDetail() async {
    final result = _sharedPreferences!.getString(cacheArticle);
    if (result != null) {
      final articleJson = json.decode(result);
      return ArticleModel.fromJson(json.decode(articleJson));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheArticleDetail(ArticleModel articleModel) async {
    final articleString = json.encode(articleModel.toJson());
    await _sharedPreferences!.setString(cacheArticle, articleString);
  }
}
