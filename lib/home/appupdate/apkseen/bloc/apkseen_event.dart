part of 'apkseen_bloc.dart';

@immutable
abstract class ApkseenEvent extends Equatable{
  const ApkseenEvent();
  @override
  List<Object> get props => [];
}

class CheckForUpdateEvent extends ApkseenEvent {}

class UpdateSeenStatusEvent extends ApkseenEvent {
  final Apkupdatestatus status;
  const UpdateSeenStatusEvent({required this.status});
  @override
  List<Object> get props => [status];
}
class AppUpdatedStatusEvent extends ApkseenEvent {
  final String heverion;
  const AppUpdatedStatusEvent({required this.heverion});
  @override
  List<Object> get props => [heverion];
}

class DeleteSeenStatusEvent extends ApkseenEvent {}

