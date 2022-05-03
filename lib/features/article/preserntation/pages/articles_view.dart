import 'package:articles_app_tdd/dependency_injection_container.dart';
import 'package:articles_app_tdd/features/article/preserntation/bloc/article_bloc.dart';
import 'package:articles_app_tdd/features/article/preserntation/bloc/article_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (_) => ArticleBloc(sl())..getArticleDetail(id),
      child: const ArticleDetail(),
    );
  }
}

class ArticleDetail extends StatelessWidget {
  const ArticleDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(),
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
          builder: (BuildContext context, ArticleState state) {
        if (state is ArticleLoaded) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.article.title ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    state.article.body ?? '',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else if (state is ArticleError) {
          return Text(state.msg);
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleBloc, ArticleState>(
        builder: (BuildContext context, ArticleState state) {
      if (state is ArticleLoaded) {
        return Text(state.article.title ?? '');
      }
      return const Text('');
    });
  }
}
