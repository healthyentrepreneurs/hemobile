// To parse this JSON data, do
class ObjectApk {
  ObjectApk(
      {required this.version,
      required this.url,
      required this.releasenotes,
      required this.releasedate,
      required this.sha256checksum,
      required this.appname,
      required this.packagename,
      required this.buildnumber,
      required this.buildsignature});

  String version;
  String url;
  String releasenotes;
  String releasedate;
  String sha256checksum;
  String appname;
  String packagename;
  String buildnumber;
  String buildsignature;
  // Added
  /*appName: 'Unknown',
  packageName: 'Unknown',
  version: 'Unknown',
  buildNumber: 'Unknown',
  buildSignature: 'Unknown',*/

  factory ObjectApk.fromJson(Map<String, dynamic> json) => ObjectApk(
        version: json["version"],
        url: json["url"],
        releasenotes: json["releasenotes"],
        releasedate: json["releasedate"],
        sha256checksum: json["sha256checksum"],
        appname: json["appname"],
        packagename: json["packagename"],
        buildnumber: json["buildnumber"],
        buildsignature: json["buildsignature"],
      );
  Map<String, dynamic> toJson() => {
        "version": version,
        "url": url,
        "releasenotes": releasenotes,
        "releasedate": releasedate,
        "sha256checksum": sha256checksum,
        "appname": appname,
        "packagename": packagename,
        "buildnumber": buildnumber,
        "buildsignature": buildsignature,
      };
}
