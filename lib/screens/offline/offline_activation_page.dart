import 'package:cool_stepper/cool_stepper.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/services/service_locator.dart';
import 'package:nl_health_app/services/storage_service/storage_service.dart';
import 'package:nl_health_app/widgets/file_downloader.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'dart:io';
// import 'package:universal_html/html.dart';


class OfflineModulePage extends StatefulWidget {
  @override
  _OfflineModulePageState createState() => _OfflineModulePageState();
}

class _OfflineModulePageState extends State<OfflineModulePage> {
  final preferenceUtil = getIt<StorageService>();
  @override
  Widget build(BuildContext context) {
    return _uiSetup(context);
  }

  @override
  void initState() {
    super.initState();
    this.initApp();
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
        backgroundColor: ToolsUtilities.mainBgColor,
        appBar: AppBar(
          title: Text(
            "Offline Settings",
            style: TextStyle(color: ToolsUtilities.mainPrimaryColor),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: stepper(context),
        ));
  }

  /// Create a stepper
  Widget stepperWidget() {
    return Expanded(child: stepper(context));
  }

  //---
  final _formKey = GlobalKey<FormState>();
  String? _offlineModeStatus;

  Widget stepper(BuildContext context) {
    final List<CoolStep> steps = [
      CoolStep(
        title: "Offline Mode Switching",
        subtitle: "Please enable/disable offline mode",
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Current status: $_offlineModeStatus",
              style: _offlineModeStatus == 'on'
                  ? TextStyle(color: Colors.green)
                  : TextStyle(color: Colors.red),
            ),
            SizedBox(height: 30.0),
            ToggleSwitch(
              totalSwitches: 2,
              minWidth: MediaQuery.of(context).size.width * 0.44,
              initialLabelIndex: _offlineModeStatus == 'on' ? 0 : 1,
              labels: ['OFFLINE ON', 'OFFLINE OFF'],
              onToggle: (index) {
                //To Be Revisited
                var x = index == 0 ? 'on' : 'off';
                setState(() {
                  _offlineModeStatus = x;
                });

                if(x=="on"){
                  print("Okay Fuck tomo $x");
                  preferenceUtil.setOnline(x);
                }
                if(x=="off"){
                  print("Okay Fuck now $x");
                  preferenceUtil.setOffline(x);
                }
                // x=="on"?preferenceUtil.setOnline():preferenceUtil.setOffline();
              },
            ),
          ],
        ),
        validation: () {
          if (_offlineModeStatus == 'off') {
            toast_("Offline Mode is Disabled!");
            return "Offline Mode is Disabled!";
          }
          return null;
        },
      ),
      CoolStep(
        title: "Download Offline File",
        subtitle:
            "Please after downloading offline zip to you device, you can select it, If you have it you can skip this step",
        content: Container(
          child: Column(
            children: [
              SizedBox(height: 50.0),
              Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(),
                child: RaisedButton(
                  onPressed: () async {
                    int? userId = (await preferenceUtil.getUser())?.id;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UniFileDownloader(
                                fileSystemUtil: FileSystemUtil(),
                                imgUrl:
                                    "http://helper.healthyentrepreneurs.nl/downloadable/create_content/$userId",
                                fileName: "HE Health.zip")));
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Theme.of(context).primaryColor)),
                  child: Text(
                    'Download Offline HE Health.zip',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        validation: () {
          return null;
        },
      ),
      CoolStep(
        title: "Select and Extract you Offline File",
        subtitle: "Choose a role that better defines you",
        content: Container(
          child: Column(
            children: [
              SizedBox(height: 50.0),
              Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(),
                child: RaisedButton(
                  onPressed: () {
                    extractZip();
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Theme.of(context).primaryColor)),
                  child: Text(
                    'Extract Offline HE Health.zip',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        validation: () {
          return null;
        },
      ),
      CoolStep(
        title: "Start using offline mode",
        subtitle: "Now you have completed the offline process setup",
        content: Container(
          child: Column(
            children: [
              SizedBox(height: 50.0),
              Text(
                'Completed the offline process',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )
            ],
          ),
        ),
        validation: () {
          return null;
        },
      ),
    ];

    final stepper = CoolStepper(
      onCompleted: () {
        print("Steps completed!");
      },
      steps: steps,
      config: CoolStepperConfig(
        backText: "PREV",
      ),
    );

    return stepper;
  }

  Widget _buildTextField({
    required String labelText,
    required FormFieldValidator<String> validator,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        validator: validator,
        controller: controller,
      ),
    );
  }

  Future<void> initApp() async {
    var x = await preferenceUtil.getOnline();
    print("offline activation $x");
    // var x = preferences.getString("offline");
    setState(() {
      _offlineModeStatus = x;
    });
  }

  Future<void> extractZip() async {
    var rootPath = Directory(await FileSystemUtil().extDownloadsPath);
    String? path = await FilesystemPicker.open(
      title: 'Select HE Health.zip file',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.file,
      folderIconColor: Colors.teal,
      allowedExtensions: ['.zip'],
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
    await exeZip(File(path!));
  }

  Future<void> exeZip(File zipFile) async {
    String p = await FileSystemUtil().extDownloadsPath + "/HE Health/";
    //---
    final destinationDir = Directory(p);
    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile,
          destinationDir: destinationDir,
          onExtracting: (zipEntry, progress) {
            print('progress: ${progress.toStringAsFixed(1)}%');
            print('name: ${zipEntry.name}');
            print('isDirectory: ${zipEntry.isDirectory}');
            print(
                'modificationDate: ${zipEntry.modificationDate!.toLocal().toIso8601String()}');
            print('uncompressedSize: ${zipEntry.uncompressedSize}');
            print('compressedSize: ${zipEntry.compressedSize}');
            print('compressionMethod: ${zipEntry.compressionMethod}');
            print('crc: ${zipEntry.crc}');
            return ZipFileOperation.includeItem;
          });
    } catch (e) {
      print(e);
    }
    //---
  }

//---
}
