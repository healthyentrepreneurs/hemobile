import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:he_storage/he_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockRxSharedPreferences extends Mock implements RxSharedPreferences {}

void main() {
  group('LclRxStgUpdateUploadApi', () {
    late LclRxStgUpdateUploadApi api;
    late MockRxSharedPreferences mockRxPrefs;

    setUp(() {
      mockRxPrefs = MockRxSharedPreferences();
      api = LclRxStgUpdateUploadApi(rxPrefs: mockRxPrefs);
    });

    test('saveUpdateUpload should save UpdateUpload object', () async {
      final user = UpdateUpload(
          id: 1,
          uploadProgress: 50.0,
          isUploadingData: true,
          backupAnimation: true,
          surveyAnimation: true,
          booksAnimation: true);
      final String? userJson = UpdateUpload.updateUploadToString(user);

      when(() => mockRxPrefs.read(any(), any())).thenAnswer((_) async => null);

      when(() => mockRxPrefs.write<UpdateUpload>(any(), any(), any()))
          .thenAnswer((_) async => {});

      // Update the read call with the correct method and parameter
      when(() => mockRxPrefs.read(LclRxStgUpdateUploadApi.updateuploadCacheKey,
              UpdateUpload.toUpdateUploadOrEmpty))
          .thenAnswer((_) async => UpdateUpload.empty);

      try {
        await api.saveUpdateUpload(user);
      } catch (e) {
        fail('Unexpected exception: $e');
      }

      // Update the verify call with the correct method and parameter
      verify(() => mockRxPrefs.read(
          LclRxStgUpdateUploadApi.updateuploadCacheKey,
          UpdateUpload.toUpdateUploadOrEmpty)).called(1);
      verify(() => mockRxPrefs.write<UpdateUpload>(
            LclRxStgUpdateUploadApi.updateuploadCacheKey,
            user,
            UpdateUpload.updateUploadToString,
          )).called(1);
    });

    test('saveUpdateUpload should update existing UpdateUpload object',
        () async {
      const existingUser = UpdateUpload(
          id: 1,
          uploadProgress: 40.0,
          isUploadingData: false,
          backupAnimation: false,
          surveyAnimation: false,
          booksAnimation: false);
      const updatedUser = UpdateUpload(
          id: 1,
          uploadProgress: 60.0,
          isUploadingData: true,
          backupAnimation: true,
          surveyAnimation: true,
          booksAnimation: true);

      // Update the read call to return an existing user
      when(() => mockRxPrefs.read(LclRxStgUpdateUploadApi.updateuploadCacheKey,
              UpdateUpload.toUpdateUploadOrEmpty))
          .thenAnswer((_) async => existingUser);

      when(() => mockRxPrefs.write<UpdateUpload>(any(), any(), any()))
          .thenAnswer((_) async => {});

      try {
        await api.saveUpdateUpload(updatedUser);
      } catch (e) {
        fail('Unexpected exception: $e');
      }

      // Verify the read and write calls with the correct method and parameter
      verify(() => mockRxPrefs.read(
          LclRxStgUpdateUploadApi.updateuploadCacheKey,
          UpdateUpload.toUpdateUploadOrEmpty)).called(1);
      verify(() => mockRxPrefs.write<UpdateUpload>(
            LclRxStgUpdateUploadApi.updateuploadCacheKey,
            updatedUser,
            UpdateUpload.updateUploadToString,
          )).called(1);
    });

    test('deleteUpdateUpload should delete existing UpdateUpload object',
        () async {
      const user = UpdateUpload(
          id: 1,
          uploadProgress: 50.0,
          isUploadingData: true,
          backupAnimation: true,
          surveyAnimation: true,
          booksAnimation: true);

      // Update the read call to return an existing user
      when(() => mockRxPrefs.read(LclRxStgUpdateUploadApi.updateuploadCacheKey,
          UpdateUpload.toUpdateUploadOrEmpty)).thenAnswer((_) async => user);

      when(() => mockRxPrefs.remove(any())).thenAnswer((_) async => {});

      try {
        await api.deleteUpdateUpload(user.id!);
      } catch (e) {
        fail('Unexpected exception: $e');
      }

      // Verify the read and remove calls with the correct method and parameter
      verify(() => mockRxPrefs.read(
          LclRxStgUpdateUploadApi.updateuploadCacheKey,
          UpdateUpload.toUpdateUploadOrEmpty)).called(1);
      verify(() =>
              mockRxPrefs.remove(LclRxStgUpdateUploadApi.updateuploadCacheKey))
          .called(1);
    });
    test(
        'deleteUpdateUpload should throw UpdateUploadNotFoundException when ID mismatch occurs',
        () async {
      const user = UpdateUpload(
          id: 1,
          uploadProgress: 50.0,
          isUploadingData: true,
          backupAnimation: true,
          surveyAnimation: true,
          booksAnimation: true);
      const invalidId = 2;

      // Update the read call to return an existing user
      when(() => mockRxPrefs.read(LclRxStgUpdateUploadApi.updateuploadCacheKey,
          UpdateUpload.toUpdateUploadOrEmpty)).thenAnswer((_) async => user);

      when(() => mockRxPrefs.remove(any())).thenAnswer((_) async => {});

      try {
        await api.deleteUpdateUpload(invalidId);
        fail('Expected an UpdateUploadNotFoundException');
      } on UpdateUploadNotFoundException catch (_) {
        // Test passes if UpdateUploadNotFoundException is thrown
      } catch (e) {
        fail('Unexpected exception: $e');
      }

      // Verify the read call with the correct method and parameter
      verify(() => mockRxPrefs.read(
          LclRxStgUpdateUploadApi.updateuploadCacheKey,
          UpdateUpload.toUpdateUploadOrEmpty)).called(1);
    });
    test('getUpdateUpload should return UpdateUpload as stream', () async {
      const user = UpdateUpload(
          id: 1,
          uploadProgress: 50.0,
          isUploadingData: true,
          backupAnimation: true,
          surveyAnimation: true,
          booksAnimation: true);

      // Set up the observe call to return a stream with an existing user
      when(() => mockRxPrefs.observe(
              LclRxStgUpdateUploadApi.updateuploadCacheKey,
              UpdateUpload.toUpdateUploadOrNull))
          .thenAnswer((_) => Stream.value(user));

      // Listen to the stream and expect the user object
      api.getUpdateUpload().listen(expectAsync1((UpdateUpload receivedUser) {
        expect(receivedUser, user);
      }));

      // Verify the observe call with the correct method and parameter
      verify(() => mockRxPrefs.observe(
          LclRxStgUpdateUploadApi.updateuploadCacheKey,
          UpdateUpload.toUpdateUploadOrNull)).called(1);
    });

    test(
        'getUpdateUpload should return updated UpdateUpload after saveUpdateUpload',
        () async {
      const initialUser = UpdateUpload(id: 1, uploadProgress: 50.0);
      const updatedUser = UpdateUpload(id: 1, uploadProgress: 75.0);

      when(() => mockRxPrefs.read(any(), any())).thenAnswer((_) async => null);

      when(() => mockRxPrefs.write<UpdateUpload>(any(), any(), any()))
          .thenAnswer((_) async => {});

      when(() => mockRxPrefs.read(LclRxStgUpdateUploadApi.updateuploadCacheKey,
              UpdateUpload.toUpdateUploadOrEmpty))
          .thenAnswer((_) async => UpdateUpload.empty);

      when(() => mockRxPrefs.observe(
              LclRxStgUpdateUploadApi.updateuploadCacheKey,
              UpdateUpload.toUpdateUploadOrNull))
          .thenAnswer((_) => Stream.value(initialUser));

      // Save the initial user
      await api.saveUpdateUpload(initialUser);

      // Listen to the stream and expect the initial user object
      api.getUpdateUpload().listen(expectAsync1((UpdateUpload receivedUser) {
            expect(receivedUser, initialUser);
          }, count: 1));

      // Save the updated user
      await api.saveUpdateUpload(updatedUser);

      // Update the observe call to return a stream with the updated user
      when(() => mockRxPrefs.observe(
              LclRxStgUpdateUploadApi.updateuploadCacheKey,
              UpdateUpload.toUpdateUploadOrNull))
          .thenAnswer((_) => Stream.value(updatedUser));

      // Listen to the stream again and expect the updated user object
      api.getUpdateUpload().listen(expectAsync1((UpdateUpload receivedUser) {
            expect(receivedUser, updatedUser);
          }, count: 1));
    });

  });
}
