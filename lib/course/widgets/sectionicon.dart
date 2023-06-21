import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';
import 'package:he_api/he_api.dart';

import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';

const _avatarSize = 20.0;
const _bookSize = 20.0;

bool isValidUrl(String? url) {
  if (url == null) return false;
  Uri? uri;
  try {
    uri = Uri.parse(url);
  } catch (e) {
    return false;
  }
  return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
}

class SectionIcon extends StatelessWidget {
  const SectionIcon({Key? key, this.photo}) : super(key: key);
  final String? photo;

  @override
  Widget build(BuildContext context) {
    final FoFiRepository _fofi = FoFiRepository();
    final henetworkstate =
        context.select((HenetworkBloc bloc) => bloc.state.status);
    final photo = this.photo;

    if (henetworkstate == HenetworkStatus.noInternet) {
      try {
        Uint8List imageData = _fofi.getLocalFileHeFileWalah(photo!);
        return SizedBox(
          key: UniqueKey(),
          width: 50,
          height: 50,
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
                  radius: 25,
                  backgroundImage: MemoryImage(imageData),
                ),
              ),
            ],
          ),
        );
      } catch (e) {
        debugPrint('Error loading local file: $e');
        return const CircleAvatar(
          radius: _avatarSize,
          child: Icon(Icons.broken_image),
        );
      }
    } else {
      return isValidUrl(photo)
          ? CircleAvatar(
              key: UniqueKey(),
              radius: _avatarSize,
              backgroundImage: photo != null ? NetworkImage(photo) : null,
              child: photo == null
                  ? const Icon(Icons.segment_outlined, size: _avatarSize)
                  : null,
            )
          : const CircleAvatar(
              radius: _avatarSize,
              child: Icon(Icons.broken_image),
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
}
