

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';

/// Switch the Firestore network mode
Future<void> switchMode(String offlineLocal) async{
  try{
    //if there is no network set off
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await FirebaseFirestore.instance.disableNetwork();
      toast_("No internet, we running in offline mode");
      return;
    }
    if(offlineLocal =='on'){
      await FirebaseFirestore.instance.disableNetwork();
    }else{
      await FirebaseFirestore.instance.enableNetwork();
    }
  }catch(e){

  }
}