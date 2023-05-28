import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';
import 'package:path/path.dart' as p;

// class HELocalhostServer {
//   HttpServer? _server;
//   final Map<String, ContentType> mimeTypes = {
//     '.html': ContentType.html,
//     '.js': ContentType('application', 'javascript'),
//     '.css': ContentType('text', 'css'),
//     '.mp3': ContentType('audio', 'mpeg'),
//     '.mp4': ContentType('video', 'mp4'),
//     '.png': ContentType('image', 'png'),
//     '.jpg': ContentType('image', 'jpeg'),
//     '.woff': ContentType('font', 'woff'),
//     '.woff2': ContentType('font', 'woff2'),
//     '.ttf': ContentType('font', 'ttf'),
//     '.otf': ContentType('font', 'otf'),
//     // eot,svg
//     // Add other file types if needed
//   };
//   Future<void> start({int port = 8080}) async {
//     final FoFiRepository _fofi = FoFiRepository();
//     _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
//     print(
//         'Server running on IP: ${_server!.address} on PORT: ${_server!.port}');
//     _server!.listen((HttpRequest request) async {
//       final directoryPath = _fofi.getLocalHttpServiceIndex().path;
//       debugPrint("BOBIURL $directoryPath");
//       String requestPath =
//           request.uri.path == '/' ? '/index.html' : request.uri.path;
//       // Adjust this based on your actual file location
//       final File file = File('$directoryPath$requestPath');
//       if (await file.exists()) {
//         try {
//           // Determine the Content-Type based on the file extension
//           final String extension = p.extension(file.path);
//           final ContentType contentType =
//               mimeTypes[extension] ?? ContentType.binary;
//           request.response.headers.contentType = contentType;
//
//           await request.response.addStream(file.openRead());
//         } catch (e) {
//           print("Couldn't read file: $e");
//           exit(-1);
//         }
//       } else {
//         request.response
//           ..statusCode = HttpStatus.notFound
//           ..write('Not found');
//         await request.response.close();
//       }
//     });
//   }
//
//   void stop() {
//     _server?.close(force: true);
//   }
// }
