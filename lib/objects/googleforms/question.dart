import 'package:he/objects/googleforms/grading.dart';

import 'choicequestion.dart';

class Question {
  Question({
    required this.questionId,
    this.required,
    this.grading,
    required this.choiceQuestion,
  });

  String questionId;
  bool? required;
  Grading? grading;
  ChoiceQuestion choiceQuestion;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionId: json["questionId"],
        required: json["required"],
        grading:
            json["grading"] == null ? null : Grading.fromJson(json["grading"]),
        choiceQuestion: ChoiceQuestion.fromJson(json["choiceQuestion"]),
      );

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "required": required,
        "grading": grading == null ? null : grading!.toJson(),
        "choiceQuestion": choiceQuestion.toJson(),
      };
}
