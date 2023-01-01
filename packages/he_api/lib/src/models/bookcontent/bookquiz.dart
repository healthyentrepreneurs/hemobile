import 'package:json_annotation/json_annotation.dart';

part 'bookquiz.g.dart';

@JsonSerializable()
class BookQuiz {
  int id;
  int? instance;
  String? modicon;
  String? modname;
  String? modplural;
  String? name;
  String? url;
  bool? uservisible;
  int? visible;
  String? customdata;
  int? contextid;

  BookQuiz({
    required this.id,
    this.instance,
    this.modicon,
    this.modname,
    this.modplural,
    this.name,
    this.url,
    this.uservisible,
    this.visible,
    this.customdata,
    this.contextid,
  });
  factory BookQuiz.fromJson(Map<String, dynamic> json) =>
      _$BookQuizFromJson(json);
}
