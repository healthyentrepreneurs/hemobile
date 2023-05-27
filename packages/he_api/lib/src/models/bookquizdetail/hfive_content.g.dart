// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hfive_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HfiveContent _$HfiveContentFromJson(Map<String, dynamic> json) => HfiveContent(
      status: json['status'] as int,
      h5p_url: json['h5p_url'] as String,
      h5pname: json['h5pname'] as String,
      content_json: json['content_json'] as String,
      h5p_json: json['h5p_json'] as String,
    );

Map<String, dynamic> _$HfiveContentToJson(HfiveContent instance) =>
    <String, dynamic>{
      'status': instance.status,
      'h5p_url': instance.h5p_url,
      'h5pname': instance.h5pname,
      'content_json': instance.content_json,
      'h5p_json': instance.h5p_json,
    };
