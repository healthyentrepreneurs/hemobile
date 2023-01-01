// To parse this JSON data, do
import 'package:json_annotation/json_annotation.dart';

part 'bookcontent.g.dart';

@JsonSerializable()
class BookContent {
  BookContent({
    this.id,
    required this.type,
    required this.filename,
    required this.filepath,
    required this.filesize,
    this.fileurl,
    this.timecreated,
    this.timemodified,
    this.sortorder,
    this.userid,
    this.content,
    this.mimetype,
    this.videocaption,
  });

  int? id;
  Type type;
  String filename;
  String filepath;
  int filesize;
  String? fileurl;
  int? timecreated;
  int? timemodified;
  int? sortorder;
  double? userid;
  String? content;
  Mimetype? mimetype;
  String? videocaption;

  factory BookContent.fromJson(Map<String, dynamic> json) =>
      _$BookContentFromJson(json);
}

enum Mimetype { VIDEO_MP4, IMAGE_PNG, IMAGE_JPEG }

enum Type { CONTENT, FILE }

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap;
    return reverseMap;
  }
}
