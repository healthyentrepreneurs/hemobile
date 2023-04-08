import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:install_plugin_v2/install_plugin_v2.dart';

import '../../apkseen/apkseen.dart';

class InstallApk extends StatelessWidget {
  final String heversion;
  const InstallApk({super.key, required this.heversion});

  Future<String?> installHeApk() async {
    // var permissions = await Permission.storage.status;
    // if (permissions.isGranted) {
    // var file = File(_apkFilePath);
    // var isExists = await file.exists();
    final _mainOfflinePath = FileSystemUtil().extDownloadsPath;
    Directory _directory = Directory(await _mainOfflinePath);
    String _filePath = '${_directory.path}/app.apk';
    return await InstallPlugin.installApk(
        _filePath, 'app.healthyentrepreneurs.nl.he');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: installHeApk(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final resultInfo = snapshot.data!;
            if (resultInfo == 'Success') {
              BlocProvider.of<ApkseenBloc>(context)
                  .add(AppUpdatedStatusEvent(heverion: heversion));
              debugPrint("Arthur Success Apk $resultInfo");
            } else {
              debugPrint("Arthur Success Apk $resultInfo");
            }
            return const SizedBox(height: 0.0);
          } else if (snapshot.hasError) {
            debugPrint("Installing Apk ${snapshot.error}");
            return const SizedBox(height: 0.0);
          }
        }
        return const SizedBox(height: 0.0);
      },
    );
  }
}
