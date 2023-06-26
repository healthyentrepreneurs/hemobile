import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/impl/iapk_repo.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';

part 'apk_event.dart';
part 'apk_state.dart';

// @Phila One
@injectable
class ApkBloc extends Bloc<ApkEvent, ApkState> {
  ApkBloc({required IApkRepository repository})
      : apkBlocRepository = repository,
        super(ApkLoadingState()) {
    on<FetchApkEvent>(_onFetchApkEvent);
    _logsStreamSub = apkBlocRepository
        .getLatestApk()
        .listen((event) => add(FetchApkEvent(event)));
  }
  final IApkRepository apkBlocRepository;
  late final StreamSubscription<Either<Failure, DocumentSnapshot>>
      _logsStreamSub;

  @override
  Future<void> close() {
    _logsStreamSub.cancel();
    return super.close();
  }

  _onFetchApkEvent(FetchApkEvent event, Emitter<ApkState> emit) async {
    var apkInfo = await apkBlocRepository.getAppApk();
    debugPrint("PhilaNjovu ${apkInfo?.toJson().toString()}");
    emit(event.apkdoc.fold(
      (failure) => ApkErrorState(failure),
      (apkdoc) => ApkFetchedState(apkdoc, apkInfo),
    ));
  }
}
