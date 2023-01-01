// To parse this JSON data, do
import 'package:json_annotation/json_annotation.dart';
part 'apkupdate.g.dart';

@JsonSerializable()
class ApkUpdate {
  // ignore: public_member_api_docs
  const ApkUpdate({
    required this.version,
    required this.seen,
    required this.updated,
  });
  final String version;
  final bool seen;
  final bool updated;

  factory ApkUpdate.fromJson(Map<String, dynamic> json) =>
      _$ApkUpdateFromJson(json);
}
