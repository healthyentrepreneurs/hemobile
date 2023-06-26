import 'package:flutter/material.dart';

const _avatarSize = 48.0;

// @Phila Temp
class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.photo}) : super(key: key);

  final String? photo;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    return CircleAvatar(
      radius: _avatarSize,
      foregroundImage: photo != null ? NetworkImage(photo) : null,
      backgroundImage: const AssetImage("assets/images/lake.png"),
      child: photo == null
          ? const Icon(Icons.person_outline, size: _avatarSize)
          : null,
    );
  }
}
