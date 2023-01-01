import 'package:flutter_test/flutter_test.dart';
import 'package:he_api/he_api.dart';

import '../test_he_api_constants.dart';


// https://dhruvnakum.xyz/testing-in-flutter-unit-test
void main() {
  group('User', () {
    late User _user;
    setUp(() {
      _user = const User(
        id: id,
        username: username,
        firstname: firstname,
        lastname: lastname,
        email: email,
        lang: lang,
        country: country,
        profileimageurlsmall: profileSmall,
      );
    });
    // _user
    User getUser({
      int id = id,
      String username = username,
      String firstname = firstname,
      String lastname = lastname,
      String email = email,
      String lang = lang,
      String country = country,
      String profileimageurlsmall = profileSmall,
    }) {
      return _user;
    }

    group('constructor', () {
      test('User works correctly', () {
        expect(
          getUser,
          returnsNormally,
        );
      });
      test('uses value equality', () {
        expect(
          _user,
          equals(
            const User(
              id: id,
              username: username,
              firstname: firstname,
              lastname: lastname,
              email: email,
              lang: lang,
              country: country,
              profileimageurlsmall: profileSmall,
            ),
          ),
        );
      });

      test('isEmpty returns true for empty user', () {
        expect(User.empty.isEmpty, isTrue);
      });

      test('isNotEmpty returns false for empty user', () {
        expect(User.empty.isNotEmpty, isFalse);
      });

      test('isEmpty returns false for non-empty user', () {
        final user = User.fromJson(_user.toJson());
        expect(user.isEmpty, isFalse);
      });
      test('isNotEmpty returns true for non-empty user', () {
        final user = User.fromJson(_user.toJson());
        expect(user.isNotEmpty, isTrue);
      });
      test('User props are correct', () {
        expect(
          getUser().props,
          equals([
            _user.id,
            _user.username,
            _user.firstname,
            _user.lastname,
            '11206@healthyentrepreneurs.nl',
            'en',
            'UG',
            profileSmall
          ]),
        );
      });
      group('User copyWith', () {
        test('returns the same object if not arguments are provided', () {
          expect(
            _user.copyWith(),
            equals(_user),
          );
        });

        test('retains the old value for every parameter if null is provided',
            () {
          expect(
            _user.copyWith(
              id: null,
              username: null,
              token: null,
              firstname: null,
            ),
            equals(_user),
          );
        });
        test('retains the old value for every parameter if null is provided',
            () {
          const _cUser = User(id: 2, username: 'novus', token: 'xxx');
          expect(
            _cUser.copyWith(
              id: 3,
              username: 'novus',
            ),
            // expect(x != y, true)
            isNot(equals(_cUser)),
          );
        });
        // https://github.com/felangel/bloc/blob/master/examples/flutter_todos/packages/todos_api/test/models/todo_test.dart
      });

      group('User fromJson', () {
        test('User fromJson works correctly', () {
          expect(
            User.fromJson(const <String, dynamic>{
              'token': "0404e892bb10bf68e08e1c2d55b30e3d",
              'id': 3,
              'username': '11206',
              'firstname': 'Aannet',
              'lastname': 'Hanga',
              'fullname': 'Aannet Hanga',
              'email': '11206@healthyentrepreneurs.nl',
              'lang': 'en',
              'country': 'UG',
              'profileimageurlsmall':profileSmall,
              'profileimageurl':profileimageurl,
            }),
            equals(getUser()),
          );
        });
      });
      group('Subscriptions fromJson', () {
        test('Subscriptions fromJson works correctly', () {
          final userSubscription = User.fromJson(const <String, dynamic>{
            "token": "0404e892bb10bf68e08e1c2d55b30e3d",
            "id": 3,
            "username": "11206",
            "firstname": "Aannet",
            "lastname": "Hanga",
            "fullname": "Aannet Hanga",
            "email": "11206@healthyentrepreneurs.nl",
            "lang": "en",
            "country": "UG",
            'profileimageurlsmall': profileSmall,
            'profileimageurl': profileimageurl,
            'subscriptions': [
              {
                'id': 3,
                'fullname': 'Education and Prevention',
                'categoryid': 2,
                'source': 'moodle',
                'summary_custome': 'In Luganda ..',
                'next_link': '3',
                'image_url_small':imageUrlSmall,
                'image_url':imageUrl
              },
              {
                'id': 4,
                'fullname': 'Education and Prevention RU',
                'categoryid': 3,
                'source': 'moodle',
                'summary_custome': 'In Runyankole .. ',
                'next_link': '4',
                'image_url_small':imageUrlSmall,
                'image_url':imageUrl
              }
            ]
          }).subscriptions?.first;
          // userSubscription.subscriptions.first
          expect(
            userSubscription,
            equals(
              const Subscription(
                id: 3,
                fullname: 'Education and Prevention',
                source: 'moodle',
                summaryCustome: 'In Luganda ..',
                categoryid: 2,
                imageUrlSmall:imageUrlSmall,
              ),
            ),
          );
        });
      });
    });
    tearDown(() {});
  });
}
