import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:he/injection.dart';

import '../objects/blocs/repo/repo.dart';

const _iconSize = 29.0;
Future<String> getImageUrlFromFirebase(String path) async {
  final storageRef = getIt<FirebaseStorage>().ref();
  final ref = storageRef.child(path);
  final String imageUrl = await ref.getDownloadURL();
  return imageUrl;
}

Either<bool, String> convertUrlToWalahPath(String url, int changeType) {
  Either<bool, String> bucketUrlOrError =
      formatForBucket(url, changeType); // replace 2 with your changeType
  return bucketUrlOrError.fold(
      (error) => Left(error), (bucketUrl) => Right(bucketUrl));
}

Either<bool, String> formatForBucket(String stringUrl, int changeType) {
  String basePath = '';
  switch (changeType) {
    case 0:
      basePath = '/bookresource/';
      break;
    case 1:
      basePath = '/courseresource/';
      break;
    case 2:
      basePath = '/surveyicon/';
      break;
    case 3:
      basePath = '/h5presource/';
      break;
    default:
      return const Left(false);
  }

  String bucketUrl = stringUrl.contains('http://')
      ? stringUrl.replaceFirst('http://', basePath)
      : stringUrl.replaceFirst('https://', basePath);

  if (bucketUrl.contains('?token')) {
    int i = bucketUrl.indexOf('?');
    bucketUrl = bucketUrl.substring(0, i);
  }

  return Right(bucketUrl);
}

// Widget heIconOffline(String photo, FoFiRepository fofi) {
//   try {
//     Uint8List imageData = fofi.getLocalFileHeFileWalah(photo);
//     return SizedBox(
//       key: UniqueKey(),
//       width: 50,
//       height: 50,
//       child: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               color: Colors.grey,
//               shape: BoxShape.circle,
//             ),
//           ),
//           Center(
//             child: CircleAvatar(
//               radius: 25,
//               backgroundImage: MemoryImage(imageData),
//             ),
//           ),
//         ],
//       ),
//     );
//   } catch (e) {
//     debugPrint('Error loading local file: $e');
//     return const CircleAvatar(
//       radius: 25,
//       child: Icon(Icons.broken_image),
//     );
//   }
// }
Widget heIconOffline(
  String photo,
  FoFiRepository fofi, {
  double width = 50,
  double height = 50,
  double radius = 25,
}) {
  try {
    Uint8List imageData = fofi.getLocalFileHeFileWalah(photo);
    return SizedBox(
      key: UniqueKey(),
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Center(
            child: CircleAvatar(
              radius: radius,
              backgroundImage: MemoryImage(imageData),
            ),
          ),
        ],
      ),
    );
  } catch (e) {
    debugPrint('Error loading local file: $e');
    return CircleAvatar(
      radius: radius,
      child: const Icon(Icons.broken_image),
    );
  }
}
