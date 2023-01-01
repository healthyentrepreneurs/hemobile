// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contentstructure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentStructure _$ContentStructureFromJson(Map<String, dynamic> json) =>
    ContentStructure(
      title: json['title'] as String,
      href: json['href'] as String,
      level: json['level'] as int,
      hidden: json['hidden'] as String,
    );

Map<String, dynamic> _$ContentStructureToJson(ContentStructure instance) =>
    <String, dynamic>{
      'title': instance.title,
      'href': instance.href,
      'level': instance.level,
      'hidden': instance.hidden,
    };
