import 'package:articles_app_tdd/features/articles/domain/entity/article.dart';

class ArticleModel extends Article {
  const ArticleModel({String? title, String? body, int? userID, int? id})
      : super(title: title, body: body, userId: userID, id: id);

  factory ArticleModel.fromJson(Map<String, dynamic> data) => ArticleModel(
        title: data['title'],
        body: data['body'],
        userID: data['userId'],
        id: data['id'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'id': id,
        'userId': userId,
      };
}
