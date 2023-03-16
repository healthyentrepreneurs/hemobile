import 'dart:io';

class FileFolderApi {
  static String? externalDownlodPath;

  static File getLocalFileHe(String filename) {
    final dir = '$externalDownlodPath/nl_health_app_storage/HE_Health';
    final f = File('$dir$filename');
    return f;
  }

  static bool checkFilePresentHe(String path) {
    if (File(path).existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkDirectoryOrCreateHe(String path) async {
    final folder = Directory(path);
    if (folder.existsSync()) {
      return true;
    } else {
      final directory = await folder.create(recursive: true);
      return directory.existsSync();
    }
  }
}

