// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'lang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lang _$LangFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Lang',
      json,
      ($checkedConvert) {
        final val = Lang(
          id: $checkedConvert('id', (v) => v as int?),
          code: $checkedConvert('code', (v) => v as String? ?? ''),
          uppercode: $checkedConvert('uppercode', (v) => v as String?),
        );
        return val;
      },
    );
