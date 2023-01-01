import 'package:json_annotation/json_annotation.dart';

part 'contentsinfo.g.dart';

@JsonSerializable()
class Contentsinfo {
  factory Contentsinfo.fromJson(Map<String, dynamic> json) =>
      _$ContentsinfoFromJson(json);
  Contentsinfo({
    required this.filescount,
    required this.filessize,
    required this.lastmodified,
    required this.mimetypes,
    required this.repositorytype,
  });
  int filescount;
  int filessize;
  int lastmodified;
  List<Mimetype> mimetypes;
  String repositorytype;
}

class EnumValues<T> {
  EnumValues(this.map);
  Map<String, T> map;
  late Map<T, String> reverseMap;

  Map<T, String> get reverse {
    reverseMap;
    return reverseMap;
  }
}

enum Mimetype { VIDEO_MP4, IMAGE_PNG, IMAGE_JPEG }
