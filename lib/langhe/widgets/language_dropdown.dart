import 'package:flutter/material.dart';

class LanguageDropdownView extends StatelessWidget {
  final Function onChangedCallback;
  final String value;
  final Iterable<String> values;

  const LanguageDropdownView(
      {Key? key,
      required this.value,
      required this.values,
      required this.onChangedCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 15.0, right: 10.0),
        decoration: _boxDecoration(),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                value: value,
                items: values.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  onChangedCallback(newValue);
                }),
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    // https://www.kindacode.com/article/flutter-listtile/
    // https://stackoverflow.com/questions/47423297/how-can-i-add-a-border-to-a-widget-in-flutter
    // https://stackoverflow.com/questions/50687633/flutter-how-can-i-add-divider-between-each-list-item-in-my-code
    return const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
    );
  }
}

// State Management
// https://medium.com/coding-with-flutter/flutter-state-management-setstate-bloc-valuenotifier-provider-2c11022d871b
