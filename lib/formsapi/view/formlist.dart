import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:he/formsapi/formsapi.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/widgets/heicon.dart';
import 'package:he/objects/objectform.dart';
import 'package:http/http.dart' as http;

class FormList extends StatefulWidget {
  const FormList({Key? key}) : super(key: key);

  @override
  State<FormList> createState() => _FormListState();
}

class _FormListState extends State<FormList> {
  //Hosting https://script.google.com/home
  //Deployment ID: AKfycbwLCoJE-ntHek03xrMrTabFEQd2eOGjZ4hZzZoXidHOERVSvYJEJ6PujtpSn55R63k
  //Web app : https://script.google.com/macros/s/AKfycbwLCoJE-ntHek03xrMrTabFEQd2eOGjZ4hZzZoXidHOERVSvYJEJ6PujtpSn55R63k/exec

  // https://script.googleusercontent.com/macros/echo?user_content_key=09F6Sx76WplSe-zIN5tCKfbQ8h3-Qlm3IMUu-1T4JsgsSdEJ-MSLJsO1f4bXbGqCwB7vbLZQcLfPPjBflTB1LtOG-mBxyrWLOJmA1Yb3SEsKFZqtv3DaNYcMrmhZHmUMWojr9NvTBuBLhyHCd5hHa0zAL1KgGte5eWAbL4UPUubzG4qL0fuaai_L8QYswnm_mfH1Iuv2-2sxTBgLJueud_35kbai7fWUwJk9ot0qfWpdZ9bqcKoj-EALmaJ23tE4d5AGH9kjeuj_8kIatPOwcAOGDZNnUnqnCrlTOova4bQ2nljyYW3lmycQ9R5MSJ4G2ebZPyxaEAsWviskmjogeg&lib=Mb5yIZo_R_x4EiWbOGfatD-_f9Eepb8L8
  // https://developers.google.com/apps-script/reference/forms
  // https://developers.google.com/forms/api/reference/rest
  Future<http.Response> getForms() {
    return http.get(
      urlConvert(
          'https://script.google.com/macros/s/AKfycbwLCoJE-ntHek03xrMrTabFEQd2eOGjZ4hZzZoXidHOERVSvYJEJ6PujtpSn55R63k/exec?action=getListofForms'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Google Forms",
            style: TextStyle(color: ToolUtils.mainPrimaryColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor),
        ),
        body: Stack(children: [
          FutureBuilder<http.Response>(
            future:
                getForms.call(), // a previously-obtained Future<String> or null
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                final _quizFormArray = objectFormFromJson(snapshot.data!.body);
                // printOnlyDebug("and ${_quizFormArray.first.name}");
                return ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: _quizFormArray.length,
                  itemBuilder: (BuildContext context, int index) {
                    var subscription = _quizFormArray[index];
                    return Card(
                      child: ListTile(
                        // autofocus: true,
                        title: Text(
                          subscription.name,
                          style: GoogleFonts.raleway(
                            textStyle: Theme.of(context).textTheme.headline1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const HeIcon(photo: "iconName"),
                        dense: false,
                        subtitle: const Text("He Nope"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FormWidget(webobject: subscription),
                              ));
                        },
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          )
        ]));
  }

  Uri urlConvert(String url) {
    return Uri.parse(url);
  }
}
