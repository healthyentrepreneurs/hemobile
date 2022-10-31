import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:he/app/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/helper_functions.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/home.dart';
import 'package:he/home/widgets/banner_update.dart';
import 'package:he/objects/objectapkupdate.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());
  Future<ObjectApkUpdate> initSurveyDataHomePage(
      String id, CollectionReference<Map<String, dynamic>> apks) async {
    // final apks = FirebaseFirestore.instance.collection('apks');
    var _updateStatus = apks.doc(id);
    var apkState = await _updateStatus.get();
    if (apkState.exists) {
      var myVersion = await _updateStatus.snapshots().first.asStream().first;
      // var data = myVersion.data() as Map<String, dynamic>;
      ObjectApkUpdate dataSection =
          ObjectApkUpdate.fromJson(myVersion.data() as Map<String, dynamic>);
      // printOnlyDebug(data['version']);
      return dataSection;
    } else {
      ObjectApkUpdate newUpdate =
          ObjectApkUpdate(version: "11", seen: true, updated: false);
      // {'version': "11", 'updated': false,'seen': true}
      _updateStatus
          .set(
            newUpdate.toJson(),
            SetOptions(merge: true),
          )
          .then((value) => printOnlyDebug("'Added' Version 12 default"))
          .catchError(
              (error) => printOnlyDebug("Failed to merge data: $error"));
      return newUpdate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final apks = FirebaseFirestore.instance.collection('apks');
    // var currentV = initSurveyDataHomePage(user.id!, apks);
    return Scaffold(
      backgroundColor: ToolUtils.whiteColor,
      appBar: AppBar(
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 143.0),
            child: Image.asset(
              'assets/images/logo.png',
              height: 35.0,
              // alignment: Alignment.center,
            ),
          ),
          backgroundColor: ToolUtils.whiteColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor)),
      endDrawer: CustomDrawer(
        user: user,
      ),
      body: ListView(children: [
        const SizedBox(height: 10.0),
        UserInformation(
          userId: user.id!,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            "Hi${user.name == null ? '' : ', ' + user.name!}!",
            style: TextStyle(
                // colorBlueOne, redColor
                color: ToolUtils.colorBlueOne,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
            width: double.infinity,
            child: InkWell(
              child: ListTile(
                title: const MenuItemHe().iconTextItemGreen(
                    'You have 20 unsent surveys hard coded', Icons.sync),
              ),
            )),
        const MenuItemHe().appTitle('What do you need ?'),
        Center(
            child: UserProfile(
          user: user,
        ))
      ]),
    );
  }
}
