import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/home/appupdate/apkseen/bloc/apkseen_bloc.dart';

class DrawerAppVersionWidget extends StatelessWidget {
  const DrawerAppVersionWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _apkUpdateBloc = BlocProvider.of<ApkseenBloc>(context).state;
    var _heversion = _apkUpdateBloc.status.heversion ?? '0';
    return Text("Version : $_heversion",
        style: const TextStyle(color: Colors.black, fontSize: 10));
  }
}
