import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  // final String errorMessage;

  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('errorMessage')),
    );
  }
}