import 'dart:convert';

List<ObjectQuizContent> objectQuizContentFromJson(String str) =>
    List<ObjectQuizContent>.from(
        json.decode(str).map((x) => ObjectQuizContent.fromJson(x)));

String objectQuizContentToJson(List<ObjectQuizContent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ObjectQuizContent {
  ObjectQuizContent({
    required this.html,
    required this.layout,
    required this.currentpage,
    required this.state,
    required this.nextpage,
  });

  String html;
  int layout;
  int currentpage;
  String state;
  int nextpage;

  factory ObjectQuizContent.fromJson(Map<String, dynamic> json) =>
      ObjectQuizContent(
        html: json["html"],
        layout: json["layout"],
        currentpage: json["currentpage"],
        state: json["state"],
        nextpage: json["nextpage"],
      );

  Map<String, dynamic> toJson() => {
        "html": html,
        "layout": layout,
        "currentpage": currentpage,
        "state": state,
        "nextpage": nextpage,
      };
}
