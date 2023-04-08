part of 'apkseen_bloc.dart';

class ApkseenState {
  final Apkupdatestatus status;
  ApkseenState({required this.status});

  ApkseenState copyWith({
    bool? seen,
    bool? updated,
    String? heversion,
  }) {
    return ApkseenState(
        status: Apkupdatestatus(
            seen: seen ?? status.seen,
            updated: updated ?? status.updated,
            heversion: heversion ?? status.heversion));
  }

  //create ApkseenState.fromJson and ApkseenState.toJson
  factory ApkseenState.fromJson(Map<String, dynamic> json) {
    return ApkseenState(
        status: Apkupdatestatus(
            seen: json['seen'] as bool,
            updated: json['updated'] as bool,
            heversion: json['heversion'] as String));
  }
  Map<String, dynamic> toJson() {
    return {
      'seen': status.seen,
      'updated': status.updated,
      'heversion': status.heversion,
    };
  }
}
