import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he/objects/db_local/db_local.dart';
import 'package:he/survey/bloc/survey_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockDatabaseRepository extends Mock implements DatabaseRepository {}

void main() {
  group('SurveyBloc', () {
    late MockDatabaseRepository mockDatabaseRepository;
    late SurveyBloc surveyBloc;

    setUp(() {
      mockDatabaseRepository = MockDatabaseRepository();
      surveyBloc = SurveyBloc(repository: mockDatabaseRepository);
    });

    test('Initial state is correct', () {
      expect(surveyBloc.state, const SurveyState.loading());
    });

    blocTest<SurveyBloc, SurveyState>(
      'Emits [success] when _onSurveySave is called without error',
      build: () {
        when(() => mockDatabaseRepository.saveSurveys(
                surveyData: SurveyDataModel(
              userId: any(named: 'surveyId'),
              surveyVersion: any(named: 'surveyVersion'),
              surveyObject: any(named: 'surveyJson'),
              surveyId: any(named: 'country'),
              isPending: any(named: 'userId'),
              courseId: any(named: 'courseId'),
              country: any(named: 'isPending'),
            ))).thenAnswer((_) async => const Right(1));
        return surveyBloc;
      },
      act: (bloc) => bloc.add(const SurveySave(
        'surveyId',
        'surveyVersion',
        'surveyJson',
        'userId',
        'country',
        'courseId',
        true,
      )),
      expect: () => [
        surveyBloc.state.copyWith(surveySavedId: '1'), // Using copyWith
      ],
    );

    blocTest<SurveyBloc, SurveyState>(
      'Emits [error] when _onSurveySave is called with error',
      build: () {
        when(() => mockDatabaseRepository.saveSurveys(
                surveyData: SurveyDataModel(
              userId: any(named: 'surveyId'),
              surveyVersion: any(named: 'surveyVersion'),
              surveyObject: any(named: 'surveyJson'),
              surveyId: any(named: 'country'),
              isPending: any(named: 'userId'),
              courseId: any(named: 'courseId'),
              country: any(named: 'isPending'),
            ))).thenAnswer((_) async => Left(RepositoryFailure('')));
        return SurveyBloc(repository: mockDatabaseRepository);
      },
      act: (bloc) {
        const surveySaveEvent = SurveySave(
          'test_survey_id',
          'test_survey_version',
          'test_survey_json',
          'test_user_id',
          'test_country',
          'test_course_id',
          true,
        );
        bloc.add(surveySaveEvent);
      },
      expect: () => [
        isA<SurveyState>()
            .having((state) => state.ghenetworkStatus, 'henetworkStatus',
                HenetworkStatus.loading)
            .having((state) => state.error, 'error', isA<RepositoryFailure>())
      ],
    );
  });
}
