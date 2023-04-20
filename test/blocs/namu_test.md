import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:mocktail/mocktail.dart';


class MockDatabaseRepository extends Mock implements DatabaseRepository {}

void main() {
  late DatabaseBloc databaseBloc;
  late MockDatabaseRepository mockDatabaseRepository;

  setUpAll(() {
    registerFallbackValue<DatabaseState>(const DatabaseState.loading());
    registerFallbackValue<Function(bool, double)>((_, __) {});
  });

  setUp(() {
    mockDatabaseRepository = MockDatabaseRepository();
    databaseBloc = DatabaseBloc(repository: mockDatabaseRepository);
  });

  tearDown(() {
    databaseBloc.close();
  });

  blocTest<DatabaseBloc, DatabaseState>(
    'emits updated state on UploadDataEvent',
    build: () => databaseBloc,
    act: (bloc) => bloc.add( UploadDataEvent(
      isUploadingData: true,
      uploadProgress: 50.0,
      simulateUpload: true,
      onUploadStateChanged: null,
    )),
    expect: () => [
      isA<DatabaseState>().having(
            (state) => state.isUploadingData,
        'isUploadingData is true',
        true,
      ),
      isA<DatabaseState>().having(
            (state) => state.uploadProgress,
        'uploadProgress is 50.0',
        50.0,
      ),
    ],
  );

  blocTest<DatabaseBloc, DatabaseState>(
    'emits updated state on LoadStateEvent',
    build: () => databaseBloc,
    act: (bloc) => bloc.add(LoadStateEvent(onLoadStateChanged: (_) {})),
    expect: () => [], // Since LoadStateEvent doesn't emit a new state, we expect an empty list
  );

  blocTest<DatabaseBloc, DatabaseState>(
    'emits updated state on SaveStateEvent',
    build: () => databaseBloc,
    act: (bloc) => bloc.add(const SaveStateEvent(
      isUploadingData: true,
      uploadProgress: 100.0,
      backupAnimation: true,
      surveyAnimation: true,
      booksAnimation: true,
    )),
    expect: () => [
      isA<DatabaseState>().having(
            (state) => state.isUploadingData,
        'isUploadingData is true',
        true,
      ),
      isA<DatabaseState>().having(
            (state) => state.uploadProgress,
        'uploadProgress is 100.0',
        100.0,
      ),
      isA<DatabaseState>().having(
            (state) => state.backupAnimation,
        'backupAnimation is true',
        true,
      ),
      isA<DatabaseState>().having(
            (state) => state.surveyAnimation,
        'surveyAnimation is true',
        true,
      ),
      isA<DatabaseState>().having(
            (state) => state.booksAnimation,
        'booksAnimation is true',
        true,
      ),
    ],
  );
}
