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

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // title: const Text('Are you sure ?'),
            contentPadding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            content: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(2.0),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.info_outline,
                      color: Colors.redAccent,
                    ),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: Text('Are you sure ?',
                            style: TextStyle(fontSize: 18))),
                    Center(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: const Text(
                                'All the data you filled in will be lost',
                                style: TextStyle(fontSize: 13)))),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Theme.of(context).primaryColor,
                ),
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Container(
                width: 5.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Colors.redAccent,
                ),
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        )) ??
        false;
  }
// return const Center(child: CircularProgressIndicator());
}
