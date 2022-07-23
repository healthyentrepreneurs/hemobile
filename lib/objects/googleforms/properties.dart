class Properties {
  Properties({this.alignment, this.width, this.height});

  String? alignment;
  int? width;
  int? height;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        alignment: json["alignment"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "alignment": alignment,
        "width": width,
        "height": height,
      };
}
