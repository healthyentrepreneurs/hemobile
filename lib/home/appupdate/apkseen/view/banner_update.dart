
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/home/appupdate/appupdate.dart';

class BannerUpdate extends StatelessWidget {
  final String userId;
  const BannerUpdate({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApkseenBloc, ApkseenState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.status.seen == false && state.status.updated == false) {
            return AppUpdatActions(userId: userId,);
          } else if (state.status.seen == true &&
              state.status.updated == false) {
            debugPrint("BannerUpdate seen=true and updated=false");
            return const SizedBox(height: 0.0);
          }
          debugPrint("BannerUpdate seen=true and updated=true");
          return const SizedBox(height: 0.0);
        });
  }
}
