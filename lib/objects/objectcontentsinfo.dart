// objectcontentsinfo

class Contentsinfo {
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

  factory Contentsinfo.fromJson(Map<String, dynamic> json) => Contentsinfo(
    filescount: json["filescount"],
    filessize: json["filessize"],
    lastmodified: json["lastmodified"],
    mimetypes: List<Mimetype>.from(
        json["mimetypes"].map((x) => mimetypeValues.map[x])),
    repositorytype: json["repositorytype"],
  );

  Map<String, dynamic> toJson() => {
    "filescount": filescount,
    "filessize": filessize,
    "lastmodified": lastmodified,
    "mimetypes":
    List<dynamic>.from(mimetypes.map((x) => mimetypeValues.reverse[x])),
    "repositorytype": repositorytype,
  };
}
final mimetypeValues = EnumValues({
  "image/jpeg": Mimetype.IMAGE_JPEG,
  "image/png": Mimetype.IMAGE_PNG,
  "video/mp4": Mimetype.VIDEO_MP4
});
class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap;
    return reverseMap;
  }
}
enum Mimetype { VIDEO_MP4, IMAGE_PNG, IMAGE_JPEG }