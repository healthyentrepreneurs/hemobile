import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:he/asyncfiles/storageheutil.dart';
import 'package:he/injection.dart';
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
          return FutureBuilder<String>(
            future: getImageUrlFromFirebase(gcsPath),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Image.network(
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
                  // return Image.network(
                  //   snapshot.data!,
                  //   fit: BoxFit.cover,
                  // );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey[600],
                      size: 50,
                    ),
                  );
                }
              } else {
                return const CircleAvatar(
                  radius: _iconSize,
                  child: Center(child: SpinKitThreeBounce(color: Colors.blue)),
                );

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

