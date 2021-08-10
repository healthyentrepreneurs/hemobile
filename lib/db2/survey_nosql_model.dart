import 'package:objectbox/objectbox.dart';
import '../objectbox.g.dart';
// https://docs.objectbox.io/entity-annotations

@Entity()
class SurveyDataModel {
  // Each "Entity" needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't "id" (case insensitive).
  int id=0;
  late String name;
  late String text;
  bool? isPending;
  String? dateCreated;
  // Note: just for logs in the examples below(), not needed by ObjectBox.
  toString() => 'Note{id: $id, text: $text}, name: $name}';
  // https://stackoverflow.com/questions/53002196/flutter-how-to-post-json-array
  Map<String, dynamic> toJsonData() {
    var map = new Map<String, dynamic>();
    map["surveyId"] = name;
    map["surveyObject"] = text;
    return map;
  }
}

@Entity()
class ViewsDataModel {
  // Each "Entity" needs a unique integer ID property.
  // Add `@Id()` annotation if its name isn't "id" (case insensitive).
  int id=0;
  late String bookId;
  late String chapterId;
  late String courseId;
  late String dateTimeStr;
  // ViewsDataModel({required this.bookId, required this.chapterId, required this.courseId,required this.dateTimeStr});
  @override
  String toString() {
    // TODO: implement toString
    return "$id $bookId $chapterId $courseId $dateTimeStr ";
  }
}
