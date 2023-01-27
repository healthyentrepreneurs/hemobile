import 'package:json_annotation/json_annotation.dart';

part 'apkupdatestatus.g.dart';

@JsonSerializable()
class Apkupdatestatus {
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
}
