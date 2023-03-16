import 'package:flutter/material.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/home.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';
import 'package:he_api/he_api.dart';

class UserLanding extends StatelessWidget {
  const UserLanding({Key? key, required this.subscription, this.onTap})
      : super(key: key);
  final Subscription subscription;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    final FoFiRepository _fofi = FoFiRepository();
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
                        subscription.fullname!,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ToolUtils.colorGreenOne),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        subscription.summaryCustome!,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                HeIcon(photo: subscription.imageUrlSmall, fofi: _fofi),
              ],
            ),
          )),
    );
  }
}
