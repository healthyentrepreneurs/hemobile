import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:he/injection.dart';

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
