part of 'apk_bloc.dart';

abstract class ApkState extends Equatable {
  const ApkState();
}
class ApkLoadingState extends ApkState {
  @override
  List<Object> get props => [];
}

class ApkFetchedState extends ApkState {
  final DocumentSnapshot snapshot;
  final PackageInfo? apkinfo;
  const ApkFetchedState(this.snapshot, this.apkinfo);
  @override
  List<Object> get props => [snapshot, apkinfo!];
}

class ApkErrorState extends ApkState {
  final Failure error;
  const ApkErrorState(this.error);
  @override
  List<Object> get props => [error];
}
