import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:he_api/he_api.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../repo/impl/idatabase_repo.dart';

part 'database_event.dart';
part 'database_state.dart';

@injectable
class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc({required IDatabaseRepository repository})
      : _databaseRepository = repository,
        super(DatabaseInitial()) {
    on<DatabaseFetched>(_fetchUserData);
  }
  IDatabaseRepository _databaseRepository;
  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    List<Subscription?> listofSubscriptionData =
        await _databaseRepository.retrieveSubscriptionData();
    emit(DatabaseSuccess(listofSubscriptionData, event.displayName));
  }
}
