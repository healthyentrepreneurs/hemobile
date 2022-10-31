 @Start Add_Files_to_Firestore

 // android:requestLegacyExternalStorage="true"
                final mountainsRef = storageRef.child("jeje.png");
                final mountainImagesRef = storageRef.child("images/jeje.png");
                assert(mountainsRef.name == mountainImagesRef.name);
                assert(mountainsRef.fullPath != mountainImagesRef.fullPath);

                const permission = Permission.storage;
                final status = await permission.status;
                debugPrint('>>>Status $status');

                /// here it is coming as PermissionStatus.granted
                if (status != PermissionStatus.granted) {
                  await permission.request();
                  if (await permission.status.isGranted) {
                    directory = Directory(await mainOfflinePath);

                    ///perform other stuff to download file
                  } else {
                    await permission.request();
                  }
                  debugPrint('>>> ${await permission.status}');
                }
                directory = Directory(await mainOfflinePath);
                final filePath = directory.path.toString() + '/jeje.png';
                // final _result =  await OpenFile.open(filePath);
                // String _openResult = "type=${_result.type}  message=${_result.message}";
                File file = File(filePath);
                try {
                  mountainsRef.putFile(file);
                  final newMetadata = SettableMetadata(
                    cacheControl: "public,max-age=300",
                    contentType: "image/png",
                  );
                  await mountainsRef.updateMetadata(newMetadata);
                } on firebase_and_core.FirebaseException catch (e) {
                  printOnlyDebugWrapped("joashpa ${e.toString()}");
                }
 @End Add_Files_to_Firestore
 
@Start Pass Unonimous Function

Widget _buildCounterButton() {
return new RaisedButton(
child: new Text(
_isButtonDisabled ? "Hold on..." : "Increment"
),
onPressed: _counterButtonPress(),
);
}

Function _counterButtonPress() {
if (_isButtonDisabled) {
return null;
} else {
return () {
// do anything else you may want to here
_incrementCounter();
};
}
}

@End Pass Unonimous Function

@Start Render Box Solution and Drawer
https://www.fluttercampus.com/guide/228/renderbox-was-not-laid-out-error/
https://stackoverflow.com/questions/63042859/drawer-footer-items
@End Render
