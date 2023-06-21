import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';
import 'package:he_api/he_api.dart';

const _avatarSize = 20.0;
const _bookSize = 20.0;

class BookIcon extends StatelessWidget {
  final String icon;
  const BookIcon({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FoFiRepository _fofi = FoFiRepository();
    final henetworkstate =
        context.select((HenetworkBloc bloc) => bloc.state.status);

    if (henetworkstate == HenetworkStatus.noInternet) {
      try {
        Uint8List imageData = _fofi.getLocalFileHeFileWalah(icon);
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
}
