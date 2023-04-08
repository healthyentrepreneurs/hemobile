// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apkupdatestatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Apkupdatestatus _$ApkupdatestatusFromJson(Map<String, dynamic> json) =>
    Apkupdatestatus(
      seen: json['seen'] as bool,
      updated: json['updated'] as bool,
      heversion: json['heversion'] as String?,
    );

Map<String, dynamic> _$ApkupdatestatusToJson(Apkupdatestatus instance) =>
    <String, dynamic>{
      'seen': instance.seen,
      'updated': instance.updated,
      'heversion': instance.heversion,
    };
