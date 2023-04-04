import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'appudate_event.dart';
part 'appudate_state.dart';

@injectable
class AppudateBloc extends Bloc<AppUpdateEvent, AppudateState> {
  AppudateBloc() : super(AppudateState.initial()) {
    // transformer restartable to _onStartDownloading

    on<StartDownloading>(_onStartDownloading, transformer: restartable());
  }
  // final FirebaseStorage _storage = getIt<FirebaseStorage>();
  static final storageRef = getIt<FirebaseStorage>().ref();
  final FileSystemUtil _fileUtil = FileSystemUtil();

  FutureOr<void> _onStartDownloading(
      StartDownloading event, Emitter<AppudateState> emit) async {
    // final _appRef = storageRef.child("app.apk");
    debugPrint("AnitaData ${event.url}");
    final _appRef = storageRef.child(event.url);
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final granted = await Permission.storage.request().isGranted;
      if (!granted) {
        emit(AppudateState.error(
            ApkDownloadFailure("Storage permission not granted")));
        return;
      }
    }
    try {
      await _appRef.getDownloadURL();
      final file = File('${await _fileUtil.extDownloadsPath}/app.apk');
      if (file.existsSync()) await file.delete();
      final downloadTask = _appRef.writeToFile(file);
      emit(AppudateState.downloading());
      // await for (final taskSnapshot in downloadTask.snapshotEvents) {
      //   checkDownLoadState(taskSnapshot, emit);
      // }
      await emit.forEach(
        downloadTask.snapshotEvents,
        onData: (taskSnapshot) =>
            checkDownLoadState(taskSnapshot, emit) ??
            state, // handle Unhandled Exception: type 'Null' is not a subtype of type 'AppudateState'
      );
    } on FirebaseException {
      emit(AppudateState.error(ApkDownloadFailure("No Apk URL Download")));
    }
  }
}

checkDownLoadState(TaskSnapshot taskSnapshot, Emitter<AppudateState> emit) {
  switch (taskSnapshot.state) {
    case TaskState.running:
      debugPrint('>>> running');
      taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
      final progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
      emit(AppudateState.downloading(progress: progress));
      break;
    case TaskState.paused:
      debugPrint('>>> paused');
      taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
      final progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
      emit(AppudateState.downloading(progress: progress));
      break;
    case TaskState.success:
      final progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
      emit(AppudateState.downloaded(progress: progress));
      debugPrint('>>> success');
      break;
    case TaskState.canceled:
      emit(AppudateState.error(ApkDownloadFailure("Canceled Downloading")));
      break;
    case TaskState.error:
      emit(AppudateState.error(ApkDownloadFailure("Error Downloading")));
      break;
    default:
      debugPrint('>>> default');
  }
  // if (taskSnapshot.state == TaskState.success) {
  //   emit(AppudateState.downloaded());
  //   // return;
  // } else if (taskSnapshot.state == TaskState.error) {
  //   emit(AppudateState.error(ApkDownloadFailure("Error Downloading")));
  //   // return;
  // } else {
  //   final progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
  //   emit(AppudateState.downloading(progress: progress));
  // }
}
