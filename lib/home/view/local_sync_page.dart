import 'package:flutter/material.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/widgets/heappbar.dart';

class LocalSyncPage extends StatefulWidget {
  const LocalSyncPage({super.key});
  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const LocalSyncPage());
  }

  @override
  State<StatefulWidget> createState() => _LocalSyncPageState();
}

class _LocalSyncPageState extends State {
  bool? showAlert;

  _LocalSyncPageState();

  @override
  Widget build(BuildContext context) {
    var surveyUploadDate;
    return Scaffold(
      backgroundColor: ToolUtils.whiteColor,
      appBar: HeAppBar(
        course: 'Sync Data Sets',
        appbarwidget: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        transparentBackground: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50.0),
                const Text("@reportMessage",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.orange)),
                const SizedBox(height: 50.0),
                Text("Total Survey Data Sets @count",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 20.0),
                Text("Other Data Sets @countDataSet",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 10.0),
                surveyUploadDate != null
                    ? Text("Last Update date $surveyUploadDate",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))
                    : Text(""),
                SizedBox(height: 10.0),
                Text(
                    "You can upload the local data sets when you get online by tapping the below button.",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 17)),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        // Sync method would be called here
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor, backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: Text(
                        'Upload Survey Data',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget alertCardPopup(String title, String text, bool status) {
    return Card(
      color: status ? Colors.green : Colors.red,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.sync_rounded, color: Colors.white),
            title: Text(title, style: TextStyle(color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: !status
                ? [
                    TextButton(
                      onPressed: () {
                        // Perform some action
                        // pushAllDataSetsNow();
                      },
                      child: const Text('TRY AGAIN',
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        // Perform some action
                        setState(() {
                          showAlert = false;
                        });
                      },
                      child: const Text('SEND LATER',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ]
                : [
                    TextButton(
                      onPressed: () {
                        // Perform some action
                        setState(() {
                          showAlert = false;
                        });
                      },
                      child: const Text('CLOSE',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}
