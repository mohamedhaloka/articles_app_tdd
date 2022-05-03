import 'package:articles_app_tdd/core/use_case/usecase.dart';
import 'package:articles_app_tdd/features/articles/domain/entity/article.dart';
import 'package:articles_app_tdd/features/articles/domain/repository/article_repository.dart';
import 'package:articles_app_tdd/features/articles/domain/use_case/get_article_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticlesRepository extends Mock implements ArticlesRepository {}

void main() {
  MockArticlesRepository? mockArticlesRepository;
  GetArticles? useCase;
  setUp(() {
    mockArticlesRepository = MockArticlesRepository();
    useCase = GetArticles(mockArticlesRepository!);
  });

  const article = Article(id: 0, title: 'ww', body: '5', userId: 5);
  final articles = [article, article, article];

  test('should get list of article', () async {
    //arrange
    when(() => mockArticlesRepository?.getArticles())
        .thenAnswer((_) async => Right(articles));
    //act
    final result = await useCase!(NoParams());
    //assert
    expect(result, Right(articles));
    verify(() => mockArticlesRepository!.getArticles()).called(1);
    verifyNoMoreInteractions(mockArticlesRepository);
  });
}

Future getdata() async {}
