class ObjectSection {
  ObjectSection({
    required this.id,
    this.name,
    this.section,
    this.uservisible,
  });

  int id;
  String? name;
  int? section;
  bool? uservisible;
  factory ObjectSection.fromJson(Map<String, dynamic> json) => ObjectSection(
        id: json["id"],
        name: json["name"],
        section: json["section"],
        uservisible: json["uservisible"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "section": section,
        "uservisible": uservisible,
      };
}
