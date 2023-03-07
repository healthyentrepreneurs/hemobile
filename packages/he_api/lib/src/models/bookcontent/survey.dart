import 'package:json_annotation/json_annotation.dart';
part 'survey.g.dart';

@JsonSerializable()
class Survey {

  factory Survey.fromJson(Map<String, dynamic> json) =>
      _$SurveyFromJson(json);
  Survey({
    required this.id,
    required this.createdby,
    required this.datecreated,
    required this.image,
    required this.image_url_small,
    required this.name,
    required this.slug,
    required this.surveydesc,
    required this.surveyjson,
    required this.type
  });

  String id;
  String createdby;
  String datecreated;
  String image;
  String image_url_small;
  String name;
  String slug;
  String surveydesc;
  String surveyjson;
  String type;

  Map<String, dynamic> toJson() => _$SurveyToJson(this);
}
