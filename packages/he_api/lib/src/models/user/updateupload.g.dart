// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updateupload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUpload _$UpdateUploadFromJson(Map<String, dynamic> json) => UpdateUpload(
      id: json['id'] as int?,
      uploadProgress: (json['uploadProgress'] as num?)?.toDouble(),
      isUploadingData: json['isUploadingData'] as bool?,
      backupAnimation: json['backupAnimation'] as bool?,
      surveyAnimation: json['surveyAnimation'] as bool?,
      booksAnimation: json['booksAnimation'] as bool?,
    );

Map<String, dynamic> _$UpdateUploadToJson(UpdateUpload instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uploadProgress': instance.uploadProgress,
      'isUploadingData': instance.isUploadingData,
      'backupAnimation': instance.backupAnimation,
      'surveyAnimation': instance.surveyAnimation,
      'booksAnimation': instance.booksAnimation,
    };
