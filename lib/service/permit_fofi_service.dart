import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PermitFoFiService {
  static late Directory directory;
  static late String externalDownlodPath;
  static Future<PermitFoFiService> init() async {
    directory = await getApplicationDocumentsDirectory();
    externalDownlodPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    return PermitFoFiService();
  }

  // Directory get getDirectory => directory;
  // String get getExternalDownloadPath => externalDownlodPath;

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
  }
}
