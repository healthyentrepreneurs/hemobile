import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/objects/blocs/apkupdate/bloc/apk_bloc.dart';

import '../../apkdownload/apkdownload.dart';

class AppUpdatActions extends StatelessWidget {
  final String userId;
  const AppUpdatActions({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final testBloc = BlocProvider.of<ApkBloc>(context);
    // testBloc.apkBlocRepository
    return BlocBuilder<ApkBloc, ApkState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is ApkLoadingState) {
            return const SizedBox(height: 0.0);
          } else if (state is ApkErrorState) {
            debugPrint("LUDALOGS ${state.error.message}");
            return const SizedBox(height: 0.0);
            //Njovu
            return Center(
              child: Text('Error: ${state.error.message}'),
            );
          } else if (state is ApkFetchedState) {
            final logs = state.snapshot;
            final appVersion = state.apkinfo;
            Map<String, dynamic> data = logs.data() as Map<String, dynamic>;
            // testBloc.apkBlocRepository.
            if (appVersion!.version != data['version']) {
              debugPrint(
                  "Mongos , Local ${appVersion.version} From Cloud ${data['version']}");
              return AppVerView(latestapk: logs, appversion: appVersion);
            } else {
              debugPrint("appVersion C");
              return const SizedBox(height: 0.0);
            }
          } else {
            debugPrint("appVersion D");
            return const SizedBox(height: 0.0);
          }
        });
  }
}
