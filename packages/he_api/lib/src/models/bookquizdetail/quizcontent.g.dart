// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quizcontent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizContent _$QuizContentFromJson(Map<String, dynamic> json) => QuizContent(
      html: json['html'] as String,
      layout: json['layout'] as int,
      currentpage: json['currentpage'] as int,
      state: json['state'] as String,
      nextpage: json['nextpage'] as int,
      quizlist: (json['quizlist'] as List<dynamic>?)
          ?.map((e) => QuizContent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuizContentToJson(QuizContent instance) =>
    <String, dynamic>{
      'html': instance.html,
      'layout': instance.layout,
      'currentpage': instance.currentpage,
      'state': instance.state,
      'nextpage': instance.nextpage,
      'quizlist': instance.quizlist,
    };
