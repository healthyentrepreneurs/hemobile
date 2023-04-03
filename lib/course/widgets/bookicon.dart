import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';

const _avatarSize = 20.0;
const _bookSize = 20.0;

class BookIcon extends StatelessWidget {
  final String icon;

  const BookIcon({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final henetworkstate =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    if (henetworkstate == HenetworkStatus.noInternet) {
      return _bookIconOffline(icon);
    } else {
      return FadeInImage(
        key: UniqueKey(),
        width: 50,
        height: 50,
        image: NetworkImage(icon),
        placeholder: const AssetImage("assets/images/lake.png"),
        imageErrorBuilder: (context, error, stackTrace) {
          return const CircleAvatar(
            radius: _bookSize,
            child: Icon(Icons.book_online_sharp, size: _bookSize),
          );
        },
      );
    }
  }

  Widget _bookIconOffline(String photo) {
    final FoFiRepository fofirepo = FoFiRepository();
    File fileImage = fofirepo.getLocalFileHe(photo);
    return SizedBox(
      key: UniqueKey(),
      width: 50,
      height: 50,
      child: fileImage.existsSync()
          ? Image.file(fileImage)
          : const CircleAvatar(
              radius: _avatarSize,
              child: Icon(Icons.broken_image),
            ),
    );
  }
}
