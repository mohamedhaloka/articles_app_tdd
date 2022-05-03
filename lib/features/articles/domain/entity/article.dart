import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String? title, body;
  final int? userId, id;

  const Article({this.id, this.title, this.body, this.userId});

  @override
  List<Object?> get props => [id, title, body, userId];
}
