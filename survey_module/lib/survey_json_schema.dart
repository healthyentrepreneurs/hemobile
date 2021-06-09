library survey_module;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class SurveyJsonSchema extends StatefulWidget {
  const SurveyJsonSchema({
    @required this.form,
    @required this.onChanged,
    this.padding,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
    this.buttonSave,
    this.actionSave,
  });

  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final dynamic form;
  final double padding;
  final Widget buttonSave;
  final Function actionSave;
  final ValueChanged<dynamic> onChanged;

  @override
  _CoreSurveyFormState createState() => new _CoreSurveyFormState(form);
}

class _CoreSurveyFormState extends State<SurveyJsonSchema> {
  final dynamic formGeneral;
  int radioValue;
  int checkBoxValue;

  // validators

  _CoreSurveyFormState(this.formGeneral);

  String isRequired(item, value) {
    if (value.isEmpty) {
      return widget.errorMessages[item['key']] ?? 'Please enter some text';
    }
    return null;
  }

  String validateEmail(item, String value) {
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Email is not valid';
  }

  bool labelHidden(item) {
    if (item.containsKey('hiddenLabel')) {
      if (item['hiddenLabel'] is bool) {
        return !item['hiddenLabel'];
      }
    } else {
      return true;
    }
    return false;
  }

  // Return widgets

  List<Widget> jsonToForm() {
    List<Widget> listWidget = new List<Widget>();
    if (formGeneral['title'] != null) {
      listWidget.add(Text(
        formGeneral['title'],
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Theme.of(context).primaryColor),
      ));
    }
    /* if (formGeneral['name'] != null) {
      listWidget.add(Text(
        formGeneral['name'],
        style: new TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
      ));
    }*/

    listWidget.add(SizedBox(height: 30));

