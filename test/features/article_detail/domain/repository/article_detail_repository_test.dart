import 'package:articles_app_tdd/core/error/failure.dart';
import 'package:articles_app_tdd/core/use_case/usecase.dart';
import 'package:articles_app_tdd/features/article/domain/repository/article_repository.dart';
import 'package:articles_app_tdd/features/article/domain/use_case/article_use_case.dart';
import 'package:articles_app_tdd/features/articles/data/model/article_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleDetailRepository extends Mock
    implements ArticleRepository {}

void main() {
  MockArticleDetailRepository? mockArticleDetailRepository;
  ArticleUseCase? articleDetailUseCase;
  setUp(() {
    mockArticleDetailRepository = MockArticleDetailRepository();
    articleDetailUseCase = ArticleUseCase(mockArticleDetailRepository);
  });

  const article = ArticleModel(id: 0, userID: 0, body: 'body', title: 'title');
  const tArticleId = '0';

  const failure = Failure();

  test('should get article detail model when repository succeeded', () async {
    //arrange
    when(() => mockArticleDetailRepository!.getArticleDetail(tArticleId))
        .thenAnswer((_) async => const Right(article));
    //act
    final result = await articleDetailUseCase!(const ArticleParam(tArticleId));
    //assert
    verify(() => mockArticleDetailRepository!.getArticleDetail(tArticleId));
    verifyNoMoreInteractions(mockArticleDetailRepository);
    expect(result, equals(const Right(article)));
  });

  test('should return failure when has error', () async {
    //arrange
    when(() => mockArticleDetailRepository!.getArticleDetail(tArticleId))
        .thenAnswer((_) async => const Left(failure));
    //act
    final result = await articleDetailUseCase!(const ArticleParam(tArticleId));
    //assert
    verify(() => mockArticleDetailRepository!.getArticleDetail(tArticleId));
    verifyNoMoreInteractions(mockArticleDetailRepository);
    expect(result, equals(const Left(failure)));
  });
}
