import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he_storage/he_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'apkseen_event.dart';
part 'apkseen_state.dart';

// @injectable
class ApkseenBloc extends HydratedBloc<ApkseenEvent, ApkseenState> {
  final ApkupdateRepository _repository;
  ApkseenBloc({required ApkupdateRepository repository})
      : _repository = repository,
        super(ApkseenState(
            status: const Apkupdatestatus(
                seen: false, updated: false, heversion: ''))) {
    on<CheckForUpdateEvent>(_onCheckForUpdate);
    on<UpdateSeenStatusEvent>(_onUpdateSeenStatus);
    on<DeleteSeenStatusEvent>(_onDeleteSeenStatusEvent);
    on<AppUpdatedStatusEvent>(_onAppUpdatedStatusEvent);
  }

  FutureOr<void> _onCheckForUpdate(
      CheckForUpdateEvent event, Emitter<ApkseenState> emit) async {
    final status = await _repository.getSeenUpdateStatus();
    emit(ApkseenState(status: status));
    debugPrint('_onCheckForUpdate Not Seen ${status.toJson()}');
  }

  FutureOr<void> _onUpdateSeenStatus(
      UpdateSeenStatusEvent event, Emitter<ApkseenState> emit) async {
    await _repository.updateSeenUpdateStatus(event.status);
    emit(ApkseenState(status: event.status));
    debugPrint('onUpdateSeenStatus Not Seen ${event.status.toJson()}');
  }

  FutureOr<void> _onDeleteSeenStatusEvent(
      DeleteSeenStatusEvent event, Emitter<ApkseenState> emit) async {
    // implement delete seen status
    final status = await _repository.getSeenUpdateStatus();
    debugPrint('Before onDeleteSeenStatusEvent Not Seen ${status.toJson()}');
    await _repository.deleteSeenUpdateStatus();
    emit(ApkseenState(
        status:
            const Apkupdatestatus(seen: false, updated: false, heversion: '')));
    debugPrint(
        'After onDeleteSeenStatusEvent Not Seen ${state.status.toJson()}');
  }

  FutureOr<void> _onAppUpdatedStatusEvent(
      AppUpdatedStatusEvent event, Emitter<ApkseenState> emit) {
    emit(state.copyWith(updated: true, seen: true,heversion: event.heverion));
  }

  @override
  ApkseenState? fromJson(Map<String, dynamic> json) {
    return ApkseenState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ApkseenState state) {
    return state.toJson();
  }
}
