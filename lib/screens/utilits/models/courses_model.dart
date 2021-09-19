class Course {
  dynamic id;
  String fullName;
  String source;
  String summaryCustom;
  String nextLink;
  String imageUrlSmall;
  String imageUrl;

  /*
  "id": 1,
    "fullname": "HE Health",
    "source": "moodle",
    "summary_custome": "Healthy Entrepreneurs provides basic health there where no one else will go.Our trained health workers sell health care .. ",
    "next_link": "http://35.238.72.107/user/get_details_percourse/1",
    "image_url_small": "https://picsum.photos/100/100",
    "image_url": "https://picsum.photos/200/300"
   */

  Course(
      {this.id,
      required this.fullName,
      required this.source,
      required this.summaryCustom,
      required this.nextLink,
      required this.imageUrlSmall,
      required this.imageUrl});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      fullName: json['fullname'],
      source: json['source'],
      summaryCustom: json['summary_custome'],
      nextLink: json['next_link'],
      imageUrlSmall: json['image_url_small'],
      imageUrl: json['image_url'],
    );
  }
}

class SubCourse {
  int? id;
  String? name;
  int? visible;
  String? summary;
  int? summaryformat;
  int? section;
  List<CourseModule>? modules;

  SubCourse(
      {this.id,
      this.name,
      this.visible,
      this.summary,
      this.summaryformat,
      this.section,
      this.modules});

  factory SubCourse.fromJson(Map<String, dynamic> json) {
    return SubCourse(
        id: json['id'],
        name: json['name'],
        visible: json['visible'],
        summary: json['summary'],
        summaryformat: json['summaryformat'],
        section: json['section'],
        modules: (json['modules'] == null ? [] : json['modules'] as List)
            .map((i) => CourseModule.fromJson(i))
            .toList());
  }
}

class CourseModule {
  dynamic id;
  String? name;
  String? description;
  String? url;
  String? modicon;
  String? modname;
  String? modplural;
  dynamic instance;
  List<ModuleContent>? contents;

  CourseModule({
    required this.id,
    this.name,
    this.url,
    this.modicon,
    this.modname,
    this.modplural,
    this.contents,
    this.description,
    this.instance,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      modicon: json['modicon'],
      modplural: json['modplural'],
      modname: json['modname'],
      contents: (json['contents'] as List)
          .map((i) => ModuleContent.fromJson(i))
          .toList(),
      description: json['description'],
      instance: json['instance'],
    );
  }
}

/*
"type": "content",
              "filename": "structure",
              "filepath": "/",
              "filesize": 0,
              "fileurl": null,
              "content": "[{\"title\":\"What are the symptoms?\",\"href\":\"2\\/index.html\",\"level\":0,\"hidden\":\"0\",\"subitems\":[]},{\"title\":\"Treatment\",\"href\":\"3\\/index.html\",\"level\":0,\"hidden\":\"0\",\"subitems\":[]}]",
              "timecreated": 1600431300,
              "timemodified": 1602583277,
              "sortorder": 0,
              "mimetype": "video/mp4",
              "isexternalfile": false,
              "userid": 5,
              "author": "thijs admin",
              "license": "unknown"
 */
enum ModuleContentType { file, content }

class ContentStructure {
  String title;
  String href;
  String filefullpath;
  int level;
  String hidden;
  String token = "f84bf33b56e86a4664284d8a3dfb5280";
  late int index;
  dynamic chapterId;

  /*
  [
  {title: What are the symptoms?, href: 2/index.html, level: 0, hidden: 0, subitems: []}
  ]
   */

  ContentStructure(
      {required this.title,
      required this.href,
      required this.level,
      required this.hidden,
      required this.filefullpath,
      this.chapterId});

  factory ContentStructure.fromJson(Map<String, dynamic> json) {
    return ContentStructure(
        title: json['title'],
        href: json['href'],
        filefullpath: json['filefullpath'],
        level: json['level'],
        hidden: json['hidden'],
        chapterId: json['chapter_id']);
  }

  factory ContentStructure.fromJson2(Map<String, dynamic> json, int index) {
    var x = ContentStructure(
        title: json['title'],
        href: json['href'],
        filefullpath: json['filefullpath'],
        level: json['level'],
        hidden: json['hidden'],
        chapterId: json['chapter_id']);
    x.index = index;
    return x;
  }
}

class ModuleContent {
  String type;
  String? filename;
  String? filepath;
  String? fileurl;
  String? content;
  int? timecreated;
  int? timemodified;
  int? sortorder;
  String? mimetype;
  bool? isexternalfile;
  int? userid;
  String? author;
  String? license;
  int? filesize;

  List<ModuleContent>? contents;

  ModuleContent(
      {required this.type,
      this.filename,
      this.filepath,
      this.fileurl,
      this.content,
      this.timecreated,
      this.timemodified,
      this.sortorder,
      this.mimetype,
      this.isexternalfile,
      this.userid,
      this.author,
      this.license,
      this.filesize});

  factory ModuleContent.fromJson(Map<String, dynamic> json) {
    return ModuleContent(
        type: json['type'],
        filename: json['filename'],
        filepath: json['filepath'],
        fileurl: json['fileurl'],
        content: json['content'],
        timecreated: json['timecreated'],
        timemodified: json['timemodified'],
        sortorder: json['sortorder'],
        mimetype: json['mimetype'],
        isexternalfile: json['isexternalfile'],
        userid: json['userid'],
        author: json['author'],
        license: json['license'],
        filesize: json['filesize']);
  }
}
