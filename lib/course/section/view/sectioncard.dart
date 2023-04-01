// sectioncard

import 'package:flutter/material.dart';
import 'package:he/course/widgets/sectionicon.dart';

class SectionCard extends StatelessWidget {
  final String imageUrl;
  final String sectionName;
  const SectionCard({Key? key,required this.sectionName, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Column(
        children: [
          SectionIcon(photo: imageUrl),
          Flexible(
            child: Column(children: [
              Text(
                sectionName,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}