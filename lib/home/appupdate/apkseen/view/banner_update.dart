import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/home/appupdate/appupdate.dart';
import 'package:he/objects/blocs/apkupdate/bloc/apk_bloc.dart';
import 'package:he/objects/blocs/henetwork/bloc/henetwork_bloc.dart';
import 'package:he_api/he_api.dart';

// @ Phila One
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
              return BlocBuilder<ApkseenBloc, ApkseenState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    final _apkseenBloc = BlocProvider.of<ApkseenBloc>(context);
                    if (state.status.seen == false &&
                        dataCloud['version'] != state.status.heversion) {
                      debugPrint(
                          "WIZY ${state.status.toJson()} and ${dataCloud['version']} ");
                      return AppVerView(
                          latestapk: logs, appversion: appVersion!);
                    } else {
                      double? cloudVersion =
                          double.tryParse(dataCloud['version'] ?? '0.0');
                      double? localVersion =
                          double.tryParse(state.status.heversion ?? '0.0');

                      if ((cloudVersion ?? 0.0) > (localVersion ?? 0.0) &&
                          state.status.updated == true) {
                        debugPrint(
                            "PALAHXXX ${state.status.toJson()} and ${dataCloud['version']}");
                        Apkupdatestatus updateStatus =
                            const Apkupdatestatus(seen: false, updated: false);
                        _apkseenBloc
                            .add(UpdateSeenStatusEvent(status: updateStatus));
                      }
                    }
                    debugPrint(
                        "WALAH ${state.status.toJson()} and ${dataCloud['version']}");
                    return const SizedBox.shrink();
                  });
            }
          });
    } else {
      return const SizedBox.shrink();
    }
  }
}
