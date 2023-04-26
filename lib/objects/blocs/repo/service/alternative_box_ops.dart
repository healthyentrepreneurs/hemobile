// Call the savePendingSurveysToFirestoreAndSetNotPending method with the progress update callback
// await savePendingSurveysToFirestoreAndSetNotPending(
//   onUploadProgressChanged: (progress) {
//     uploadProgress = progress;
//     debugPrint(
//         "WALAH DatabaseBoxOperations@onUploadStateChanged $isUploadingData and $uploadProgress \n");
//     onUploadStateChanged(isUploadingData, uploadProgress);
//   },
// );

// Future<void> savePendingSurveysToFirestoreAndSetNotPending({
//   required Function(double) onUploadProgressChanged,
// }) async {
//   List<SurveyDataModel> pendingSurveys =
//       await getSurveysByPendingStatusWithCurrentTimeLimit(true);
//
//   int totalPendingSurveys = pendingSurveys.length;
//   int uploadedSurveys = 0;
//
//   for (SurveyDataModel survey in pendingSurveys) {
//     Either<Failure, void> result = await saveSurveysfireStore(
//       surveyId: survey.surveyId,
//       country: survey.country,
//       userId: survey.userId,
//       surveyJson: survey.surveyObject,
//       surveyVersion: survey.surveyVersion,
//     );
//     result.fold(
//       (failure) {
//         debugPrint("Failed to upload survey: $failure");
//       },
//       (_) async {
//         // Update the isPending flag to false
//         survey.isPending = false;
//         // await updateSurvey(survey);
//         uploadedSurveys++;
//         // Update the upload progress
//         double progress = uploadedSurveys / totalPendingSurveys;
//         onUploadProgressChanged(progress);
//       },
//     );
//   }
// }

// Future<void> savePendingSurveysToFirestoreAndSetNotPendingSimulated({
//   required Function(double) onUploadProgressChanged,
// }) async {
//   List<SurveyDataModel> pendingSurveys =
//   await getSurveysByPendingStatusWithCurrentTimeLimit(true);
//   int uploadedSurveysSimulated = 0;
//   int totalSteps = pendingSurveys.length;
//   for (SurveyDataModel survey in pendingSurveys) {
//     await Future.delayed(const Duration(milliseconds: 500));
//     Either<Failure, void> result = await saveSurveysfireStore(
//       surveyId: survey.surveyId,
//       country: survey.country,
//       userId: survey.userId,
//       surveyJson: survey.surveyObject,
//       surveyVersion: survey.surveyVersion,
//     );
//     result.fold(
//           (failure) {
//         debugPrint("SALOME Failed to upload survey: $failure");
//       },
//           (_) async {
//         // Update the isPending flag to false
//         // await updateSurvey(survey);
//         uploadedSurveysSimulated++;
//         // Update the upload progress
//         double progress = uploadedSurveysSimulated / totalSteps;
//         onUploadProgressChanged(progress);
//       },
//     );
//   }
//   debugPrint("Total uploaded surveys simulated: $uploadedSurveysSimulated");
// }
