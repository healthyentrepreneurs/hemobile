import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/home/appupdate/appupdate.dart';
import 'package:he/objects/blocs/apkupdate/bloc/apk_bloc.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';

class BannerUpdate extends StatelessWidget {
  final String userId;
  const BannerUpdate({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var networkSate =
        context.select((HenetworkBloc henetwork) => henetwork.state);
    if (networkSate.status == HenetworkStatus.wifiNetwork) {
      return BlocBuilder<ApkBloc, ApkState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state is ApkLoadingState) {
              return const SizedBox.shrink();
            } else if (state is ApkErrorState) {
              debugPrint("LUDALOGS ${state.error.message}");
              return const SizedBox.shrink();
              return Center(
                child: Text('Error: ${state.error.message}'),
              );
            }
            // state is ApkFetchedState
            else {
              final appCloudLocal = context.select((ApkBloc bloc) => bloc.state)
                  as ApkFetchedState;
              final logs = appCloudLocal.snapshot;
              final appVersion = appCloudLocal.apkinfo;
              Map<String, dynamic> dataCloud =
                  logs.data() as Map<String, dynamic>;
              // testBloc.apkBlocRepository.
              return BlocBuilder<ApkseenBloc, ApkseenState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    if (state.status.seen == false &&
                            state.status.updated == false &&
                            state.status.seen == false ||
                        dataCloud['version'] != state.status.heversion) {
                      debugPrint(
                          "WIZY ${state.status.heversion} and ${dataCloud['version']}");
                      return AppVerView(
                          latestapk: logs, appversion: appVersion!);
                      // return AppUpdatActions(
                      //   userId: userId,
                      // );
                    } else if (state.status.seen == true &&
                        state.status.updated == false) {
                      debugPrint("BannerUpdate seen=true and updated=false");
                      return const SizedBox.shrink();
                    }
                    // return AppUpdatActions(userId: userId,);
                    debugPrint(
                        "WALAH ${state.status.heversion} and ${dataCloud['version']}");
                    debugPrint("BannerUpdate seen=true and updated=true");
                    return const SizedBox.shrink();
                  });
            }
          });
    } else {
      return const SizedBox.shrink();
    }
    // return BlocBuilder<ApkseenBloc, ApkseenState>(
    //     buildWhen: (previous, current) => previous != current,
    //     builder: (context, state) {
    //       if (state.status.seen == false && state.status.updated == false) {
    //         return AppUpdatActions(
    //           userId: userId,
    //         );
    //       } else if (state.status.seen == true &&
    //           state.status.updated == false) {
    //         debugPrint("BannerUpdate seen=true and updated=false");
    //         return const SizedBox.shrink();
    //       }
    //       //Njovu
    //       // return AppUpdatActions(userId: userId,);
    //       debugPrint("BannerUpdate seen=true and updated=true");
    //       return const SizedBox.shrink();
    //     });
  }
}
