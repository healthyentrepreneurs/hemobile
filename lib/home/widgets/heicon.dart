import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he_api/he_api.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../objects/blocs/blocs.dart';

const _iconSize = 29.0;

bool isValidUrl(String? url) {
  debugPrint("URLSWHICHCC $url");
  if (url == null) return false;
  Uri? uri;
  try {
    uri = Uri.parse(url);
  } catch (e) {
    return false;
  }
  return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
}

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
              child: isValidUrl(photo)
                  ? FadeInImage.memoryNetwork(
                      width: 50,
                      height: 50,
                      placeholder: kTransparentImage,
                      image: photo!,
                      imageErrorBuilder: (context, error, stackTrace) {
                        debugPrint('HeIconOnline@imageErrorBuilder');
                        return const CircleAvatar(
                          radius: _iconSize,
                          child: Icon(Icons.broken_image),
                        );
                      },
                    )
                  : const CircleAvatar(
                      radius: _iconSize,
                      child: Icon(Icons.broken_image),
                    ),
            )
          : heIconOffline(photo!, fofi),
    );
  }

  Widget heIconOffline(String photo, FoFiRepository fofi) {
    // final FoFiRepository fofirepo = FoFiRepository();
    File fileImage = fofi.getLocalFileHe(photo);
    debugPrint('PIRPLERAIN ${fileImage.path}');
    return Container(
      key: UniqueKey(),
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Colors.grey),
      child: fileImage.existsSync()
          ? Image.file(fileImage)
          : const CircleAvatar(
              radius: _iconSize,
              child: Icon(Icons.broken_image),
            ),
    );
  }
}
