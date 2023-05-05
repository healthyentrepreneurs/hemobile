import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';

@Entity()
class BackupStateDataModel {
  @Id(assignable: true)
  int id = 1;
  double uploadProgress;
  bool isUploadingData;
  bool backupAnimation;
  bool surveyAnimation;
  bool booksAnimation;
  @Property(type: PropertyType.date)
  DateTime? dateCreated;

  BackupStateDataModel(
      {this.id = 1,
      required this.uploadProgress,
      required this.isUploadingData,
      required this.backupAnimation,
      required this.surveyAnimation,
      required this.booksAnimation,
      DateTime? dateCreated})
      : dateCreated = dateCreated ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'uploadProgress': uploadProgress,
        'isUploadingData': isUploadingData,
        'backupAnimation': backupAnimation,
        'surveyAnimation': surveyAnimation,
        'booksAnimation': booksAnimation,
        'dateCreated': dateFormat,
      };

  String get dateFormat =>
      DateFormat('dd.MM.yyyy hh:mm:ss').format(dateCreated ?? DateTime.now());

  @override
  String toString() {
    return 'BackupStateDataModel{id: $id, uploadProgress: $uploadProgress, isUploadingData: $isUploadingData, backupAnimation: $backupAnimation, surveyAnimation: $surveyAnimation, booksAnimation: $booksAnimation,dateCreated: $dateFormat}';
  }

  static BackupStateDataModel defaultInstance({DateTime? dateCreated}) {
    return BackupStateDataModel(
      id: 1,
      uploadProgress: 0.0,
      isUploadingData: false,
      backupAnimation: false,
      surveyAnimation: false,
      booksAnimation: false,
    )..dateCreated = dateCreated ?? DateTime.now();
  }

  BackupStateDataModel copyWith(
      {int? id,
      double? uploadProgress,
      bool? isUploadingData,
      bool? backupAnimation,
      bool? surveyAnimation,
      bool? booksAnimation,
      DateTime? dateCreated}) {
    return BackupStateDataModel(
      id: id ?? this.id,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isUploadingData: isUploadingData ?? this.isUploadingData,
      backupAnimation: backupAnimation ?? this.backupAnimation,
      surveyAnimation: surveyAnimation ?? this.surveyAnimation,
      booksAnimation: booksAnimation ?? this.booksAnimation,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }
}
