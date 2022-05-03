import 'package:articles_app_tdd/features/article/domain/use_case/article_use_case.dart';
import 'package:articles_app_tdd/features/article/preserntation/bloc/article_state.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleBloc extends Cubit<ArticleState> {
  final ArticleUseCase? _useCase;
  ArticleBloc(ArticleUseCase useCase)
      : _useCase = useCase,
        super(ArticleEmpty());

  Future<void> getArticleDetail(ArticleModel articleModel) async {
    emit(ArticleLoading());
    (await _useCase!.call(articleModel))!.fold(
      (error) => emit(ArticleError("Error")),
      (data) => emit(ArticleLoaded(data)),
    );
  }
}
