import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:nl_health_app/models/utils.dart';

class FileImageDisplay extends StatefulWidget {
  final String imageUrl;

  const FileImageDisplay(this.imageUrl, {Key? key}) : super(key: key);

  @override
  _FileImageDisplayState createState() => _FileImageDisplayState();
}

class _FileImageDisplayState extends State<FileImageDisplay> {
  @override
  void initState() {
    super.initState();
    initImages();
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        height: 50.0,
        width: 240,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        height: 240,
        color: Colors.grey.shade100,
      );
    }
  }

  File? imageFile;

  Future<void> initImages() async {
    var v = await FirebaseCacheManager().getSingleFile(widget.imageUrl);
    if (mounted)
      setState(() {
        print("Image>>>" + widget.imageUrl + "<<<");
        imageFile = v;
      });
  }
}
