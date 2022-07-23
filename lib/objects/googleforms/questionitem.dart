import 'question.dart';

class QuestionItem {
  QuestionItem({
    this.question,
  });

  Question? question;

  factory QuestionItem.fromJson(Map<String, dynamic> json) => QuestionItem(
        question: Question.fromJson(json["question"]),
      );

  Map<String, dynamic> toJson() => {
        "question": question?.toJson(),
      };
}
