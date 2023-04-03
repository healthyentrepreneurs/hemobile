import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';

import '../../helper/file_system_util.dart';
import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';

const _avatarSize = 20.0;
const _bookSize = 20.0;

class SectionIcon extends StatelessWidget {
  const SectionIcon({Key? key, this.photo}) : super(key: key);
  //ToBeContinued
  final String? photo;

  @override
  Widget build(BuildContext context) {
    final henetworkstate =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    final photo = this.photo;
    if (henetworkstate == HenetworkStatus.noInternet) {
      return _sectionIconOffline(photo!);
    } else {
      return CircleAvatar(
        key: UniqueKey(),
        radius: _avatarSize,
        backgroundImage: photo != null ? NetworkImage(photo) : null,
        child: photo == null
            ? const Icon(Icons.segment_outlined, size: _avatarSize)
            : null,
        // onBackgroundImageError: (error, stackTrace) {},
      );
    }
  }

  Widget sectionTitle(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: Text(t,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }
  Widget _sectionIconOffline(String photo) {
    final FoFiRepository fofirepo = FoFiRepository();
    File fileImage = fofirepo.getLocalFileHe(photo);
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
              radius: _avatarSize,
              child: Icon(Icons.broken_image),
            ),
    );
  }
}
