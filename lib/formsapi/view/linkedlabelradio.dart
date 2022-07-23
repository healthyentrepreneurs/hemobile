import 'package:flutter/material.dart';
import 'package:he/objects/googleforms/option.dart';

class GFormRadioBoxStatefulWidget extends StatefulWidget {
  const GFormRadioBoxStatefulWidget({Key? key, required this.optionsRadioBox})
      : super(key: key);
  final List<Option> optionsRadioBox;
  // String valueSet;
  @override
  State<GFormRadioBoxStatefulWidget> createState() =>
      _RadioBoxStatefulWidgetState();
}

class _RadioBoxStatefulWidgetState extends State<GFormRadioBoxStatefulWidget> {
  String _valueSet = "";
  @override
  Widget build(BuildContext context) {
    List<Option> options = widget.optionsRadioBox;
    return Column(
      children: <Widget>[
        for (var i = 0; i < options.length; i += 1)
          ListTile(
            title: Text(
              options[i].value,
            ),
            leading: Radio(
              value: options[i].value,
              groupValue: _valueSet,
              activeColor: const Color(0xFF6200EE),
              onChanged: (String? value) {
                setState(() {
                  // widget.valueSet = value!;
                  _valueSet = value!;
                });
              },
            ),
            onTap: () {
              setState(() {
                _valueSet = "";
              });
            },
          )
      ],
    );
  }
}
