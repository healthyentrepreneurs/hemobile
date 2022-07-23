class Info {
  Info({required this.title, required this.documentTitle, this.description});

  String title;
  String documentTitle;
  String? description;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        title: json["title"],
        description: json["description"],
        documentTitle: json["documentTitle"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "documentTitle": documentTitle,
      };
}
