import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'apkupdatestatus.g.dart';

@JsonSerializable()
class Apkupdatestatus extends Equatable {
  const Apkupdatestatus({
    required this.seen,
    required this.updated,
  });
  final bool seen;
  final bool updated;

  factory Apkupdatestatus.fromJson(Map<String, dynamic> json) =>
      _$ApkupdatestatusFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ApkupdatestatusToJson(this);

  static final toApkupdatestatusOrNull = (Object? s) => s == null
      ? null
      : Apkupdatestatus.fromJson(
          jsonDecode(s as String) as Map<String, dynamic>,
        );
  static String? apkupdatestatusToString(Apkupdatestatus? u) =>
      u == null ? null : jsonEncode(u);

  @override
  List<Object?> get props => [seen, updated];
}
