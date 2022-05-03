import 'package:articles_app_tdd/features/article/preserntation/pages/articles_view.dart';
import 'package:articles_app_tdd/features/articles/preserntation/bloc/articles_bloc.dart';
import 'package:articles_app_tdd/features/articles/preserntation/bloc/articles_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/mode_switcher.dart';

class ArticlesView extends StatelessWidget {
  const ArticlesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        elevation: 0.0,
        actions: const [ModeSwitcher()],
      ),
      body: BlocBuilder<ArticlesBloc, ArticlesState>(
        builder: (BuildContext context, ArticlesState state) {
          if (state is Loaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ArticleView(),
                        settings: RouteSettings(
                          arguments: state.articles[index],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.articles[index].title ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(state.articles[index].body ?? ''),
                    ],
                  ),
                ),
              ),
              itemCount: state.articles.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.indigo,
              ),
            );
          }
          if (state is Error) {
            return Center(
              child: Text(state.message),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
