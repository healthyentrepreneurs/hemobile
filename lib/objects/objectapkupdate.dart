// To parse this JSON data, do
class ObjectApkUpdate {
  ObjectApkUpdate({
    required this.version,
    required this.seen,
    required this.updated,

  });

  String version;
  bool seen;
  bool updated;

  factory ObjectApkUpdate.fromJson(Map<String, dynamic> json) => ObjectApkUpdate(
    version: json["version"],
    seen: json["seen"],
    updated: json["updated"],
  );
  Map<String, dynamic> toJson() => {
    "version": version,
    "seen": seen,
    "updated": updated,
  };
}
