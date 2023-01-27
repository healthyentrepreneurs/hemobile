part of 'apkseen_bloc.dart';

class ApkseenState {
  final Apkupdatestatus status;
  ApkseenState({required this.status});

  ApkseenState copyWith({
    bool? seen,
    bool? updated,
  }) {
    return ApkseenState(
        status: Apkupdatestatus(
            seen: seen ?? status.seen, updated: updated ?? status.updated));
  }

  //create ApkseenState.fromJson and ApkseenState.toJson
  factory ApkseenState.fromJson(Map<String, dynamic> json) {
    return ApkseenState(
        status: Apkupdatestatus(
            seen: json['seen'] as bool, updated: json['updated'] as bool));
  }
  Map<String, dynamic> toJson() {
    return {
      'seen': status.seen,
      'updated': status.updated,
    };
  }
}
