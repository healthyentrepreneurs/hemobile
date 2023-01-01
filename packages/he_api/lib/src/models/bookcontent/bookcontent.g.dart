// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookcontent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookContent _$BookContentFromJson(Map<String, dynamic> json) => BookContent(
      id: json['id'] as int?,
      type: $enumDecode(_$TypeEnumMap, json['type']),
      filename: json['filename'] as String,
      filepath: json['filepath'] as String,
      filesize: json['filesize'] as int,
      fileurl: json['fileurl'] as String?,
      timecreated: json['timecreated'] as int?,
      timemodified: json['timemodified'] as int?,
      sortorder: json['sortorder'] as int?,
      userid: (json['userid'] as num?)?.toDouble(),
      content: json['content'] as String?,
      mimetype: $enumDecodeNullable(_$MimetypeEnumMap, json['mimetype']),
      videocaption: json['videocaption'] as String?,
    );

Map<String, dynamic> _$BookContentToJson(BookContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TypeEnumMap[instance.type]!,
      'filename': instance.filename,
      'filepath': instance.filepath,
      'filesize': instance.filesize,
      'fileurl': instance.fileurl,
      'timecreated': instance.timecreated,
      'timemodified': instance.timemodified,
      'sortorder': instance.sortorder,
      'userid': instance.userid,
      'content': instance.content,
      'mimetype': _$MimetypeEnumMap[instance.mimetype],
      'videocaption': instance.videocaption,
    };

const _$TypeEnumMap = {
  Type.CONTENT: 'CONTENT',
  Type.FILE: 'FILE',
};

const _$MimetypeEnumMap = {
  Mimetype.VIDEO_MP4: 'VIDEO_MP4',
  Mimetype.IMAGE_PNG: 'IMAGE_PNG',
  Mimetype.IMAGE_JPEG: 'IMAGE_JPEG',
};