    for (var count = 0; count < formGeneral['elements'].length; count++) {
      Map item = formGeneral['elements'][count];

      if (item['type'] == "text" ||
          item['type'] == "Password" ||
          item['type'] == "Email" ||
          item['type'] == "TextArea" ||
          item['type'] == "TextInput") {
        Widget label = SizedBox.shrink();

        if (labelHidden(item)) {
          label = new Container(
            child: new Text(
              item['title']!=null?item['title']:'',
              style: new TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0,color: Colors.blueGrey),
            ),
          );
        }

        listWidget.add(new Container(
          margin: new EdgeInsets.only(top: 5.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              label,
              new TextFormField(
                controller: null,
                initialValue: /*formGeneral['elements'][count]['name'] ?? */ null,
                decoration: item['decoration'] ??
                    widget.decorations[item['key']] ??
                    new InputDecoration(
                      hintText: item['placeholder'] ?? "",
                      helperText: item['helpText'] ?? "",
                    ),
                maxLines: item['type'] == "TextArea" ? 10 : 1,
                onChanged: (String value) {
                  formGeneral['fields'][count]['value'] = value;
                  _handleChanged();
                },
                obscureText: item['type'] == "Password" ? true : false,
                validator: (value) {
                  if (widget.validations.containsKey(item['key'])) {
                    return widget.validations[item['key']](item, value);
                  }
                  if (item.containsKey('validator')) {
                    if (item['validator'] != null) {
                      if (item['validator'] is Function) {
                        return item['validator'](item, value);
                      }
                    }
                  }
                  if (item['type'] == "Email") {
                    return validateEmail(item, value);
                  }

                  if (item.containsKey('required')) {
                    if (item['required'] == true ||
                        item['required'] == 'True' ||
                        item['required'] == 'true') {
                      return isRequired(item, value);
                    }
                  }

                  return null;
                },
              ),
            ],
          ),
        ));
      }

      if (item['type'] == "radiogroup") {
        List<Widget> radios = [];

        if (labelHidden(item)) {
          radios.add(new Text("" + item['title'],
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                  color: Colors.blueGrey)));
        }
        //radioValue =0;
        for (var i = 0; i < item['choices'].length; i++) {
          radios.add(
            new Row(
              children: <Widget>[
                new Radio<int>(
                    value: i,
                    groupValue: radioValue,
                    onChanged: (int value) {
                      print(" --- >" + value.toString());
                      this.setState(() {
                        radioValue = value;
                        formGeneral['elements'][count]['choices'][value]
                                ['value_'] = formGeneral['elements'][count]['choices'][value]['value'];
                        print("Selected value is " +
                            (formGeneral['elements'][count]['choices'][value]
                                    ['value_'])
                                .toString());
                        _handleChanged();
                      });
                    }),
                new Expanded(
                    child: new Text(
                  formGeneral['elements'][count]['choices'][i]['text'],
                  style: TextStyle(color: Colors.blueGrey),
                )),
              ],
            ),
          );
        }

        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: radios,
            ),
          ),
        );

        listWidget.add(
            SizedBox(
              height: 30,
            )
        );
      }

      /*if (item['type'] == "Switch") {
        if (item['value'] == null) {
          formGeneral['fields'][count]['value'] = false;
        }
        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Row(children: <Widget>[
              new Expanded(child: new Text(item['label'])),
              new Switch(
                value: item['value'] ?? false,
                onChanged: (bool value) {
                  this.setState(() {
                    formGeneral['fields'][count]['value'] = value;
                    _handleChanged();
                  });
                },
              ),
            ]),
          ),
        );
      }*/

      if (item['type'] == "file") {
        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: Column(
                children: <Widget>[
                  Text(item['title']!=null?item['title']:''),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton.icon(
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      // ...

                      // ...
                    },
                    icon: Icon(Icons.file_upload, size: 18),
                    label: Text("SELECT PICTURE"),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ]),
          ),
        );
      }

      if (item['type'] == "html") {
        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: Column(
                children: <Widget>[
                  Text(item['html']!=null?item['html']:'',
                  style: TextStyle(color: Colors.green),),
                  SizedBox(
                    height: 40,
                  ),

                ]),
          ),
        );
      }

      if (item['type'] == "checkbox") {
        List<Widget> checkboxes = [];
        if (labelHidden(item)) {
          checkboxes.add(new Text("" + item['title'],
              style: new TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                  color: Colors.blueGrey)));
        }

        int checkBoxValue = -1;
        for (var i = 0; i < item['choices'].length; i++) {
          checkboxes.add(
            new Row(
              children: <Widget>[
                new Checkbox(
                  value: formGeneral['elements'][count]['choices'][i]
                          ['value_'] ??
                      false,
                  onChanged: (bool value) {
                    checkBoxValue = i;
                    formGeneral['elements'][count]['choices'][value]['value_'] =
                        formGeneral['elements'][count]['choices'][value]
                            ['value'];
                    print("Selected value is " +
                        (formGeneral['elements'][count]['choices'][value]
                                ['value_'])
                            .toString());
                    _handleChanged();
                  },
                ),
                new Expanded(
                    child: new Text(
                        formGeneral['elements'][count]['choices'][i]['text'],
                        style: TextStyle(color: Colors.blueGrey))),
              ],
            ),
          );
        }

        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: checkboxes,
            ),
          ),
        );

        listWidget.add(
            SizedBox(
              height: 30,
            )
        );
      }

      /*if (item['type'] == "Select") {
        Widget label = SizedBox.shrink();
        if (labelHidden(item)) {
          label = new Text(item['label'],
              style:
                  new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0));
        }

        listWidget.add(new Container(
          margin: new EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              label,
              new DropdownButton<String>(
                hint: new Text("Select a user"),
                value: formGeneral['fields'][count]['value'],
                onChanged: (String newValue) {
                  setState(() {
                    formGeneral['fields'][count]['value'] = newValue;
                    _handleChanged();
                  });
                },
                items:
                    item['items'].map<DropdownMenuItem<String>>((dynamic data) {
                  return DropdownMenuItem<String>(
                    value: data['value'],
                    child: new Text(
                      data['label'],
                      style: new TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ));
      }*/
    }

    if (widget.buttonSave != null) {
      listWidget.add(new Container(
        margin: EdgeInsets.only(top: 10.0),
        child: InkWell(
          onTap: () {
            if (_formKey.currentState.validate()) {
              widget.actionSave(formGeneral);
            }
          },
          child: widget.buttonSave,
        ),
      ));
    }
    return listWidget;
  }

  void _handleChanged() {
    widget.onChanged(formGeneral);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: new Container(
        padding: new EdgeInsets.all(widget.padding ?? 8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  children: jsonToForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
