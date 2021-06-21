import 'package:flutter/material.dart';
import 'package:nl_health_app/core/model/surveysync_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SurveySyncScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ViewModelBuilder.reactive(
        builder: null, viewModelBuilder: () => SurveySyncViewModel());
  }
}
