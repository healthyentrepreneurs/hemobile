// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contentsinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contentsinfo _$ContentsinfoFromJson(Map<String, dynamic> json) => Contentsinfo(
      filescount: json['filescount'] as int,
      filessize: json['filessize'] as int,
      lastmodified: json['lastmodified'] as int,
      mimetypes: (json['mimetypes'] as List<dynamic>)
          .map((e) => $enumDecode(_$MimetypeEnumMap, e))
          .toList(),
      repositorytype: json['repositorytype'] as String,
    );

Map<String, dynamic> _$ContentsinfoToJson(Contentsinfo instance) =>
    <String, dynamic>{
      'filescount': instance.filescount,
      'filessize': instance.filessize,
      'lastmodified': instance.lastmodified,
      'mimetypes':
          instance.mimetypes.map((e) => _$MimetypeEnumMap[e]!).toList(),
      'repositorytype': instance.repositorytype,
    };

const _$MimetypeEnumMap = {
  Mimetype.VIDEO_MP4: 'VIDEO_MP4',
  Mimetype.IMAGE_PNG: 'IMAGE_PNG',
  Mimetype.IMAGE_JPEG: 'IMAGE_JPEG',
};
