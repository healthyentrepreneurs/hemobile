import 'package:objectbox/objectbox.dart';

@Entity()
class SurveyDataModel {
  @Id()
  int id; // Autogenerated id
  String userId;
  String surveyVersion;
  String surveyObject;
  String surveyId;
  bool isPending;
  String courseId; // Added field
  String country; // Added field

  @Property(type: PropertyType.date)
  DateTime dateCreated;

  SurveyDataModel({
    this.id = 0, // Default value for autogenerated id
    required this.userId,
    required this.surveyVersion,
    required this.surveyObject,
    required this.surveyId,
    required this.isPending,
    required this.courseId, // Added field
    required this.country, // Added field
  })  : assert(surveyObject.isNotEmpty, 'surveyObject must not be empty'),
        dateCreated = DateTime.now();

  @override
  String toString() {
    return 'SurveyDataModel{id: $id, userId: $userId, surveyVersion: $surveyVersion, surveyObject: $surveyObject, surveyId: $surveyId, isPending: $isPending, courseId: $courseId, country: $country, dateCreated: $dateCreated}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'surveyVersion': surveyVersion,
      'surveyObject': surveyObject,
      'surveyId': surveyId,
      'isPending': isPending,
      'courseId': courseId,
      'country': country,
      'dateCreated': dateCreated.toIso8601String(),
    };
  }

  static SurveyDataModel fromJson(Map<String, dynamic> json) {
    return SurveyDataModel(
      id: json['id'],
      userId: json['userId'],
      surveyVersion: json['surveyVersion'],
      surveyObject: json['surveyObject'],
      surveyId: json['surveyId'],
      isPending: json['isPending'],
      courseId: json['courseId'],
      country: json['country'],
    )..dateCreated = DateTime.parse(json['dateCreated']);
  }
}
