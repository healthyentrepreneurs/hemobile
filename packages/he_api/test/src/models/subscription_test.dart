import 'package:flutter_test/flutter_test.dart';
import 'package:he_api/he_api.dart';

void main() {
  group('Subscription', () {
    const id = 3;
    const fullname = 'Education and Prevention';
    const source = 'moodle';
    const summaryCustome = 'In Luganda ..';
    const categoryid = 2;
    const imageUrlSmall = 'education.png';
    Subscription getSubscription({
      int id = id,
      String fullname = fullname,
      String source = source,
      String summaryCustome = summaryCustome,
      int categoryid = categoryid,
      String imageUrlSmall = imageUrlSmall,
    }) {
      return Subscription(
        id: id,
        fullname: fullname,
        source: source,
        summaryCustome: summaryCustome,
        categoryid: categoryid,
        imageUrlSmall: imageUrlSmall,
      );
    }

    group('constructor', () {
      test('Subscription works correctly', () {
        expect(
          getSubscription,
          returnsNormally,
        );
      });
      test('subscription value equality', () {
        expect(
          const Subscription(
            id: id,
            fullname: fullname,
            source: source,
            summaryCustome: summaryCustome,
            categoryid: categoryid,
            imageUrlSmall: imageUrlSmall,
          ),
          equals(
            const Subscription(
              id: id,
              fullname: fullname,
              source: source,
              summaryCustome: summaryCustome,
              categoryid: categoryid,
              imageUrlSmall: imageUrlSmall,
            ),
          ),
        );
      });

      test('isEmpty returns true for empty subscription', () {
        expect(Subscription.empty.isEmpty, isTrue);
      });

      test('isNotEmpty returns false for empty subscription', () {
        expect(Subscription.empty.isNotEmpty, isFalse);
      });

      test('isEmpty returns false for non-empty subscription', () {
        const subscription = Subscription(
          id: 3,
          fullname: 'fullname',
          source: 'source',
          summaryCustome: 'summaryCustome',
          categoryid: 4,
        );
        expect(subscription.isEmpty, isFalse);
      });
      test('isNotEmpty returns true for non-empty subscription', () {
        const subscription = Subscription(
          id: 3,
          fullname: 'fullname',
          source: 'source',
          summaryCustome: 'summaryCustome',
          categoryid: 4,
        );
        expect(subscription.isNotEmpty, isTrue);
      });
      test('Subscription props are correct', () {
        expect(
          getSubscription().props,
          equals([
            3,
            'Education and Prevention',
            'moodle',
            'In Luganda ..',
            2,
            'education.png'
          ]),
        );
      });

      group('Subscription fromJson', () {
        test('Subscription fromJson works correctly', () {
          expect(
            Subscription.fromJson(const <String, dynamic>{
              'id': 3,
              'fullname': 'Education and Prevention',
              'source': 'moodle',
              'summary_custome': 'In Luganda ..',
              'categoryid': 2,
              'image_url_small': 'education.png'
            }),
            equals(getSubscription()),
          );
        });
      });
    });
  });
}
