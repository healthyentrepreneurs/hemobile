import 'package:flutter/material.dart';
import 'package:he/helper/helper_functions.dart';
import 'package:he/objects/googleforms/option.dart';

class GFormCheckboxStatefulWidget extends StatefulWidget {
  // const QuestionInstance({Key? key, this.item}) : super(key: key);
  // final Item? item;
  const GFormCheckboxStatefulWidget(
      {Key? key, required this.optionsCheckbox, required this.checkedParams})
      : super(key: key);
  final List<Option> optionsCheckbox;
  final List<bool> checkedParams;
  @override
  State<GFormCheckboxStatefulWidget> createState() =>
      _CheckboxStatefulWidgetState();
}

class _CheckboxStatefulWidgetState extends State<GFormCheckboxStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    List<Option> options = widget.optionsCheckbox;
    return Column(
      children: [
        for (var i = 0; i < options.length; i += 1)
          Row(
            children: [
              Checkbox(
                onChanged: (bool? value) {
                  setState(() {
                    widget.checkedParams[i] = value!;
                    // if (value != null) {
                    //   widget.checkedParams[i] = value;
                    //   printOnlyDebug("objectPrint $value");
                    // }else{
                    //   printOnlyDebug("objectPrintNaa $value");
                    // }
                    // checked[i] = value!;
                  });
                },
                value: widget.checkedParams[i],
                activeColor: const Color(0xFF6200EE),
              ),
              Text(
                options[i].value,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.black),
              ),
            ],
            // mainAxisAlignment: MainAxisAlignment.center,
          ),
      ],
    );
  }
}
