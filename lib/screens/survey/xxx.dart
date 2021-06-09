import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//https://stackoverflow.com/questions/46145472/how-to-convert-base64-string-into-image-with-flutter

void main_() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData.dark(),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String _base64;

  @override
  void initState() {
    super.initState();
    (() async {
      http.Response response = await http.get(
        'https://flutter.io/images/flutter-mark-square-100.png',
      );
      if (mounted) {
        setState(() {
          _base64 = base64.encode(response.bodyBytes);
        });
      }
    })();
  }

  @override
  Widget build(BuildContext context) {
    if (_base64 == null)
      return new Container();
    Uint8List bytes = base64.decode(_base64);
    return new Scaffold(
      appBar: new AppBar(title: new Text('Example App')),
      body: new ListTile(
        leading: new Image.memory(bytes),
        title: new Text(_base64),
      ),
    );
  }
}
