import 'package:flutter/material.dart';
import 'package:he/injection.dart';
import 'package:he/objects/blocs/repo/apk_repo.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DrawerAppVersionWidget extends StatelessWidget {
  final String heversion;
  const DrawerAppVersionWidget({Key? key, required this.heversion})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final logRepository = getIt<ApkRepository>();
    return FutureBuilder(
      future: logRepository.getAppApk(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final packageInfo = snapshot.data!;
            // ${packageInfo.version}
            return Text("Version : $heversion",
                style: const TextStyle(color: Colors.black, fontSize: 10));
            // return Text("Data Loaded");
          } else if (snapshot.hasError) {
            return Text("Version: ${snapshot.error}",
                style: const TextStyle(color: Colors.black, fontSize: 10));
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
