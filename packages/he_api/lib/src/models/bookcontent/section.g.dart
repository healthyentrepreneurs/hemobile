// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Section _$SectionFromJson(Map<String, dynamic> json) => Section(
      id: json['id'] as int,
      name: json['name'] as String?,
      section: json['section'] as int?,
      uservisible: json['uservisible'] as bool?,
    );

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'section': instance.section,
      'uservisible': instance.uservisible,
    };
