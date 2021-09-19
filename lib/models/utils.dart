

import 'dart:io';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';

Future<File> getFirebaseFile(String url) async {
  try{
    var file = await FirebaseCacheManager().getSingleFile(url);
    return file;
  }catch(e){
    var file = await FirebaseCacheManager().getSingleFile("/bookresource/app.healthyentrepreneurs.nl/theme/image.php/_s/academi/book/1631050397/placeholderimage.png");
    return file;
  }
}
