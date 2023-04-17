
late StreamSubscription<String> subscription;
subscription = _surveyBloc.surveySaveSuccessStream
.listen((savedId) {
ScaffoldMessenger.of(context).showSnackBar(SnackBar(
backgroundColor: Colors.green,
content: Text("Saved survey ID: $savedId")));
subscription.cancel();
});
debugPrint(
"SendingSurveyData  STARTAVA \n ${args[0]} \n SurveyID");
});
}