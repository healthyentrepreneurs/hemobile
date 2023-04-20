import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<HydratedStorage> setupHydratedBloc() async {
  // Get the application documents directory
  final appDocDir = await getApplicationDocumentsDirectory();
  // Create a new directory to store the hydrated bloc data
  final blocStorageDirectory =
      Directory('${appDocDir.path}/hydrated_bloc_data');
  // Check if the directory exists, and if not, create it
  if (!blocStorageDirectory.existsSync()) {
    blocStorageDirectory.createSync();
  }

  // Set up the HydratedBloc storage
  return HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb ? HydratedStorage.webStorageDirectory : blocStorageDirectory,
  );

  // HydratedBloc.storage = await HydratedStorage.build(
  //   storageDirectory: kIsWeb
  //       ? HydratedStorage.webStorageDirectory
  //       : await getTemporaryDirectory(),
  // );
}
