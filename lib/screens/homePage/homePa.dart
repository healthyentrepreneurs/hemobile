import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:nl_health_app/screens/utilits/modelfire/usersub.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:universal_html/html.dart';
// https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html
// https://stackoverflow.com/questions/68079030/how-to-use-firestore-withconverter-in-flutter
// https://stackoverflow.com/questions/53800662/how-do-i-call-async-property-in-widget-build-method/53805983
class Homepa extends StatelessWidget {
  const Homepa({Key? key}) : super(key: key);
  static const String _title = 'Flutter Code XX';
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: JajaApp(),
    );
  }
}

class JajaApp extends StatefulWidget {
  const JajaApp({Key? key}) : super(key: key);
  @override
  _FilmList createState() => _FilmList();
}

/// This is the private State class that goes with MyStatefulWidget.
class _FilmList extends State<JajaApp> {
  CollectionReference _user = FirebaseFirestore.instance.collection('userdata');
  FirebaseStorage storage = FirebaseStorage.instance;
  var _permissionStatus;
  @override
  void initState() {
    super.initState();
    () async {
      _permissionStatus = await Permission.storage.status;
      if (_permissionStatus != PermissionStatus.granted) {
        PermissionStatus permissionStatus = await Permission.storage.request();
        setState(() {
          _permissionStatus = permissionStatus;
        });
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    // if (_permissionStatus != PermissionStatus.granted) {
    //   return Text('Not granted');
    // }
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: Container(
        alignment: FractionalOffset.center,
        color: Colors.white,
        child: StreamBuilder<DocumentSnapshot>(
          stream: _user
              .doc("3")
              .withConverter<Mycontent>(
                fromFirestore: (snapshot, _) =>
                    Mycontent.fromJson(snapshot.data()!),
                toFirestore: (model, _) => model.toJson(),
              )
              .get()
              .asStream(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            List<Widget> children;
            if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Stack trace: ${snapshot.stackTrace}'),
                ),
              ];
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  children = const <Widget>[
                    Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Select a lot'),
                    )
                  ];
                  break;
                case ConnectionState.waiting:
                  children = const <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting bids...'),
                    )
                  ];
                  break;
                case ConnectionState.active:
                  children = <Widget>[
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Hey Icon'),
                    )
                  ];
                  break;
                case ConnectionState.done:
                  Mycontent data = snapshot.data!.data() as Mycontent;
                  //For hiding files https://stackoverflow.com/questions/65977559/hide-local-downloaded-video-in-flutter-or-access-only-in-app
                  // https://www.woolha.com/tutorials/flutter-display-image-from-file-examples
                  // Stream<String> _valueStream = storage
                  //     .ref(
                  //         'bookresource/app.healthyentrepreneurs.nl/webservice/pluginfile.php/148/mod_book/chapter/7/15-EN.mp4')
                  //     .getDownloadURL()
                  //     .asStream();
                  Stream<File> _videofile = FirebaseCacheManager()
                      .getSingleFile(
                          '/bookresource/app.healthyentrepreneurs.nl/theme/image.php/_s/academi/book/1631050397/placeholderimage.png')
                      .asStream();
                  children = <Widget>[
                    const Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(data.Username!),
                    ),
                    StreamBuilder<File>(
                      stream: _videofile,
                      builder: (BuildContext context,
                          AsyncSnapshot<File> snapshotpic) {
                        List<Widget> childrenpic;
                        if (snapshotpic.hasError) {
                          childrenpic = <Widget>[
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text('Error 2: ${snapshotpic.error}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                  'Stack trace 2: ${snapshotpic.stackTrace}'),
                            ),
                          ];
                        } else {
                          switch (snapshotpic.connectionState) {
                            case ConnectionState.none:
                              childrenpic = const <Widget>[
                                Icon(
                                  Icons.info,
                                  color: Colors.blue,
                                  size: 60,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text('Select a lot 2'),
                                )
                              ];
                              break;
                            case ConnectionState.waiting:
                              childrenpic = const <Widget>[];
                              break;
                            case ConnectionState.active:
                              childrenpic = <Widget>[];
                              break;
                            case ConnectionState.done:
                              File picurl = snapshotpic.data!;
                              childrenpic = <Widget>[
                                Image.file(
                                  picurl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                  repeat: ImageRepeat.repeat,
                                  alignment: Alignment.topCenter,
                                  color: Colors.red,
                                  colorBlendMode: BlendMode.saturation,
                                  //      scale: 4,
                                ),

                                // FlatButton.icon(
                                //     onPressed: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   //VideoViewOnline(videoUrl: videoUrl)));
                                //                   ChewieVdViewOnline(
                                //                       videoUrl: picurl)));
                                //     },
                                //     icon: Icon(
                                //       FontAwesomeIcons.playCircle,
                                //       color: ToolsUtilities.redColor,
                                //       size: 50,
                                //     ),
                                //     label: Text(''))
                              ];
                              break;
                          }
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: childrenpic,
                        );
                      },
                    )
                  ];
                  break;
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            );
          },
        ),
      ),
    );
  }
}

// WhenRebuilder https://github.com/GIfatahTH/states_rebuilder/issues/75
//AsyncBuilder https://pub.dev/packages/async_builder
