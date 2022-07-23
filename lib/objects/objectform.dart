// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<ObjectForm> objectFormFromJson(String str) =>
    List<ObjectForm>.from(json.decode(str).map((x) => ObjectForm.fromJson(x)));

String objectFormToJson(List<ObjectForm> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ObjectForm {
  ObjectForm({
    required this.name,
    required this.formid,
    required this.formurl,
  });

  String name;
  String formid;
  String formurl;

  factory ObjectForm.fromJson(Map<String, dynamic> json) => ObjectForm(
        name: json["name"],
        formid: json["formid"],
        formurl: json["formurl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "formid": formid,
        "formurl": formurl,
      };
}
