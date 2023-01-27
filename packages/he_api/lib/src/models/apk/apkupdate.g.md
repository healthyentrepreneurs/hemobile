// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apkupdate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApkUpdate _$ApkUpdateFromJson(Map<String, dynamic> json) => ApkUpdate(
      version: json['version'] as String,
      seen: json['seen'] as bool,
      updated: json['updated'] as bool,
    );

Map<String, dynamic> _$ApkUpdateToJson(ApkUpdate instance) => <String, dynamic>{
      'version': instance.version,
      'seen': instance.seen,
      'updated': instance.updated,
    };
