import 'quizsettings.dart';

class Settings {
  Settings({
    required this.quizSettings,
  });

  QuizSettings quizSettings;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        quizSettings: QuizSettings.fromJson(json["quizSettings"]),
      );

  Map<String, dynamic> toJson() => {
        "quizSettings": quizSettings.toJson(),
      };
}
