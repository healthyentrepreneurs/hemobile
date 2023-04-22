import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he_api/he_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
// Import other required files and classes

// Create a Mock class for the DatabaseRepository
class MockDatabaseRepository extends Mock implements DatabaseRepository {}

void main() {
// Declare your variables
late DatabaseBloc databaseBloc;
late DatabaseRepository databaseRepository;

setUp(() {
// Initialize the MockDatabaseRepository and DatabaseBloc
databaseRepository = MockDatabaseRepository();
databaseBloc = DatabaseBloc(repository: databaseRepository);
});

tearDown(() {
// Close the databaseBloc
databaseBloc.close();
});

tearDown(() {
// Close the databaseBloc
databaseBloc.close();
});

// Test for DatabaseLoadEvent
blocTest<DatabaseBloc, DatabaseState>(
'emits [DatabaseState.loading()] when DatabaseLoadEvent is added',
build: () => databaseBloc,
act: (bloc) => bloc.add(DatabaseLoadEvent()),
expect: () => [const DatabaseState.loading()],
);
// Add the test for on<DatabaseFetched>(_fetchUserData)
blocTest<DatabaseBloc, DatabaseState>(
'emits state with fetched subscription data on successful DatabaseFetched event',
build: () {
// Mock the repository method to return a successful stream
final List<Subscription?> subscriptions = [
const Subscription(id: 1, fullname: 'Test')
];
when(() => databaseRepository.retrieveSubscriptionDataStream(any()))
.thenAnswer((_) => Stream.value(Right(subscriptions)));

      return databaseBloc;
    },
    act: (bloc) => bloc
        .add(const DatabaseFetched('test-user', HenetworkStatus.wifiNetwork)),
    expect: () => [
      // Expect the state with the fetched subscription data
      databaseBloc.state.copyWith(
        listOfSubscriptionData: const [Subscription(id: 1, fullname: 'Test')],
        henetworkStatus: HenetworkStatus.wifiNetwork,
        userid: 'test-user',
        error: null,
      ),
    ],
);

blocTest<DatabaseBloc, DatabaseState>(
'Emits [DatabaseState] with fetched data when DatabaseFetched is added',
build: () {
when(() => databaseRepository.retrieveSubscriptionDataStream(any()))
.thenAnswer((_) async* {
yield right([const Subscription(id: 1, fullname: 'Test Subscription')]);
});
return databaseBloc;
},
act: (bloc) => bloc.add(const DatabaseFetched('userId', null)),
expect: () => [
databaseBloc.state.copyWith(
listOfSubscriptionData: const [
Subscription(id: 1, fullname: 'Test Subscription')
],
henetworkStatus: null,
userid: 'userId',
error: null,
),
],
);

blocTest<DatabaseBloc, DatabaseState>(
'emits state with updated uploadProgress on UploadDataEvent',
build: () {
// Mock the repository method to return a successful future
when(() => databaseRepository.uploadData(
isUploadingData: any(named: 'isUploadingData'),
uploadProgress: any(named: 'uploadProgress'),
simulateUpload: any(named: 'simulateUpload'),
onUploadStateChanged: any(named: 'onUploadStateChanged'),
)).thenAnswer((invocation) {
final onUploadStateChanged = invocation
.namedArguments[#onUploadStateChanged] as Function(bool, double);
onUploadStateChanged(true, 50.0);
return Future.value();
});

      return databaseBloc;
    },
    act: (bloc) {
      bloc.add(UploadDataEvent(
        isUploadingData: true,
        uploadProgress: 50.0,
        simulateUpload: true,
        onUploadStateChanged: (bool isUploading, double progress) {},
      ));
    },
    expect: () => [
      // Expect the state with the updated uploadProgress
      databaseBloc.state.copyWith(
        isUploadingData: true,
        uploadProgress: 50.0,
      ),
    ],
);
// blocTest<DatabaseBloc, DatabaseState>(
//   'emits state with loaded data on successful LoadStateEvent',
//   build: () {
//     // Mock the repository method to return a successful future with data
//     when(() => databaseRepository.loadState()).thenAnswer((_) async {
//       return {
//         'isUploadingData': true,
//         'uploadProgress': 25.0,
//         'backupAnimation': false,
//         'surveyAnimation': false,
//         'booksAnimation': false,
//       };
//     });
//
//     return databaseBloc;
//   },
//   act: (bloc) => bloc.add( LoadStateEvent()),
//   expect: () => [
//     // Expect the state with the loaded data
//     databaseBloc.state.copyWith(
//       isUploadingData: true,
//       uploadProgress: 25.0,
//       backupAnimation: false,
//       surveyAnimation: false,
//       booksAnimation: false,
//     ),
//   ],
// );
// blocTest<DatabaseBloc, DatabaseState>(
//   'emits state with loaded data on successful LoadStateEvent',
//   build: () {
//     // Mock the repository method to return a successful future with data
//     when(() => databaseRepository.loadState()).thenAnswer((_) async {
//       return {
//         'isUploadingData': true,
//         'uploadProgress': 25.0,
//         'backupAnimation': false,
//         'surveyAnimation': false,
//         'booksAnimation': false,
//       };
//     });
//
//     return databaseBloc;
//   },
//   act: (bloc) => bloc.add(LoadStateEvent(onLoadStateChanged: (stateData) {
//     // Update the state with the loaded data
//     bloc.add(UpdateStateWithDataEvent(stateData: stateData));
//   })),
//   expect: () => [
//     // Expect the state with the loaded data
//     databaseBloc.state.copyWith(
//       isUploadingData: true,
//       uploadProgress: 25.0,
//       backupAnimation: false,
//       surveyAnimation: false,
//       booksAnimation: false,
//     ),
//   ],
// );
blocTest<DatabaseBloc, DatabaseState>(
'emits state with loaded data on successful LoadStateEvent',
build: () {
// Mock the repository method to return a successful future with data
when(() => databaseRepository.loadState()).thenAnswer((_) async {
return {
'isUploadingData': true,
'uploadProgress': 25.0,
'backupAnimation': false,
'surveyAnimation': false,
'booksAnimation': false,
};
});

      return databaseBloc;
    },
    act: (bloc) => bloc.add(LoadStateEvent(onLoadStateChanged: (stateData) {
      expect(stateData, {
        'isUploadingData': true,
        'uploadProgress': 25.0,
        'backupAnimation': false,
        'surveyAnimation': false,
        'booksAnimation': false,
      });
    })),
    expect: () => [], // No state change is expected in this case, since the data is passed through the onLoadStateChanged callback
);
}
