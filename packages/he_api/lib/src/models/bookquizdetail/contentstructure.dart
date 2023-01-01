import 'package:json_annotation/json_annotation.dart';
part 'contentstructure.g.dart';

@JsonSerializable()
class ContentStructure {
  String title;
  String href;
  // String filefullpath;
  int level;
  String hidden;
  // late int index;
  // dynamic chapterId;
  ContentStructure({
    required this.title,
    required this.href,
    required this.level,
    required this.hidden,
    // required this.filefullpath,
    // this.chapterId
  });
  String get chapterId => href.split('/').first;
  factory ContentStructure.fromJson(Map<String, dynamic> json) =>
      _$ContentStructureFromJson(json);
}
