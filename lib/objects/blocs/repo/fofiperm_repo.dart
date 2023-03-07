// Future<File> getLocalFile(String filename) async {
//   String dir = "${await FileSystemUtil().extDownloadsPath}/HE_Health";
//   File f = File('$dir$filename');
//   return f;
// }

import 'dart:io';

import '../../../service/permit_fofi_service.dart';

// @LazySingleton(as: IFoFiRepository)
class FoFiRepository {
  final String appDir = 'nl_health_app_storage';
  // FoFiRepository(String getexternaldownlodpath, Directory getdirectory);

  // @override
  File getLocalFileHe(String filename) {
    String dir = "${PermitFoFiService.externalDownlodPath}/$appDir/HE_Health";
    File f = File('$dir$filename');
    return f;
  }

  // @override
  bool checkFilePresentHe(String path) {
    if (File(path).existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  // @override
  Future<bool> checkDirectoryOrCreateHe(String path) async {
    var folder = Directory(path);
    if (folder.existsSync()) {
      return true;
    } else {
      var directory = await folder.create(recursive: true);
      return directory.exists();
    }
  }
}
