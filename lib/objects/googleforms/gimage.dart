import 'properties.dart';

class Gimage {
  Gimage({
    required this.contentUri,
    this.properties,
  });

  String contentUri;
  Properties? properties;

  factory Gimage.fromJson(Map<String, dynamic> json) => Gimage(
        contentUri: json["contentUri"],
        properties: Properties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
        "contentUri": contentUri,
        "properties": properties?.toJson(),
      };
}
