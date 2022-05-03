import 'package:articles_app_tdd/core/platform/network_info.dart';
import 'package:articles_app_tdd/features/article/data/data_source/local_data_source/article_local_data_source.dart';
import 'package:articles_app_tdd/features/article/data/data_source/remote_data_source/article_remote_data_source.dart';
import 'package:articles_app_tdd/features/article/data/repository_impl/article_repository_impl.dart';
import 'package:articles_app_tdd/features/article/domain/repository/article_repository.dart';
import 'package:articles_app_tdd/features/article/domain/use_case/article_use_case.dart';
import 'package:articles_app_tdd/features/articles/data/data_source/local_data_source/articles_local_data_source.dart';
import 'package:articles_app_tdd/features/articles/data/data_source/remote_data_source/articles_remote_data_source.dart';
import 'package:articles_app_tdd/features/articles/data/repository_impl/get_article_repository_impl.dart';
import 'package:articles_app_tdd/features/articles/domain/repository/article_repository.dart';
import 'package:articles_app_tdd/features/articles/domain/use_case/get_article_use_case.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.I;

Future init() async {
  ///Data Source
  //Articles
  sl.registerLazySingleton<ArticlesRemoteDataSource>(
      () => ArticlesRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<ArticlesLocalDataSource>(
      () => ArticlesLocalDataSourceImpl(sl()));

  //Article
  sl.registerLazySingleton<ArticleRemoteDataSource>(
      () => ArticleRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ArticleLocalDataSource>(
      () => ArticleLocalDataSourceImpl(sl()));

  //Network Info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  ///Repository
  //Articles
  sl.registerLazySingleton<ArticlesRepository>(() => ArticlesRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  //Article
  sl.registerLazySingleton<ArticleRepository>(() => ArticleRepositoryImpl(
      articleLocalDataSource: sl(),
      articleRemoteDataSource: sl(),
      networkInfo: sl()));

  ///Use Cases
  //Articles
  sl.registerLazySingleton(() => GetArticles(sl()));

  //Article
  sl.registerLazySingleton(() => ArticleUseCase(sl()));

  ///Dependency
  //Shared Preferences
  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPref);

  //Data Connection Checker
  sl.registerLazySingleton<DataConnectionChecker>(
      () => DataConnectionChecker());

  //http
  sl.registerLazySingleton(() => http.Client());
}
