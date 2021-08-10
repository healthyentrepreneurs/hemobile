// // To parse this JSON data, do
// //
// //     final welcome = welcomeFromJson(jsonString);
//
// import 'dart:convert';
//
// class InitHandle {
//   InitHandle({
//     this.code,
//     this.msg,
//     this.data,
//   });
//
//   final int? code;
//   final String? msg;
//   final List<SubCourse>? data;
//
//   factory InitHandle.fromRawJson(String str) =>
//       InitHandle.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory InitHandle.fromJson(Map<String, dynamic> json) => InitHandle(
//         code: json["code"] == null ? null : json["code"],
//         msg: json["msg"] == null ? null : json["msg"],
//         data: json["data"] == null
//             ? null
//             : List<SubCourse>.from(
//                 json["data"].map((x) => SubCourse.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "code": code == null ? null : code,
//         "msg": msg == null ? null : msg,
//         "data": data == null
//             ? null
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
//
// class SubCourse {
//   SubCourse({
//     this.id,
//     this.name,
//     this.visible,
//     this.summary,
//     this.summaryformat,
//     this.section,
//     this.hiddenbynumsections,
//     this.uservisible,
//     this.modules,
//   });
//
//   final int? id;
//   final String? name;
//   final int? visible;
//   final String? summary;
//   final int? summaryformat;
//   final int? section;
//   final int? hiddenbynumsections;
//   final bool? uservisible;
//   final List<CourseModule>? modules;
//
//   factory SubCourse.fromRawJson(String str) =>
//       SubCourse.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory SubCourse.fromJson(Map<String, dynamic> json) => SubCourse(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         visible: json["visible"] == null ? null : json["visible"],
//         summary: json["summary"] == null ? null : json["summary"],
//         summaryformat:
//             json["summaryformat"] == null ? null : json["summaryformat"],
//         section: json["section"] == null ? null : json["section"],
//         hiddenbynumsections: json["hiddenbynumsections"] == null
//             ? null
//             : json["hiddenbynumsections"],
//         uservisible: json["uservisible"] == null ? null : json["uservisible"],
//         modules: json["modules"] == null
//             ? null
//             : List<CourseModule>.from(
//                 json["modules"].map((x) => CourseModule.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "visible": visible == null ? null : visible,
//         "summary": summary == null ? null : summary,
//         "summaryformat": summaryformat == null ? null : summaryformat,
//         "section": section == null ? null : section,
//         "hiddenbynumsections":
//             hiddenbynumsections == null ? null : hiddenbynumsections,
//         "uservisible": uservisible == null ? null : uservisible,
//         "modules": modules == null
//             ? null
//             : List<dynamic>.from(modules!.map((x) => x.toJson())),
//       };
// }
//
// class CourseModule {
//   CourseModule({
//     required this.id,
//     this.url,
//     this.name,
//     this.instance,
//     this.visible,
//     this.uservisible,
//     this.visibleoncoursepage,
//     this.modicon,
//     this.modname,
//     this.modplural,
//     this.availability,
//     this.indent,
//     this.onclick,
//     this.afterlink,
//     this.customdata,
//     this.noviewlink,
//     this.completion,
//     this.contentsinfo,
//     this.contents,
//   });
//
//   final int id;
//   final String? url;
//   final String? name;
//   final int? instance;
//   final int? visible;
//   final bool? uservisible;
//   final int? visibleoncoursepage;
//   final String? modicon;
//   final Modname? modname;
//   final Modplural? modplural;
//   final dynamic availability;
//   final int? indent;
//   final String? onclick;
//   final dynamic afterlink;
//   final Customdata? customdata;
//   final bool? noviewlink;
//   final int? completion;
//   final Contentsinfo? contentsinfo;
//   final List<ModuleContent>? contents;
//
//   factory CourseModule.fromRawJson(String str) =>
//       CourseModule.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory CourseModule.fromJson(Map<String, dynamic> json) => CourseModule(
//         id: json["id"] == null ? null : json["id"],
//         url: json["url"] == null ? null : json["url"],
//         name: json["name"] == null ? null : json["name"],
//         instance: json["instance"] == null ? null : json["instance"],
//         visible: json["visible"] == null ? null : json["visible"],
//         uservisible: json["uservisible"] == null ? null : json["uservisible"],
//         visibleoncoursepage: json["visibleoncoursepage"] == null
//             ? null
//             : json["visibleoncoursepage"],
//         modicon: json["modicon"] == null ? null : json["modicon"],
//         modname:
//             json["modname"] == null ? null : modnameValues.map[json["modname"]],
//         modplural: json["modplural"] == null
//             ? null
//             : modpluralValues.map[json["modplural"]],
//         availability: json["availability"],
//         indent: json["indent"] == null ? null : json["indent"],
//         onclick: json["onclick"] == null ? null : json["onclick"],
//         afterlink: json["afterlink"],
//         customdata: json["customdata"] == null
//             ? null
//             : customdataValues.map[json["customdata"]],
//         noviewlink: json["noviewlink"] == null ? null : json["noviewlink"],
//         completion: json["completion"] == null ? null : json["completion"],
//         contentsinfo: json["contentsinfo"] == null
//             ? null
//             : Contentsinfo.fromJson(json["contentsinfo"]),
//         contents: json["contents"] == null
//             ? null
//             : List<ModuleContent>.from(
//                 json["contents"].map((x) => ModuleContent.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "url": url == null ? null : url,
//         "name": name == null ? null : name,
//         "instance": instance == null ? null : instance,
//         "visible": visible == null ? null : visible,
//         "uservisible": uservisible == null ? null : uservisible,
//         "visibleoncoursepage":
//             visibleoncoursepage == null ? null : visibleoncoursepage,
//         "modicon": modicon == null ? null : modicon,
//         "modname": modname == null ? null : modnameValues.reverse![modname],
//         "modplural":
//             modplural == null ? null : modpluralValues.reverse![modplural],
//         "availability": availability,
//         "indent": indent == null ? null : indent,
//         "onclick": onclick == null ? null : onclick,
//         "afterlink": afterlink,
//         "customdata":
//             customdata == null ? null : customdataValues.reverse![customdata],
//         "noviewlink": noviewlink == null ? null : noviewlink,
//         "completion": completion == null ? null : completion,
//         "contentsinfo": contentsinfo == null ? null : contentsinfo!.toJson(),
//         "contents": contents == null
//             ? null
//             : List<dynamic>.from(contents!.map((x) => x.toJson())),
//       };
// }
//
// class ModuleContent {
//   ModuleContent({
//     this.type,
//      this.filename,
//      this.filepath,
//      this.filesize,
//      this.fileurl,
//      this.timecreated,
//      this.timemodified,
//      this.sortorder,
//      this.userid,
//     this.author,
//     this.license,
//     this.content,
//     this.tags,
//     this.mimetype,
//     this.isexternalfile,
//   });
//   final Type? type;
//   final String? filename;
//   final String? filepath;
//   final int? filesize;
//   final String? fileurl;
//   final int? timecreated;
//   final int? timemodified;
//   final int? sortorder;
//   final int? userid;
//   final Author? author;
//   final License? license;
//   final String? content;
//   final List<dynamic>? tags;
//   final Mimetype? mimetype;
//   final bool? isexternalfile;
//   factory ModuleContent.fromRawJson(String str) =>
//       ModuleContent.fromJson(json.decode(str));
//   String toRawJson() => json.encode(toJson());
//   factory ModuleContent.fromJson(Map<String, dynamic> json) => ModuleContent(
//         type: json["type"] == null ? null : typeValues.map[json["type"]],
//         filename: json["filename"] == null ? null : json["filename"],
//         filepath: json["filepath"] == null ? null : json["filepath"],
//         filesize: json["filesize"] == null ? null : json["filesize"],
//         fileurl: json["fileurl"] == null ? null : json["fileurl"],
//         timecreated: json["timecreated"] == null ? null : json["timecreated"],
//         timemodified:
//             json["timemodified"] == null ? null : json["timemodified"],
//         sortorder: json["sortorder"] == null ? null : json["sortorder"],
//         userid: json["userid"] == null ? null : json["userid"],
//         author:
//             json["author"] == null ? null : authorValues.map[json["author"]],
//         license:
//             json["license"] == null ? null : licenseValues.map[json["license"]],
//         content: json["content"] == null ? null : json["content"],
//         tags: json["tags"] == null
//             ? null
//             : List<dynamic>.from(json["tags"].map((x) => x)),
//         mimetype: json["mimetype"] == null
//             ? null
//             : mimetypeValues.map[json["mimetype"]],
//         isexternalfile:
//             json["isexternalfile"] == null ? null : json["isexternalfile"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "type": type == null ? null : typeValues.reverse![type],
//         "filename": filename == null ? null : filename,
//         "filepath": filepath == null ? null : filepath,
//         "filesize": filesize == null ? null : filesize,
//         "fileurl": fileurl == null ? null : fileurl,
//         "timecreated": timecreated == null ? null : timecreated,
//         "timemodified": timemodified == null ? null : timemodified,
//         "sortorder": sortorder == null ? null : sortorder,
//         "userid": userid == null ? null : userid,
//         "author": author == null ? null : authorValues.reverse![author],
//         "license": license == null ? null : licenseValues.reverse![license],
//         "content": content == null ? null : content,
//         "tags": tags == null ? null : List<dynamic>.from(tags!.map((x) => x)),
//         "mimetype": mimetype == null ? null : mimetypeValues.reverse![mimetype],
//         "isexternalfile": isexternalfile == null ? null : isexternalfile,
//       };
// }
//
// enum Author { THIJS_ADMIN, WEALTH_HEALTH }
//
// final authorValues = EnumValues(
//     {"thijs admin": Author.THIJS_ADMIN, "Wealth Health": Author.WEALTH_HEALTH});
//
// enum License { UNKNOWN, ALLRIGHTSRESERVED }
//
// final licenseValues = EnumValues({
//   "allrightsreserved": License.ALLRIGHTSRESERVED,
//   "unknown": License.UNKNOWN
// });
//
// enum Mimetype { VIDEO_MP4, IMAGE_PNG, IMAGE_JPEG }
//
// final mimetypeValues = EnumValues({
//   "image/jpeg": Mimetype.IMAGE_JPEG,
//   "image/png": Mimetype.IMAGE_PNG,
//   "video/mp4": Mimetype.VIDEO_MP4
// });
//
// enum Type { CONTENT, FILE }
//
// final typeValues = EnumValues({"content": Type.CONTENT, "file": Type.FILE});
//
// class Contentsinfo {
//   Contentsinfo({
//     required this.filescount,
//     this.filessize,
//     this.lastmodified,
//     this.mimetypes,
//     this.repositorytype,
//   });
//
//   final int filescount;
//   final int? filessize;
//   final int? lastmodified;
//   final List<Mimetype>? mimetypes;
//   final String? repositorytype;
//
//   factory Contentsinfo.fromRawJson(String str) =>
//       Contentsinfo.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Contentsinfo.fromJson(Map<String, dynamic> json) => Contentsinfo(
//         filescount: json["filescount"] == null ? null : json["filescount"],
//         filessize: json["filessize"] == null ? null : json["filessize"],
//         lastmodified:
//             json["lastmodified"] == null ? null : json["lastmodified"],
//         mimetypes: json["mimetypes"] == null
//             ? null
//             : List<Mimetype>.from(
//                 json["mimetypes"].map((x) => mimetypeValues.map[x])),
//         repositorytype:
//             json["repositorytype"] == null ? null : json["repositorytype"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "filescount": filescount == null ? null : filescount,
//         "filessize": filessize == null ? null : filessize,
//         "lastmodified": lastmodified == null ? null : lastmodified,
//         "mimetypes": mimetypes == null
//             ? null
//             : List<dynamic>.from(
//                 mimetypes!.map((x) => mimetypeValues.reverse![x])),
//         "repositorytype": repositorytype == null ? null : repositorytype,
//       };
// }
//
// enum Customdata { EMPTY }
//
// final customdataValues = EnumValues({"\"\"": Customdata.EMPTY});
//
// enum Modname { BOOK }
//
// final modnameValues = EnumValues({"book": Modname.BOOK});
//
// enum Modplural { BOOKS }
//
// final modpluralValues = EnumValues({"Books": Modplural.BOOKS});
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String>? reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String>? get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
