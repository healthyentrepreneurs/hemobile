// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'jam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jam _$JamFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Jam',
      json,
      ($checkedConvert) {
        final val = Jam(
          $checkedConvert('name', (v) => v as String),
          $checkedConvert('email', (v) => v as String),
        );
        return val;
      },
    );
