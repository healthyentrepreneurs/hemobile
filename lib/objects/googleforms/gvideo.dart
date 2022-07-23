import 'properties.dart';

class Gvideo {
  Gvideo({
    required this.youtubeUri,
    this.properties,
  });

  String youtubeUri;
  Properties? properties;

  factory Gvideo.fromJson(Map<String, dynamic> json) => Gvideo(
        youtubeUri: json["youtubeUri"],
        properties: Properties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
        "youtubeUri": youtubeUri,
        "properties": properties?.toJson(),
      };
}
