import 'package:floor/floor.dart';

@entity
class Todo {
  Todo({required this.id, required this.name, this.checked = false});

  @primaryKey
  final int? id;

  final String name;
  bool checked;
}

@entity
class Comment {
  @primaryKey
  final int? commentId;

  final String text;

  @ForeignKey(childColumns: ['postID'], parentColumns: ['id'], entity: Todo)
  final int postId;

  Comment({this.commentId, required this.text, required this.postId});
}
