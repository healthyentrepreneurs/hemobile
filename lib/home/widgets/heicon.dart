import 'package:flutter/material.dart';

const _iconSize = 30.0;

class HeIcon extends StatelessWidget {
  const HeIcon({Key? key, this.photo}) : super(key: key);
  final String? photo;
  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    return ClipRRect(
      key: UniqueKey(),
      borderRadius: BorderRadius.circular(30.0),
      child: FadeInImage(
          width: 50,
          height: 50,
          image: NetworkImage(photo!),
          placeholder: const AssetImage("assets/images/lake.png"),
          imageErrorBuilder: (context, error, stackTrace) {
            return const CircleAvatar(
              radius: _iconSize,
              child: Icon(Icons.image_not_supported, size: 15),
            );
          }),
    );
  }
}
