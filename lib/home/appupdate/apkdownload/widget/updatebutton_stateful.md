import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/injection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theme_locale_repo/generated/l10n.dart';

class UpdateButtonApp extends StatefulWidget {
  // ignore: public_member_api_docs
  final DocumentSnapshot latestapk;
  const UpdateButtonApp({Key? key, required this.latestapk}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UpdateButtonApp();
  }
}

class _UpdateButtonApp extends State<UpdateButtonApp> {
  late bool _isDownloading;
  late bool _isButtonDisabled;
  final ScaffoldMessengerState _scaffold = scaffoldKey.currentState!;
  double _progress = 1;

  Future<void> _downloadFile() async {
    const permission = Permission.storage;
    final status = await permission.status;

    /// here it is coming as PermissionStatus.granted
    if (status != PermissionStatus.granted) {
      await permission.request();
      if (status.isGranted) {
        ///perform other stuff to download file
      } else {
        await permission.request();
      }
    }
    final storageRef = getIt<FirebaseStorage>().ref();

    final mainOfflinePath = FileSystemUtil().extDownloadsPath;
    Directory directory = Directory(await mainOfflinePath);
    String filePath = '${directory.path}/app.apk';
    File file = File(filePath);

    final islandRef = storageRef.child("app.apk");
    try {
      await islandRef.getDownloadURL();
      // islandRef.writeToFile(file).snapshotEvents.listen((event) { });
      // taskSnapshot.state
      if (file.existsSync()) await file.delete();
      final DownloadTask downloadTask = islandRef.writeToFile(file);
      debugPrint('Jaja Works');
      downloadTask.snapshotEvents.listen((taskSnapshot) {
        // value
        int downloadedLength = taskSnapshot.totalBytes;
        switch (taskSnapshot.state) {
          case TaskState.running:
            _progress = taskSnapshot.bytesTransferred / downloadedLength;
            updateProgress(_progress);
            // debugPrint("progress bytes ${taskSnapshot.bytesTransferred}");
            debugPrint('>>> running');
            break;
          case TaskState.paused:
            _progress = taskSnapshot.bytesTransferred / downloadedLength;
            updateProgress(_progress);
            debugPrint('>>> paused');
            // debugPrint("paused bytes ${taskSnapshot.bytesTransferred}");
            break;
          case TaskState.success:
            _progress = taskSnapshot.bytesTransferred / downloadedLength;
            updateProgress(_progress);
            // onClickInstallApk(filePath);
            setState(() {
              _isDownloading = false;
            });
            debugPrint('>>> success');
            break;
          case TaskState.canceled:
            debugPrint('>>> canceled');
            break;
          case TaskState.error:
            debugPrint('>>> error');
            break;
        }
      });
    } on FirebaseException catch (error) {
      // if the Object does not exists
      if (error.code == 'object-not-found') {
        _scaffold.showSnackBar(
          const SnackBar(
            content: Text(
              ' Not Found',
            ),
          ),
        );
      } else {
        debugPrint(
            'method@_downloadFile class@lib/home/appupdate/view/updatbutton.dart Error A ${error.code}');
      }
    }

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
    //       'at path: ${ref.fullPath} \n'
    //       'Wrote "${ref.fullPath}" to tmp-${ref.name}',
    //     ),
    //   ),
    // );
  }

  Future<void> _disMissed() async {}
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    Map<String, dynamic> data = widget.latestapk.data() as Map<String, dynamic>;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (_progress < 1) ...[

        LinearProgressIndicator(
          backgroundColor: Colors.red,
          color: ToolUtils.colorBlueOne,
          minHeight: 5,
          value: _progress,
        ),
      ],
      MaterialBanner(
        padding: const EdgeInsets.all(1),
        content: Text(data['releasenotes'],
            style: const TextStyle(color: ToolUtils.colorGreenOne)),
        leading: const Icon(Icons.update_outlined,
            size: 30.0, color: ToolUtils.colorBlueOne),
        backgroundColor: const Color(0xFFE0E0E0),
        // contentTextStyle: const TextStyle(fontSize: 16, color: Colors.indigo),
        actions: <Widget>[
          _DismissButton(
              isButtonDisabled: _isButtonDisabled, onPressed: _disMissed),
          _UpdateButton(isDownloading: _isDownloading, onPressed: _downloadFile)
        ],
      )
    ]);
  }

  void updateProgress(double newpercentate) {

    setState(() {
      debugPrint("Progress total $_progress and $newpercentate");
      _progress = newpercentate;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isDownloading = false;
      _isButtonDisabled = false;
      _progress = 1;
    });

  }
}

class _DismissButton extends StatelessWidget {
  const _DismissButton(
      {Key? key, required this.isButtonDisabled, required this.onPressed})
      : super(key: key);
  final bool isButtonDisabled;
  final Future<void> Function() onPressed;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    debugPrint(
        "What is here hey ");
    return TextButton(
      style: TextButton.styleFrom(
        // padding: const EdgeInsets.all(16.0),
        textStyle: const TextStyle(fontSize: 14),
      ),
      onPressed: isButtonDisabled //appupdatabloc.state.isDownloading
          ? null
          : onPressed,
      child: const Text('DISMISS', style: TextStyle(color: ToolUtils.redColor)),
    );
  }
}

class _UpdateButton extends StatelessWidget {
  const _UpdateButton(
      {Key? key, required this.isDownloading, required this.onPressed})
      : super(key: key);
  final bool isDownloading;
  final Future<void> Function() onPressed;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 14),
      ),
      onPressed: isDownloading //appupdatabloc.state.isDownloading
          ? null
          : onPressed,
      child:
          const Text('UPDATE', style: TextStyle(color: ToolUtils.colorBlueOne)),
    );
  }
}
