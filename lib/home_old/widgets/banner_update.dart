import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/helper/helper_functions.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/objects/objectapk.dart';
import 'package:he/objects/objectapkupdate.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_and_core;
import 'package:install_plugin_v2/install_plugin_v2.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

//Async Help https://camposha.info/flutter/flutter-async-loading/#gsc.tab=0
class UserInformation extends StatefulWidget {
  final String userId;
  // final Future<ObjectApkUpdate> currentV;
  const UserInformation({Key? key, required this.userId}) : super(key: key);
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  late ObjectApkUpdate _newUpdate;
  double _progress = 1;
  late bool _isButtonDisabled;
  late bool _isDownloading;
  final storageRef = FirebaseStorage.instance.ref();
  late final Function(String val) function;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  Widget _showMaterialBanner(
      BuildContext context,
      DocumentReference<Map<String, dynamic>> updateStatus,
      ObjectApkUpdate newUpdate,
      ObjectApk globalVersion) {
    late Directory directory;
    final mainOfflinePath = FileSystemUtil().extDownloadsPath;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(
        //   height: 20,
        // ),
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
          content: Text(globalVersion.releasenotes,
              style: const TextStyle(color: ToolUtils.colorGreenOne)),
          leading: const Icon(Icons.update_outlined,
              size: 30.0, color: ToolUtils.colorBlueOne),
          backgroundColor: const Color(0xFFE0E0E0),
          // contentTextStyle: const TextStyle(fontSize: 16, color: Colors.indigo),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                // padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 14),
              ),
              onPressed: _isButtonDisabled
                  ? null
                  : () async {
                      setState(() {
                        _isButtonDisabled = true;
                      });
                      newUpdate.seen = true;
                      updateStatus.set(newUpdate.toJson());
                      debugPrint(
                          "Seen Yes and ${newUpdate.toJson()} and $_progress");
                    },
              child: const Text('DISMISS',
                  style: TextStyle(color: ToolUtils.redColor)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                // padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 14),
              ),
              onPressed: _isDownloading
                  ? null
                  : () async {
                      setState(() {
                        _isButtonDisabled = true;
                        _isDownloading = true;
                      });
                      // android:requestLegacyExternalStorage="true"
                      const permission = Permission.storage;
                      final status = await permission.status;
                      debugPrint('>>>Status $status');

                      /// here it is coming as PermissionStatus.granted
                      if (status != PermissionStatus.granted) {
                        await permission.request();
                        if (await permission.status.isGranted) {
                          ///perform other stuff to download file
                        } else {
                          await permission.request();
                        }
                        debugPrint('>>> ${await permission.status}');
                      }
                      debugPrint(
                          '>>> appName ${_packageInfo.appName} packageName ${_packageInfo.packageName} version ${_packageInfo.version} buildNumber ${_packageInfo.buildNumber} buildSignature ${_packageInfo.buildSignature}');
                      final islandRef = storageRef.child("app.apk");
                      directory = Directory(await mainOfflinePath);
                      String filePath = '${directory.path}/app.apk';
                      File file = File(filePath);
                      final downloadTask = islandRef.writeToFile(file);
                      downloadTask.snapshotEvents.listen((taskSnapshot) {
                        // value
                        int downloadedLength = taskSnapshot.totalBytes;
                        switch (taskSnapshot.state) {
                          case TaskState.running:
                            _progress = taskSnapshot.bytesTransferred /
                                downloadedLength;
                            updateProgress(_progress);
                            // debugPrint("progress bytes ${taskSnapshot.bytesTransferred}");
                            debugPrint('>>> running');
                            break;
                          case TaskState.paused:
                            _progress = taskSnapshot.bytesTransferred /
                                downloadedLength;
                            updateProgress(_progress);
                            debugPrint('>>> paused');
                            // debugPrint("paused bytes ${taskSnapshot.bytesTransferred}");
                            break;
                          case TaskState.success:
                            _progress = taskSnapshot.bytesTransferred /
                                downloadedLength;
                            updateProgress(_progress);
                            onClickInstallApk(
                                filePath, newUpdate, updateStatus);
                            setState(() {
                              _isButtonDisabled = false;
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
                      // setState(() {});
                    },
              child: const Text(
                'UPDATE',
                style: TextStyle(color: ToolUtils.colorBlueOne),
              ),
            ),
          ],
        )
      ],
    );
  }

