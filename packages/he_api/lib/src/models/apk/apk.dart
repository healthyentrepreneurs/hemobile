import 'package:json_annotation/json_annotation.dart';

/// {@template apk}
/// [Apk] represents user without content.
/// {@contemplate}
///
part 'apk.g.dart';

@JsonSerializable()
class Apk {
  /// {@macro apk}
  const Apk(
      {required this.version,
      required this.url,
      required this.releasenotes,
      required this.releasedate,
      required this.sha256checksum,
      required this.appname,
      required this.packagename,
      required this.buildnumber,
      required this.buildsignature});

  final String version;
  final String url;
  final String releasenotes;
  final String releasedate;
  final String sha256checksum;
  final String appname;
  final String packagename;
  final String buildnumber;
  final String buildsignature;

  factory Apk.fromJson(Map<String, dynamic> json) =>
      _$ApkFromJson(json);
}
