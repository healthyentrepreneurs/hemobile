import 'package:flutter/material.dart';
import 'package:he/helper/toolutils.dart';

class HeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? course;
  // course?.fullname
  final Widget? appbarwidget;
  // final VoidCallback onPressed;
  final bool transparentBackground;

  const HeAppBar({
    Key? key,
    this.course,
    this.appbarwidget,
    // required this.onPressed,
    this.transparentBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        course ?? '',
        style: const TextStyle(color: ToolUtils.mainPrimaryColor),
      ),
      backgroundColor:
          transparentBackground ? Colors.transparent : Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
      leading: appbarwidget,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
