import 'package:flutter/material.dart';
import 'package:he/helper/toolutils.dart';

class MenuItemHe extends StatelessWidget {
  const MenuItemHe({Key? key, this.title, this.icon}) : super(key: key);
  final String? title;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final icon = this.icon;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: ToolUtils.whiteColor,
            size: 21,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            title!,
            style: const TextStyle(
                color: ToolUtils.whiteColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget iconTextItemGreen(String title, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: ToolUtils.colorGreenOne,
          size: 20,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: const TextStyle(
              color: ToolUtils.mainPrimaryColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
  Widget appTitle(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: Text(t,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }
// return const Center(child: CircularProgressIndicator());
}