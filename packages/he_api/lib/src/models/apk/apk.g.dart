// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Apk _$ApkFromJson(Map<String, dynamic> json) => Apk(
      version: json['version'] as String,
      url: json['url'] as String,
      releasenotes: json['releasenotes'] as String,
      releasedate: json['releasedate'] as String,
      sha256checksum: json['sha256checksum'] as String,
      appname: json['appname'] as String,
      packagename: json['packagename'] as String,
      buildnumber: json['buildnumber'] as String,
      buildsignature: json['buildsignature'] as String,
    );

Map<String, dynamic> _$ApkToJson(Apk instance) => <String, dynamic>{
      'version': instance.version,
      'url': instance.url,
      'releasenotes': instance.releasenotes,
      'releasedate': instance.releasedate,
      'sha256checksum': instance.sha256checksum,
      'appname': instance.appname,
      'packagename': instance.packagename,
      'buildnumber': instance.buildnumber,
      'buildsignature': instance.buildsignature,
    };
