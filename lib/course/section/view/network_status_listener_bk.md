import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';

class NetworkStatusListener extends StatefulWidget {
  final Widget child;
  final Function(BuildContext context, DatabaseState state) onStateChange;

  const NetworkStatusListener({super.key, required this.child, required this.onStateChange});

  @override
  _NetworkStatusListenerState createState() => _NetworkStatusListenerState();
}

class _NetworkStatusListenerState extends State<NetworkStatusListener> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DatabaseBloc, DatabaseState>(
      listenWhen: (previous, current) {
        return previous.ghenetworkStatus != current.ghenetworkStatus;
      },
      listener: (context, state) {
        if (!mounted) return;
        widget.onStateChange(context, state);
      },
      child: widget.child,
    );
  }
}
