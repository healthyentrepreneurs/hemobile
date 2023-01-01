// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Survey _$SurveyFromJson(Map<String, dynamic> json) => Survey(
      id: json['id'] as String,
      createdby: json['createdby'] as String,
      datecreated: json['datecreated'] as String,
      image: json['image'] as String,
      image_url_small: json['image_url_small'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      surveydesc: json['surveydesc'] as String,
      surveyjson: json['surveyjson'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$SurveyToJson(Survey instance) => <String, dynamic>{
      'id': instance.id,
      'createdby': instance.createdby,
      'datecreated': instance.datecreated,
      'image': instance.image,
      'image_url_small': instance.image_url_small,
      'name': instance.name,
      'slug': instance.slug,
      'surveydesc': instance.surveydesc,
      'surveyjson': instance.surveyjson,
      'type': instance.type,
    };
