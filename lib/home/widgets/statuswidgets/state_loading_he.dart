import 'package:flutter/material.dart';

class StateLoadingHe extends StatelessWidget {
  const StateLoadingHe({Key? key, this.title, this.icon}) : super(key: key);
  final String? title;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return const Text('data');
  }

  Widget noDataFound(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.info,
            color: Colors.blue,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(message),
          ),
        ],
      ),
    );
  }

  Widget loadingData() {
    return const SizedBox(
      // width: double.infinity,
      child: InkWell(
        child: CircularProgressIndicator(),
      ),
      // width: 60,
      // height: 60,
    );
  }

  Widget errorWithStackT(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}
