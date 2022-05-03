import 'package:articles_app_tdd/features/articles/domain/repository/article_repository.dart';
import 'package:articles_app_tdd/features/articles/preserntation/bloc/articles_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticlesBloc extends Cubit<ArticlesState> {
  ArticlesRepository? articleRepository;

  ArticlesBloc({required this.articleRepository})
      : assert(articleRepository != null),
        super(Empty());

  Future<void> getArticles() async {
    emit(Loading());
    (await articleRepository!.getArticles())!.fold((l) {
      emit(Error(message: "Error get article"));
    }, (articles) {
      emit(Loaded(articles: articles));
    });
  }
}
