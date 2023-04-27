Future<void> uploadDataOps({
required bool isUploadingData,
required double uploadProgress,
bool simulateUpload = true,
required Function(bool, double) onUploadStateChanged,
}) async {
debugPrint("DatabaseBoxOperations@uploadDataOps $isUploadingData");

    if (simulateUpload) {
      // Set isUploadingData to true when the upload starts
      isUploadingData = true;
      // Resume data upload from the last saved progress (use your own upload logic here)
      for (int i = (uploadProgress * 100).toInt(); i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        uploadProgress = i / 100;
        onUploadStateChanged(isUploadingData, uploadProgress);
      }
      // Set isUploadingData to false when the upload is complete
      isUploadingData = false;
      uploadProgress = 0.0;
      debugPrint(
          "BEFORE DatabaseBoxOperations@onUploadStateChanged $isUploadingData and $uploadProgress \n");
      onUploadStateChanged(isUploadingData, uploadProgress);
      debugPrint(
          "AFTER DatabaseBoxOperations@onUploadStateChanged $isUploadingData and $uploadProgress \n");
    } else {
      // Set isUploadingData to true when the upload starts
      isUploadingData = true;

      // Call the savePendingSurveysToFirestoreAndSetNotPending method
      Map<String, int> uploadResult =
          await savePendingSurveysToFirestoreAndSetNotPending();

      // Calculate the upload progress
      if (uploadResult['total']! > 0) {
        uploadProgress = uploadResult['uploaded']! / uploadResult['total']!;
      } else {
        uploadProgress = 1.0;
      }
      onUploadStateChanged(isUploadingData, uploadProgress);

      // Set isUploadingData to false when the upload is complete
      isUploadingData = false;
      uploadProgress = 0.0;
      onUploadStateChanged(isUploadingData, uploadProgress);
    }

    saveState(
      isUploadingData: false,
      uploadProgress: 0.0,
      backupAnimation: false,
      surveyAnimation: false,
      booksAnimation: false,
    );
}