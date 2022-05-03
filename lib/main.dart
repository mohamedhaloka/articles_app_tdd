import 'package:articles_app_tdd/dependency_injection_container.dart';
import 'package:articles_app_tdd/features/articles/preserntation/bloc/articles_bloc.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/articles/preserntation/pages/articles_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) =>
                  ArticlesBloc(articleRepository: sl())..getArticles())
        ],
        child: DynamicTheme(
          builder: (BuildContext context, ThemeData theme) => MaterialApp(
            title: 'Articles',
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: const ArticlesView(),
          ),
          themeCollection: ThemeCollection(themes: {
            0: ThemeData(
                primarySwatch: Colors.indigo, brightness: Brightness.light),
            1: ThemeData(
                primarySwatch: Colors.indigo, brightness: Brightness.dark),
          }),
        ));
  }
}
