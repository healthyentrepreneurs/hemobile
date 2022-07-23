class QuizSettings {
  QuizSettings({
    this.isQuiz,
  });

  bool? isQuiz;

  factory QuizSettings.fromJson(Map<String, dynamic> json) => QuizSettings(
        isQuiz: json["isQuiz"],
      );

  Map<String, dynamic> toJson() => {
        "isQuiz": isQuiz,
      };
}
