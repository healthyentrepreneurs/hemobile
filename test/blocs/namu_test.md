import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';
import 'package:he/objects/blocs/repo/database_repo.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';
import 'package:mocktail/mocktail.dart';


class MockDatabaseRepository extends Mock implements DatabaseRepository {
  @override
  Future<List<Subscription>> retrieveSubscriptionData(String userid, String subscriptiontype) async {
    if (userid == 'user1' && subscriptiontype == 'all') {
      return <Subscription>[
        Subscription(id: 1, fullname: 'Subscription 1'),
        Subscription(id: 2, fullname: 'Subscription 2'),
      ];
    } else if (userid == 'user1' && subscriptiontype == 'active') {
      return <Subscription>[
        Subscription(id: 1, fullname: 'Subscription 1'),
      ];
    } else if (userid == 'user1' && subscriptiontype == 'inactive') {
      return <Subscription>[
        Subscription(id: 2, fullname: 'Subscription 2'),
      ];
    } else {
      throw RepositoryFailure('User not found');
    }
  }
}

void main() {
  late DatabaseBloc bloc;
  late DatabaseRepository repository;

  setUp(() {
    repository = MockDatabaseRepository();
    bloc = DatabaseBloc(repository: repository);
  });

  test('Initial state is correct', () {
    expect(bloc.state, const DatabaseState.loading());
  });

  blocTest<DatabaseBloc, DatabaseState>(
    'Emits [success] when _onDatabaseLoadEvent is called without error',
    build: () {
      when(() => repository.retrieveSubscriptionDataStream(
        any(named: 'userid'),
        any(named: 'subscriptiontype'),
      )).thenAnswer((_) async => const Right(<Subscription>[
        Subscription(id: 1, fullname: 'Subscription 1'),
        Subscription(id: 2, fullname: 'Subscription 2'),
      ]));
      return bloc;
    },
    act: (bloc) => bloc.add(DatabaseLoadEvent()),
    expect: () => [
      bloc.state.copyWith(listOfSubscriptionData: <Subscription>[
        Subscription(id: 1, fullname: 'Subscription 1'),
        Subscription(id: 2, fullname: 'Subscription 2'),
      ]), // Using copyWith
    ],
  );

  blocTest<DatabaseBloc, DatabaseState>(
    'Emits [error] when _onDatabaseLoadEvent is called with error',
    build: () {
      when(() => repository.retrieveSubscriptionDataStream(
        any(named: 'userid'),
        any(named: 'subscriptiontype'),
      )).thenAnswer((_) async => Left(RepositoryFailure('Error loading subscriptions')));
      return bloc;
    },
    act: (bloc) => bloc.add(DatabaseLoadEvent()),
    expect: () => [
      bloc.state.copyWith(
        error: RepositoryFailure('Error loading subscriptions'),
      ), // Using copyWith
    ],
  );
}