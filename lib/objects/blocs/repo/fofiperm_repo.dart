// Future<File> getLocalFile(String filename) async {
//   String dir = "${await FileSystemUtil().extDownloadsPath}/HE_Health";
//   File f = File('$dir$filename');
//   return f;
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:he/service/permit_fofi_service.dart';
import 'package:he_api/he_api.dart';

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
//   Future<void> writeFileContent(String path, String content) async {
//     if (File(path).existsSync()) {
//       String existingContent = await File(path).readAsString();
//       if (existingContent != content) {
//         await File(path).writeAsString(content);
//       }
//     } else {
//       await File(path).create(recursive: true);
//       await File(path).writeAsString(content);
//     }
//   }
  Future<void> writeFileContent(String path, String content) async {
    File file = File(path);

    if (file.existsSync()) {
      String existingContent = await file.readAsString();

      if (existingContent != content) {
        if (path.endsWith('index.html')) {
          debugPrint("YESY I ENDWITH HTML");
          file.writeAsBytesSync(utf8.encode(content));
        } else {
          await file.writeAsString(content);
        }
      }
    } else {
      await file.create(recursive: true);

      if (path.endsWith('index.html')) {
        debugPrint("YESY I ENDWITH HTML");
        file.writeAsBytesSync(utf8.encode(content));
      } else {
        await file.writeAsString(content);
      }
    }
  }

  bool checkFilePresentHe(String path) {
    return File(path).existsSync();
  }

  File getLocalHttpServiceIndex() {
    // String dir = PermitFoFiService.directory.path;
    String dir = "${PermitFoFiService.directory.path}/h5pcontent";
    File f = File(dir);
    return f;
  }

  Future<void> manageHelloFile(HfiveContent hFiveContent, int contextid) async {
    // Directory directory = await getApplicationDocumentsDirectory();
    Directory directory = PermitFoFiService.directory;
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
    // String indexHtmlPath = "$parentDirPath/$contextid/index.html";
    String indexHtmlPath = "$parentDirPath/index.html";
    String pageHtmlData = """
    <!doctype html>
<html lang="en">

<head>
    <title>Interactive Content</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <script type="text/javascript" src="dist/main.bundle.js"></script>
    <style>
        html,
        body,
        #h5p-container-window {
            height: 100%;
            margin: 0;
            padding: 10px 1px 0px 1px;
            /* top padding is 10px, right, bottom and left are 1px */
        }
    </style>
</head>

<body>
    <div id="h5p-container-window"></div>
    <script type="text/javascript">
        const el = document.getElementById("h5p-container-window");
        const options = {
            h5pJsonPath: "$contextid/${hFiveContent.h5pname}",
            frameJs: "dist/frame.bundle.js",
            frameCss: "dist/styles/h5p.css",
            librariesPath: "sharedlibraries"
        }
        new H5PStandalone.H5P(el, options);
    </script>
</body>

</html>
          """;
    await writeFileContent(indexHtmlPath, pageHtmlData);
  }

  static File urlH5p(int contextid) {
    Directory directory = PermitFoFiService.directory;
    String urlToServe = "${directory.path}/h5pcontent/$contextid/index.html";
    // return urlToServe;
    return File(urlToServe);
  }
}
