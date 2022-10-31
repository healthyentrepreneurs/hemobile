// To parse this JSON data, do
class ObjectSurvey {
  ObjectSurvey({
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

  factory ObjectSurvey.fromJson(Map<String, dynamic> json) =>
      ObjectSurvey(
        id: json["id"],
        createdby: json["createdby"],
        datecreated: json["datecreated"],
        image: json["image"],
        image_url_small: json["image_url_small"],
        name: json["name"],
        slug: json["slug"],
        surveydesc: json["surveydesc"],
        surveyjson: json["surveyjson"],
        type: json["type"],
      );
  Map<String, dynamic> toJson() => {
    "id": id,
    "createdby": createdby,
    "datecreated": datecreated,
    "image": image,
    "image_url_small": image_url_small,
    "name": name,
    "slug": slug,
    "surveydesc": surveydesc,
    "surveyjson": surveyjson,
    "type": type
  };
}
