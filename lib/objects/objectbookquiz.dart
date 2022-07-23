class ObjectBookQuiz {
  int id;
  int? instance;
  String? modicon;
  String? modname;
  String? modplural;
  String? name;
  String? url;
  bool? uservisible;
  int? visible;
  String? customdata;
  int? contextid;

  ObjectBookQuiz({
    required this.id,
    this.instance,
    this.modicon,
    this.modname,
    this.modplural,
    this.name,
    this.url,
    this.uservisible,
    this.visible,
    this.customdata,
    this.contextid,
  });

  factory ObjectBookQuiz.fromJson(Map<String, dynamic> json) {
    return ObjectBookQuiz(
      id: json['id'],
      instance: json['instance'],
      modicon: json['modicon'],
      modname: json['modname'],
      modplural: json['modplural'],
      name: json['name'],
      url: json['url'],
      uservisible: json['uservisible'],
      visible: json['visible'],
      customdata: json['customdata'],
      contextid: json['contextid'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "instance": instance,
        "modicon": modicon,
        "modname": modname,
        "modplural": modplural,
        "name": name,
        "url": url,
        "uservisible": uservisible,
        "visible": visible,
        "customdata": customdata,
        "contextid": contextid,
      };
}
