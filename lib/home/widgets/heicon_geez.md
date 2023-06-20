import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:he_api/he_api.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../objects/blocs/blocs.dart';

const _iconSize = 29.0;

class HeIcon extends StatelessWidget {
  const HeIcon({Key? key, this.photo, required this.fofi}) : super(key: key);
  final String? photo;
  final FoFiRepository fofi;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HenetworkBloc, HenetworkState>(
      builder: (_, state) => state.gstatus == HenetworkStatus.wifiNetwork
          ? ClipRRect(
              key: UniqueKey(),
              borderRadius: BorderRadius.circular(30.0),
              child: getNetworkImage(photo),
            )
          : heIconOffline(photo!, fofi),
    );
  }

  Widget getNetworkImage(String? url) {
    if (url != null &&
        url.startsWith('http') &&
        url.contains('uploadscustome')) {
      Either<bool, String> gcsPathOrError = convertUrlToWalahPath(url,2);
      return gcsPathOrError.fold(
        (error) {
          debugPrint('Original URL: $url'); // print original URL
          debugPrint('URL conversion failed'); // print error message
          return FadeInImage.memoryNetwork(
            width: 50,
            height: 50,
            placeholder: kTransparentImage,
            image: url,
            imageErrorBuilder: (context, error, stackTrace) {
              debugPrint('HeIconOnline@imageErrorBuilder');
              return const CircleAvatar(
                radius: _iconSize,
                child: Icon(Icons.broken_image),
              );
            },
          );
        },
        (gcsPath) {
          debugPrint('Original URL: $url'); // print original URL
          debugPrint('Converted URL: $gcsPath'); // print converted URL
          return FutureBuilder<File>(
            future: FirebaseCacheManager().getSingleFile(gcsPath,),
            builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // return const CircularProgressIndicator();
                return const CircleAvatar(
                  radius: _iconSize,
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.error != null) {
                  // If error occurred, display a broken image icon.
                  debugPrint('HeIconOnline@imageErrorBuilder');
                  return const CircleAvatar(
                    radius: _iconSize,
                    child: Icon(Icons.broken_image),
                  );
                } else {
                  return Image.file(
                    snapshot.data!,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('HeIconOnline@imageErrorBuilder');
                      return const CircleAvatar(
                        radius: _iconSize,
                        child: Icon(Icons.broken_image),
                      );
                    },
                  );
                }
              }
            },
          );
        },
      );
    } else if (url != null &&
        (url.startsWith('http://') || url.startsWith('https://'))) {
      return FadeInImage.memoryNetwork(
        width: 50,
        height: 50,
        placeholder: kTransparentImage,
        image: url,
        imageErrorBuilder: (context, error, stackTrace) {
          debugPrint('HeIconOnline@imageErrorBuilder');
          return const CircleAvatar(
            radius: _iconSize,
            child: Icon(Icons.broken_image),
          );
        },
      );
    } else {
      return const CircleAvatar(
        radius: _iconSize,
        child: Icon(Icons.broken_image),
      );
    }
  }

  Widget heIconOffline(String photo, FoFiRepository fofi) {
    // final FoFiRepository fofirepo = FoFiRepository();
    File fileImage = fofi.getLocalFileHe(photo);
    return Container(
      key: UniqueKey(),
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Colors.grey,
      ),
      child: fileImage.existsSync()
          ? Image.file(fileImage)
          : const CircleAvatar(
              radius: _iconSize,
              child: Icon(Icons.broken_image),
            ),
    );
  }
}

// Either<bool, String> convertUrlToGcsPath(String url) {
//   const String gcsPrefix = 'gs://${Endpoints.bucketUrl}';
//   Either<bool, String> bucketUrlOrError =
//       formatForBucket(url, 2); // replace 2 with your changeType
//   return bucketUrlOrError.fold(
//       (error) => Left(error), (bucketUrl) => Right(gcsPrefix + bucketUrl));
// }

Either<bool, String> convertUrlToWalahPath(String url,int changeType) {
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
