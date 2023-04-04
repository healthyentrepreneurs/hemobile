
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/appupdate/apkdownload/apkdownload.dart';
import 'package:he/home/appupdate/apkseen/apkseen.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVerView extends StatelessWidget {
  final DocumentSnapshot latestapk;
  final PackageInfo appversion;
  const AppVerView(
      {Key? key, required this.latestapk, required this.appversion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = latestapk.data() as Map<String, dynamic>;
    return BlocListener<AppudateBloc, AppudateState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // backgroundColor: Colors.red,
              content: Text(state.error!.message),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: BlocBuilder<AppudateBloc, AppudateState>(
        builder: (context, state) {
          if (state.progress != null) {
            debugPrint(
                "What is here ${state.progress} and ${state.isDownloading}");
            if (state.progress == 1.0) {
              return const InstallApk();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LinearProgressIndicator(
                  backgroundColor: Colors.red,
                  color: ToolUtils.colorBlueOne,
                  minHeight: 5,
                  value: state.progress,
                )
                // LinearProgressIndicator(value: state.progress),
              ],
            );
          } else {
            return BlocBuilder<ApkseenBloc, ApkseenState>(
                builder: (context, state) {
              return MaterialBanner(
                padding: const EdgeInsets.all(1),
                content: Text(data['releasenotes'],
                    style: const TextStyle(color: ToolUtils.colorGreenOne)),
                leading: const Icon(Icons.update_outlined,
                    size: 30.0, color: ToolUtils.colorBlueOne),
                backgroundColor: const Color(0xFFE0E0E0),
                actions:  <Widget>[const DismissButton(), UpdateButton(url: data['url'],)],
              );
            });
          }
        },
      ),
    );
  }
}
