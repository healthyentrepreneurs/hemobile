import 'package:objectbox/objectbox.dart';

@Entity()
class BackupStateDataModel {
  int id;
  double uploadProgress;
  bool isUploadingData;
  bool backupAnimation;
  bool surveyAnimation;
  bool booksAnimation;

  BackupStateDataModel({
    this.id = 0,
    required this.uploadProgress,
    required this.isUploadingData,
    required this.backupAnimation,
    required this.surveyAnimation,
    required this.booksAnimation,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uploadProgress': uploadProgress,
        'isUploadingData': isUploadingData,
        'backupAnimation': backupAnimation,
        'surveyAnimation': surveyAnimation,
        'booksAnimation': booksAnimation,
      };

  @override
  String toString() {
    return 'BackupStateDataModel{id: $id, uploadProgress: $uploadProgress, isUploadingData: $isUploadingData, backupAnimation: $backupAnimation, surveyAnimation: $surveyAnimation, booksAnimation: $booksAnimation}';
  }
}
