Future<void> _saveSurveyToFirestore({
required SurveyDataModel survey,
}) async {
await _firestore
.collection('surveyposts')
.doc(survey.country)
.collection(survey.surveyId)
.add({
'userId': survey.userId,
'surveyVersion': survey.surveyVersion,
'surveyobject': survey.surveyObject,
'surveyId': survey.surveyId,
// 'dateCreated': survey.dateCreated.toIso8601String(),
});
}

//