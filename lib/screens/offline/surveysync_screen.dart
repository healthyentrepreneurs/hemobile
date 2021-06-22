import 'package:flutter/material.dart';
import 'package:nl_health_app/core/model/surveysync_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SurveySyncScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ViewModelBuilder.reactive(
        builder: (context, model, child) =>_counterWidget(model,context), viewModelBuilder: () => SurveySyncViewModel());
  }
  Widget _counterWidget(SurveySyncViewModel model, BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${model.counter}', //                           <-- view model
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          model.increment(); //                                <-- view model
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }


  Widget _uiSetup(SurveySyncViewModel model,BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sync Data Sets")),
        body: Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 50.0),
                Text(model.reportMessage,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.orange)),
                SizedBox(height: 50.0),
                Text("Total Survey Data Sets "+model.count.toString(),
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 20.0),
                Text("Other Data Sets "+model.countDataSet.toString(),
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 10.0),
                model.surveyUploadDate!= null
                    ? Text("Last Update date"+model.surveyUploadDate,
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
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: RaisedButton(
                      onPressed: () {
                        //call syc method here...
                        model.pushAllDataSetsNow();
                      },
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
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
                // showAlert
                //     ? alertCardPopup('Sync Info',
                //     "Failed to submit data You can upload the local data sets when")
                //     : Text('')
              ],
            ),
          ),
        ));
  }
}
