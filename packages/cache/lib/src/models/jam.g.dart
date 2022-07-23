// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'jam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jam _$JamFromJson(Map<String, dynamic> json) {
  return $checkedNew('Jam', json, () {
    final val = Jam(
      $checkedConvert(json, 'name', (v) => v as String),
      $checkedConvert(json, 'email', (v) => v as String),
    );
    return val;
  });
}
