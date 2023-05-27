import 'package:json_annotation/json_annotation.dart';
part 'hfive_content.g.dart';

@JsonSerializable()
class HfiveContent {
  int status;
  String h5p_url;
  String h5pname;
  String content_json;
  String h5p_json;

  HfiveContent({
    required this.status,
    required this.h5p_url,
    required this.h5pname,
    required this.content_json,
    required this.h5p_json,
  });
  factory HfiveContent.fromJson(Map<String, dynamic> json) =>
      _$HfiveContentFromJson(json);

  Map<String, dynamic> toJson() => _$HfiveContentToJson(this);
}
