// Future<File> getLocalFile(String filename) async {
//   String dir = "${await FileSystemUtil().extDownloadsPath}/HE_Health";
//   File f = File('$dir$filename');
//   return f;
// }

import 'dart:io';

import 'package:he/service/permit_fofi_service.dart';
import 'package:he_api/he_api.dart';
import 'package:path_provider/path_provider.dart';

class FoFiRepository {
  final String appDir = 'nl_health_app_storage';
  // FoFiRepository(String getexternaldownlodpath, Directory getdirectory);

  // @override
  File getLocalFileHe(String filename) {
    String dir = "${PermitFoFiService.externalDownlodPath}/$appDir/HE_Health";
    File f = File('$dir$filename');
    return f;
  }

  File getLocalFileHeZip() {
    String dir =
        "${PermitFoFiService.externalDownlodPath}/$appDir/2644HE_Health.zip";
    File f = File(dir);
    return f;
  }

  // @override
  Future<bool> checkDirectoryOrCreateHe(String path) async {
    // Directory directory = await getApplicationDocumentsDirectory();
    Directory directory = PermitFoFiService.directory;
    var folder = Directory('${directory.path}/$path');
    if (folder.existsSync()) {
      return true;
    } else {
      var newDirectory = await folder.create(recursive: true);
      return newDirectory.exists();
    }
  }

// Helper function for writing content to a file
  Future<void> writeFileContent(String path, String content) async {
    if (File(path).existsSync()) {
      String existingContent = await File(path).readAsString();
      if (existingContent != content) {
        await File(path).writeAsString(content);
      }
    } else {
      await File(path).create(recursive: true);
      await File(path).writeAsString(content);
    }
  }

  // Future<void> manageHelloFile(HfiveContent hFiveContent, int contextid) async {
  //   Directory directory = await getApplicationDocumentsDirectory();
  //
  //   // define the path to the main directory
  //   String mainDirPath = "${directory.path}/$contextid/${hFiveContent.h5pname}";
  //
  //   // ensure the main directory exists
  //   bool mainDirExists = await checkDirectoryOrCreateHe(mainDirPath);
  //   if (!mainDirExists) {
  //     // create the main directory if it does not exist
  //     await Directory(mainDirPath).create(recursive: true);
  //   }
  //
  //   // define the path to the content directory
  //   String contentDirPath = "$mainDirPath/content";
  //
  //   // ensure the content directory exists
  //   bool contentDirExists = await checkDirectoryOrCreateHe(contentDirPath);
  //   if (!contentDirExists) {
  //     // create the content directory if it does not exist
  //     await Directory(contentDirPath).create(recursive: true);
  //   }
  //
  //   // define the path to the h5p.json file and write the h5p_json data
  //   String h5pJsonPath = "$mainDirPath/h5p.json";
  //   await writeFileContent(h5pJsonPath, hFiveContent.h5p_json);
  //
  //   // define the path to the content.json file and write the content_json data
  //   String contentJsonPath = "$contentDirPath/content.json";
  //   await writeFileContent(contentJsonPath, hFiveContent.content_json);
  // }
  Future<void> manageHelloFile(HfiveContent hFiveContent, int contextid) async {
    Directory directory = await getApplicationDocumentsDirectory();

    // Define the path to the parent directory (h5pcontent)
    String parentDirPath = "${directory.path}/h5pcontent";

    // Ensure the parent directory exists
    bool parentDirExists = await checkDirectoryOrCreateHe(parentDirPath);
    if (!parentDirExists) {
      // Create the parent directory if it does not exist
      await Directory(parentDirPath).create(recursive: true);
    }

    // Define the path to the main directory
    String mainDirPath = "$parentDirPath/$contextid/${hFiveContent.h5pname}";

    // Ensure the main directory exists
    bool mainDirExists = await checkDirectoryOrCreateHe(mainDirPath);
    if (!mainDirExists) {
      // Create the main directory if it does not exist
      await Directory(mainDirPath).create(recursive: true);
    }

    // Define the path to the content directory
    String contentDirPath = "$mainDirPath/content";

    // Ensure the content directory exists
    bool contentDirExists = await checkDirectoryOrCreateHe(contentDirPath);
    if (!contentDirExists) {
      // Create the content directory if it does not exist
      await Directory(contentDirPath).create(recursive: true);
    }

    // Define the path to the h5p.json file and write the h5p_json data
    String h5pJsonPath = "$mainDirPath/h5p.json";
    await writeFileContent(h5pJsonPath, hFiveContent.h5p_json);

    // Define the path to the content.json file and write the content_json data
    String contentJsonPath = "$contentDirPath/content.json";
    await writeFileContent(contentJsonPath, hFiveContent.content_json);
  }
}
