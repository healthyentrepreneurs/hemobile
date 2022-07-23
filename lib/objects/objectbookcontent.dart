// To parse this JSON data, do
class ObjectBookContent {
  ObjectBookContent({
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

  factory ObjectBookContent.fromJson(Map<String, dynamic> json) =>
      ObjectBookContent(
        id: json["id"],
        type: typeValues.map[json["type"]]!,
        filename: json["filename"],
        filepath: json["filepath"],
        filesize: json["filesize"],
        fileurl: json["fileurl"],
        timecreated: json["timecreated"],
        timemodified: json["timemodified"],
        sortorder: json["sortorder"],
        userid: json["userid"],
        content: json["content"],
        mimetype: json["mimetype"] == null
            ? null
            : mimetypeValues.map[json["mimetype"]],
        videocaption: json["videocaption"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": typeValues.reverse[type],
        "filename": filename,
        "filepath": filepath,
        "filesize": filesize,
        "fileurl": fileurl,
        "timecreated": timecreated,
        "timemodified": timemodified,
        "sortorder": sortorder,
        "userid": userid,
        "content": content,
        "mimetype": mimetype == null ? null : mimetypeValues.reverse[mimetype],
        "videocaption": videocaption,
      };
}

enum Mimetype { VIDEO_MP4, IMAGE_PNG, IMAGE_JPEG }

final mimetypeValues = EnumValues({
  "image/jpeg": Mimetype.IMAGE_JPEG,
  "image/png": Mimetype.IMAGE_PNG,
  "video/mp4": Mimetype.VIDEO_MP4
});

enum Type { CONTENT, FILE }

final typeValues = EnumValues({"content": Type.CONTENT, "file": Type.FILE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap;
    return reverseMap;
  }
}
