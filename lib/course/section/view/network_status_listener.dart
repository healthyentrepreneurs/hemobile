import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';

import '../../../helper/file_system_util.dart';

class NetworkStatusListener extends StatelessWidget {
  final Widget child;
  final Future<void> Function(BuildContext context, DatabaseState state)
      onStateChange;
  const NetworkStatusListener(
      {Key? key, required this.child, required this.onStateChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DatabaseBloc, DatabaseState>(
      listenWhen: (previous, current) {
        return previous.ghenetworkStatus != current.ghenetworkStatus;
      },
      listener: (context, state) async {
        await onStateChange(context, state);
      },
      child: child,
    );
  }
}
