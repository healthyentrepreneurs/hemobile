Future<void> _uploadData({
required bool isUploadingData,
required double uploadProgress,
bool simulateUpload = true,
}) async {
final ObjectBoxService _objectservice = await objectbox;
final DatabaseRepository databaseRepository =
DatabaseRepository(injectableModule.firestore, _objectservice);
final progressSubject = BehaviorSubject<double>();
// Use debounceTime to limit the rate of emitted values
progressSubject
.debounceTime(
const Duration(milliseconds: 200)) // Adjust the duration as needed
.listen((progress) async {
await _objectservice.save(
isUploadingData: isUploadingData,
uploadProgress: progress,
backupAnimation: false,
surveyAnimation: false,
booksAnimation: false,
dateCreated: DateTime.now(),
);
debugPrint("@REALTIME JIMMY $isUploadingData and $progress");
});
await databaseRepository.uploadData(
isUploadingData: isUploadingData,
uploadProgress: uploadProgress,
simulateUpload: simulateUpload,
onUploadStateChanged: (isUploading, progress) {
// Add the progress to the progressSubject stream
progressSubject.add(progress);
},
);
// await databaseRepository.uploadData(
//   isUploadingData: isUploadingData,
//   uploadProgress: uploadProgress,
//   simulateUpload: simulateUpload,
//   onUploadStateChanged: (isUploading, progress) {
//     // _objectservice.save(
//     //     isUploadingData: isUploadingData,
//     //     uploadProgress: progress,
//     //     backupAnimation: false,
//     //     surveyAnimation: false,
//     //     booksAnimation: false,
//     //     dateCreated: DateTime.now());
//     // debugPrint(
//     //     '@REALTIME JIMMY isUploadingData $isUploading uploadProgress $progress');
//     debugPrint("@REALTIME JIMMY $isUploadingData and $progress");
//   },
// );
progressSubject.close();
}


Workmanager().registerOneOffTask(
"1",
"simpleTask",
constraints: Constraints(
networkType: NetworkType.connected,
requiresBatteryNotLow: true,
requiresCharging: true,
requiresDeviceIdle: true,
requiresStorageNotLow: true
)
);