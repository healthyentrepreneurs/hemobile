// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datacode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataCode _$DataCodeFromJson(Map<String, dynamic> json) => DataCode(
      code: json['code'] as int?,
      msg: json['msg'] as String?,
      data: json['data'] == null
          ? null
          : User.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataCodeToJson(DataCode instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };
