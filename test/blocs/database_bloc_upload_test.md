import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseRepository extends Mock implements DatabaseRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue<DatabaseEvent>(FakeDatabaseEvent());
  });

  group('DatabaseBloc', () {
    late DatabaseRepository databaseRepository;
    late DatabaseBloc databaseBloc;

    setUp(() {
      databaseRepository = MockDatabaseRepository();
      databaseBloc = DatabaseBloc(repository: databaseRepository);
    });

    blocTest<DatabaseBloc, DatabaseState>(
      'emits [] when nothing is added',
      build: () => databaseBloc,
      expect: () => [],
    );

    blocTest<DatabaseBloc, DatabaseState>(
      'emits DatabaseState when UploadDataEvent is added',
      build: () => databaseBloc,
      act: (bloc) => bloc.add(
        UploadDataEvent(
          isUploadingData: true,
          uploadProgress: 50.0,
          simulateUpload: true,
          onUploadStateChanged: (_, __) {},
        ),
      ),
      expect: () => [], // Add your expected DatabaseState instances here
    );
  });
}

class FakeDatabaseEvent extends Fake implements DatabaseEvent {}