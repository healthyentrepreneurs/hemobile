_backupStateSubscription = repository
.getBackupStateDataModelStream()
.debounceTime(const Duration(milliseconds: 200)) // Adjust the duration as needed
.listen((event) {
debugPrint("EVANS ${event.toString()}");
add(UploadData(simulateUpload: false, backupStateData: event));
});

_backupStateSubscription = repository.getBackupStateDataModelStream()
.throttleTime(const Duration(milliseconds: 500)) // Add this line
.listen((event) {
debugPrint("EVANS ${event.toString()}");
add(UploadData(simulateUpload: false, backupStateData: event));
});

_backupStateSubscription =
repository.getBackupStateDataModelStream().listen((event) {
debugPrint("EVANS ${event.toString()}");
add(UploadData(simulateUpload: false, backupStateData: event));
});

EQUITABLE:
import 'package:equatable/equatable.dart';
import 'backup_state_data_model.dart';

class BackupStateDataModelWrapper extends Equatable {
final BackupStateDataModel data;

BackupStateDataModelWrapper({required this.data});

@override
List<Object?> get props => [
data.id,
data.uploadProgress,
data.isUploadingData,
data.backupAnimation,
data.surveyAnimation,
data.booksAnimation,
data.dateCreated,
];
}

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
// ...

DatabaseBloc({required this.repository})
: _databaseRepository = repository,
super(const DatabaseState.loading()) {
_backupStateSubscription =
repository
.getBackupStateDataModelStream()
.map((event) => BackupStateDataModelWrapper(data: event))
.distinct()
.listen((event) {
debugPrint("EVANS ${event.data.toString()}");
add(UploadData(simulateUpload: false, backupStateData: event.data));
});
}

// ...
}
