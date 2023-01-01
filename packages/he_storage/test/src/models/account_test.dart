// ignore_for_file: avoid_redundant_argument_values
import 'package:flutter_test/flutter_test.dart';
import 'package:he_storage/he_storage.dart';

import '../test_he_stg_constants.dart';

void main() {
  group('Account', () {
    Account createAccount({
      int? id = id,
      String username = username,
      String email = email,
      String lang = lang,
      String country = country,
    }) {
      return Account(
        id: id,
        username: username,
        email: email,
        lang: lang,
        country: country,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(
          createAccount,
          returnsNormally,
        );
      });

      test('sets id if not provided', () {
        expect(
          createAccount(id: 0),
          isNotEmpty,
        );
      });
    });

    test('supports value equality', () {
      expect(
        createAccount(),
        equals(createAccount()),
      );
    });

    test('props are correct', () {
      expect(
        createAccount().props,
        equals([
          id,
          username,
          email,
          lang,
          country,
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createAccount().copyWith(),
          equals(createAccount()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createAccount().copyWith(
            id: null,
            username: null,
            email: null,
            lang: null,
            country: null,
          ),
          equals(createAccount()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createAccount().copyWith(
            id: 2,
            username: 'josh',
            email: 'megasega@gmail.com',
            lang: 'en',
            country: 'KE',
          ),
          equals(
            createAccount(
              id: 2,
              username: 'josh',
              email: 'megasega@gmail.com',
              lang: 'en',
              country: 'KE',
            ),
          ),
        );
      });
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Account.fromJson(const <String, dynamic>{
            'id': id,
            'username': username,
            'email': email,
            'lang': lang,
            'country': country,
          }),
          equals(createAccount()),
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          createAccount().toJson(),
          equals(<String, dynamic>{
            'id': id,
            'username': username,
            'email': email,
            'lang': lang,
            'country': country,
          }),
        );
      });
    });
  });
}
