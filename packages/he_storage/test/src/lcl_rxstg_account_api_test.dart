import 'package:flutter_test/flutter_test.dart';
import 'package:he_storage/he_storage.dart';
import 'package:mocktail/mocktail.dart';

import 'test_he_stg_constants.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LclRxStgAccountApi', () {
    late RxSharedPreferences rxPrefs;
    late LclRxStgAccountApi api;
    const account = Account(
      id: id,
      username: username,
      email: email,
      lang: lang,
      country: country,
    );
    final kTestValues = <String, Object>{
      'flutter.int': 1337,
      LclRxStgAccountApi.actCacheKey: Account.accountToString(account)!,
    };

    final kTestValues2 = <String, Object>{
      'flutter.String': 'goodbye world',
      'flutter.bool': false,
    };

    setUp(() async {
      SharedPreferences.setMockInitialValues(kTestValues);
      final prefs = await SharedPreferences.getInstance();
      rxPrefs = RxSharedPreferences(
        prefs,
        // const RxSharedPreferencesDefaultLogger(),
      );
      api = LclRxStgAccountApi(rxPrefs: rxPrefs);
    });

    tearDown(() async {
      try {
        await rxPrefs.dispose();
        await rxPrefs.clear();
      } catch (_) {}
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          api,
          isA<LclRxStgAccountApi>(),
        );
      });
      group('initializes the user stream', () {
        test('with existing user if present', () {
          expect(api.getAccount(), emits(account));
        });
        test('with empty user if no user present', () async {
          SharedPreferences.setMockInitialValues(kTestValues2);
          await rxPrefs.reload();
          expect(api.getAccount(), emits(Account.empty));
        });
      });
    });

    test('getAccount returns current user stream ', () async {
      expect(
        api.getAccount(),
        emits(account),
      );
    });

    group('saveAccount', () {
      test('saves account', () async {
        const newAccount = Account(
          id: 4,
          username: username,
          email: email,
          lang: lang,
          country: country,
        );
        final saveAccount = api.saveAccount(newAccount);
        expect(saveAccount, completes);
        await saveAccount; //add await for emit
        expect(api.getAccount(), emits(newAccount));
        expect(await api.getAccount().first, newAccount);
      });
      test(
        'fails to save empty account',
        () {
          const emptyAccount = Account.empty;
          expect(
            () => api.saveAccount(emptyAccount),
            throwsA(isA<AccountNotFoundException>()),
          );
        },
      );
    });

    group('deleteAccount', () {
      test('deletes existing account', () async {
        //@ Start here
        final deleteAccount = api.deleteAccount(3); //Sample Account ID 3
        expect(deleteAccount, completes);
        await deleteAccount; //add await for emit to work below
        expect(api.getAccount(), emits(Account.empty));
        expect(await api.getAccount().first, Account.empty);
      });
      test(
        'throws AccountNotFoundException if account id is 0 '
        'with provided id is not found',
        () async {
          SharedPreferences.setMockInitialValues(kTestValues2);
          await rxPrefs.reload();
          expect(
            () => api.deleteAccount(0),
            throwsA(isA<AccountNotFoundException>()),
          );
        },
      );
      test(
        'throws AccountNotFoundException if account id mismatch or not found',
        () {
          expect(
            () => api.deleteAccount(10),
            throwsA(isA<AccountNotFoundException>()),
          );
        },
      );
    });
  });
}
