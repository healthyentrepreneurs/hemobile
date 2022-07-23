// objectcontentstructure
class ObjectContentStructure {
  String title;
  String href;
  // String filefullpath;
  int level;
  String hidden;
  // late int index;
  // dynamic chapterId;
  ObjectContentStructure(
      {required this.title,
      required this.href,
      required this.level,
      required this.hidden,
      // required this.filefullpath,
      // this.chapterId
      }
      );
  String get chapterId => href.split("/").first;
  factory ObjectContentStructure.fromJson(Map<String, dynamic> json) {
    return ObjectContentStructure(
        title: json['title'],
        href: json['href'],
        // filefullpath: json['filefullpath'],
        level: json['level'],
        hidden: json['hidden'],
        // chapterId: json['chapter_id']
    );
  }
}
