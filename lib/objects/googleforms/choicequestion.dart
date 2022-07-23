import 'option.dart';

class ChoiceQuestion {
  ChoiceQuestion({
    required this.type,
    required this.options,
  });

  String type;
  List<Option> options;

  factory ChoiceQuestion.fromJson(Map<String, dynamic> json) => ChoiceQuestion(
        type: json["type"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}
