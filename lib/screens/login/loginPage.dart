import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/utilits/file_system_utill.dart';
import 'package:nl_health_app/screens/utilits/models/language_model.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:nl_health_app/services/service_locator.dart';
import 'package:nl_health_app/widgets/ProgressWidget.dart';
import 'loginUIone.dart';
import 'login_logic.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final stateManager = getIt<LoginManager>();
  List<ListLanguage> _dropdownItems = [
    ListLanguage(1, "English"),
    ListLanguage(2, "Swahili"),
    ListLanguage(3, "Luganda"),
    ListLanguage(4, "Runyankole")
  ];
  late List<DropdownMenuItem<ListLanguage>> _dropdownMenuItems;
  ListLanguage? _selectedItem;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: stateManager.loginStateNotifier,
      builder: (context, _, __) {
        return ProgressWidget(
          child: _uiLoginSetup(context),
          inAsyncCall: stateManager.loading(),
          opacity: 0.3,
        );
      },
    );
  }

  Widget _uiLoginSetup(BuildContext context) {
    // print("hey hey" + stateManager.loginState.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: ToolsUtilities.mainPrimaryColor),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                LoginSecOne(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                            text: 'Test Version ',
                            style: TextStyle(color: Colors.redAccent, fontSize: 18),
                            // style: DefaultTextStyle.of(context).style,
                            ),
                        textAlign: TextAlign.left,
                      ),
                      customTextField('Username', false,
                          (v) => {stateManager.username = v}),
                      SizedBox(
                        height: 10,
                      ),
                      customTextField(
                          'Password', true, (v) => {stateManager.password = v}),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: stateManager.loginState != null
                              ? Text(stateManager.loginState!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15.0),
                                  textAlign: TextAlign.center)
                              : null),
                      // customeDropBox(_valueTwo, (String? value) {
                      //   setState(() {
                      //     _valueTwo = value!;
                      //   });
                      // }),
                      Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            // color: Colors.cyan,
                            border: Border.all(color: Colors.green)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              hint: Text(
                                "Choose a Language",
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              value: _selectedItem,
                              items: _dropdownMenuItems,
                              style: const TextStyle(color: Colors.blueGrey),
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  _selectedItem = value as ListLanguage?;
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: RaisedButton(
                          onPressed: () {
                            stateManager.signIn();
                            /*Navigator.push(context,MaterialPageRoute(
                                    builder: (context) => Homepage()));*/
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    initApp();
  }

  List<DropdownMenuItem<ListLanguage>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListLanguage>> items =
        <DropdownMenuItem<ListLanguage>>[];
    for (ListLanguage listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future<void> initApp() async {
    createDownloadFile();
  }
  //Shit
  //End Of
}
