// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'lang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lang _$LangFromJson(Map<String, dynamic> json) {
  return $checkedNew('Lang', json, () {
    final val = Lang(
      id: $checkedConvert(json, 'id', (v) => v as int?),
      code: $checkedConvert(json, 'code', (v) => v as String),
      uppercode: $checkedConvert(json, 'uppercode', (v) => v as String?),
    );
    return val;
  });
}
