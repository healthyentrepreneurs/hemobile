// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookquiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookQuiz _$BookQuizFromJson(Map<String, dynamic> json) => BookQuiz(
      id: json['id'] as int,
      instance: json['instance'] as int?,
      modicon: json['modicon'] as String?,
      modname: json['modname'] as String?,
      modplural: json['modplural'] as String?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      uservisible: json['uservisible'] as bool?,
      visible: json['visible'] as int?,
      customdata: json['customdata'] as String?,
      contextid: json['contextid'] as int?,
    );

Map<String, dynamic> _$BookQuizToJson(BookQuiz instance) => <String, dynamic>{
      'id': instance.id,
      'instance': instance.instance,
      'modicon': instance.modicon,
      'modname': instance.modname,
      'modplural': instance.modplural,
      'name': instance.name,
      'url': instance.url,
      'uservisible': instance.uservisible,
      'visible': instance.visible,
      'customdata': instance.customdata,
      'contextid': instance.contextid,
    };
