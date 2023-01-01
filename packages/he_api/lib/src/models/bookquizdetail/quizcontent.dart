import 'package:json_annotation/json_annotation.dart';

part 'quizcontent.g.dart';

@JsonSerializable()
class QuizContent {
  QuizContent({
    required this.html,
    required this.layout,
    required this.currentpage,
    required this.state,
    required this.nextpage,
    this.quizlist
  });
  String html;
  int layout;
  int currentpage;
  String state;
  int nextpage;
  List<QuizContent>? quizlist;

  factory QuizContent.fromJson(Map<String, dynamic> json) =>
      _$QuizContentFromJson(json);
}
