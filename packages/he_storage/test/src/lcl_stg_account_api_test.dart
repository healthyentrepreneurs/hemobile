import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:he_storage/he_storage.dart';
import 'package:mocktail/mocktail.dart';

import 'test_he_stg_constants.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LclStgAccountApi', () {
    late SharedPreferences plugin;
    const account = Account(
      id: id,
      username: username,
      email: email,
      lang: lang,
      country: country,
    );
    setUp(() {
      plugin = MockSharedPreferences();
      // accountApi = LclStgAccountApi(plugin: plugin);
      when(() => plugin.getString(any())).thenReturn(jsonEncode(account));
      when(() => plugin.setString(any(), any())).thenAnswer((_) async => true);
      when(() => plugin.remove(any())).thenAnswer((_) async => true);
    });
    LclStgAccountApi accountApi() {
      return LclStgAccountApi(
        plugin: plugin,
      );
    }

    // LclStgAccountApi createAccountNon() {
    //   when(() => plugin.getString(any())).thenReturn(null);
    //   return LclStgAccountApi(
    //     plugin: plugin,
    //   );
    // }

    group('constructor', () {
      test('works properly', () {
        expect(
          accountApi,
          returnsNormally,
        );
      });

      group('initializes the user stream', () {
        test('with existing user if present', () {
          // final _account = createAccount();
          expect(accountApi().getAccount(), emits(account));
          verify(
            () => plugin.getString(
              LclStgAccountApi.actCacheKey,
            ),
          ).called(1);
        });

        test('with empty user if no user present', () {
          when(() => plugin.getString(any())).thenReturn(null);
          // final _account = createAccount();
          expect(accountApi().getAccount(), emits(Account.empty));
          verify(
            () => plugin.getString(
              LclStgAccountApi.actCacheKey,
            ),
          ).called(1);
        });
      });
    });

    test('getAccount returns current user stream ', () {
      expect(
        accountApi().getAccount(),
        emits(account),
      );
    });

    group('saveAccount', () {
      test('saves account', () {
        const newAccount = Account(
          id: 4,
          username: username,
          email: email,
          lang: lang,
          country: country,
        );
        final _account = accountApi();
        expect(_account.saveAccount(newAccount), completes);
        expect(_account.getAccount(), emits(newAccount));
        verify(
          () => plugin.setString(
            LclStgAccountApi.actCacheKey,
            jsonEncode(newAccount),
          ),
        ).called(1);
      });
      test(
        'fails to save empty account',
        () {
          const emptyAccount = Account.empty;
          // final _account = accountApi();
          expect(
            () => accountApi().saveAccount(emptyAccount),
            throwsA(isA<AccountNotFoundException>()),
          );
        },
      );
    });

    group('deleteAccount', () {
      test('deletes existing account', () {
        final _account = accountApi();
        expect(_account.deleteAccount(3), completes);
        expect(_account.getAccount(), emits(Account.empty));
        verify(
          () => plugin.remove(
            LclStgAccountApi.actCacheKey,
          ),
        ).called(1);
      });
      test(
        'throws AccountNotFoundException if account id is 0 '
        'with provided id is not found',
        () {
          // final _account = accountApi();
          expect(
            () => accountApi().deleteAccount(0),
            throwsA(isA<AccountNotFoundException>()),
          );
        },
      );
      test(
        'throws AccountNotFoundException if account id mismatch with provided id is not found',
        () {
          expect(
            () => accountApi().deleteAccount(10),
            throwsA(isA<AccountNotFoundException>()),
          );
        },
      );
    });
  });
}
