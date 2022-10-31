import 'package:flutter/material.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/widgets/heicon.dart';

class UserLanding extends StatelessWidget {
  const UserLanding(
      {Key? key, this.title, this.description, this.iconName, this.onTap})
      : super(key: key);
  final String? title;
  final String? description;
  final String? iconName;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(1.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(60), blurRadius: 3.0),
              ]),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.5,
                  // padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title!,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ToolUtils.colorGreenOne),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        description!,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                HeIcon(photo: iconName),
              ],
            ),
          )),
    );
  }
}