  void onClickInstallApk(String _apkFilePath, ObjectApkUpdate newUpdate,
      DocumentReference<Map<String, dynamic>> updateStatus) async {
    // https://pub.dev/packages/install_plugin_v2/install
    if (_apkFilePath.isEmpty) {
      debugPrint('make sure the apk file is set');
      return;
    }
    var permissions = await Permission.storage.status;
    if (permissions.isGranted) {
      var file = File(_apkFilePath);
      var isExists = await file.exists();
      // print('onClickInstallApk _apkFilePath $_apkFilePath exists $isExists');
      InstallPlugin.installApk(_apkFilePath, 'app.healthyentrepreneurs.nl.he')
          .then((result) {
        //You will confirm with app version
        if (result == 'Success') {
          newUpdate.seen = true;
          // newUpdate.updated = true;
          updateStatus.set(newUpdate.toJson());
        }
        debugPrint('install apk $result');
      }).catchError((error) {
        debugPrint('install apk error: $error');
      });
    } else {
      debugPrint('Permission request fail!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final apks = FirebaseFirestore.instance.collection('apks');
    final Stream<DocumentSnapshot> _userStream =
        apks.doc('latest').snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          ObjectApk globalVersion =
              ObjectApk.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          // debugPrint("App version ${_packageInfo.version} and Latest Apk ${globalVersion.version}");
          var _updateStatus = apks.doc(widget.userId);

          _updateStatus.get().then((value) => {
                if (value.exists)
                  {
                    _updateStatus
                        .snapshots()
                        .first
                        .asStream()
                        .first
                        .then((value) => {
                              _newUpdate = ObjectApkUpdate.fromJson(
                                  value.data() as Map<String, dynamic>),
                              printOnlyDebug(
                                  "Apk Update ${_newUpdate.updated}"),
                              if (_newUpdate.updated == false &&
                                  _packageInfo.version == globalVersion.version)
                                {
                                  _newUpdate.updated = true,
                                  _newUpdate.seen = true,
                                  _newUpdate.version = globalVersion.version,
                                  _updateStatus.set(_newUpdate.toJson()),
                                }
                            }),
                    // printOnlyDebug("Apk Update ${_newUpdate.seen}")
                  }
                else
                  {
                    _newUpdate = ObjectApkUpdate(
                        version: _packageInfo.version,
                        seen: true,
                        updated: false),
                    _updateStatus
                        .set(
                          _newUpdate.toJson(),
                          SetOptions(merge: true),
                        )
                        .then((value) => printOnlyDebug(
                            "'Updated' Version ${_packageInfo.version} default"))
                        .catchError((error) =>
                            {printOnlyDebug("Failed to Update Apk: $error")})
                  }
              });
          return StreamBuilder<DocumentSnapshot>(
              stream: apks.doc(widget.userId).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  ObjectApkUpdate localUpdate = ObjectApkUpdate.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>);
                  if (localUpdate.seen == false) {
                    return _showMaterialBanner(
                        context, _updateStatus, _newUpdate, globalVersion);
                  } else {
                    // printOnlyDebug("sing xx");
                    return const SizedBox(height: 0.0);
                  }
                } else {
                  return const SizedBox(height: 0.0);
                }
              });
        } else {
          return const SizedBox(
            // width: double.infinity,
            child: InkWell(
              child: CircularProgressIndicator(),
            ),
            //
          );
        }
      },
    );
  }

  void updateProgress(double newpercentate) {
    setState(() {
      debugPrint("Progress total $_progress and $newpercentate");
      _progress = newpercentate;
    });
  }

  Future<void> _initPackageInfo() async {
    // https://pub.dev/packages/package_info_plus/versions/1.4.0/example
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    setState(() {
      _isButtonDisabled = false;
      _isDownloading = false;
      _progress = 1;
    });
  }
}
