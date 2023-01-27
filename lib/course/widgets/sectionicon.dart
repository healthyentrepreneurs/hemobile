import 'package:flutter/material.dart';

const _avatarSize = 20.0;
const _bookSize = 20.0;

class SectionIcon extends StatelessWidget {
  const SectionIcon({Key? key, this.photo}) : super(key: key);
  //njovu
  final String? photo;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    return CircleAvatar(
      radius: _avatarSize,
      backgroundImage: photo != null ? NetworkImage(photo) : null,
      child: photo == null
          ? const Icon(Icons.segment_outlined, size: _avatarSize)
          : null,
      // onBackgroundImageError: (error, stackTrace) {},
    );
  }

  Widget sectionTitle(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: Text(t,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

  Widget bookIcon(String icon) {
    return FadeInImage(
        width: 50,
        height: 50,
        image: NetworkImage(icon),
        placeholder: const AssetImage("assets/images/lake.png"),
        imageErrorBuilder: (context, error, stackTrace) {
          return const CircleAvatar(
            radius: _bookSize,
            child: Icon(Icons.book_online_sharp, size: _bookSize),
          );
        });
  }
}
