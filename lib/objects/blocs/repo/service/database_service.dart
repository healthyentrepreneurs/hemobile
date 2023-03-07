import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:he/objects/blocs/repo/impl/repo_failure.dart';
import 'package:he_api/he_api.dart';

class DatabaseService {
  // late final FirebaseFirestore _db;
  final FirebaseFirestore _firestore;

  DatabaseService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  addUserData(Subscription userData) async {
    await _firestore
        .collection("Users")
        .doc(userData.fullname)
        .set(userData.toJson());
  }

  Future<Either<Failure, List<Subscription?>>> retrieveSubscriptionData(
      int user_id) async {
    // var _userItemsQuerySnap = _firebaseRef
    //     .collection('userdata')
    //     .where('id', isEqualTo: user_id)
    //     .withConverter<User>(
    //     fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
    //     toFirestore: (user, _) => user.toJson());
    try {
      var documentReferenceUser = _firestore
          .collection("userdata")
          .doc('3')
          .withConverter<User>(
              fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
              toFirestore: (user, _) => user.toJson());

      var documentSnapshotUser = await documentReferenceUser
          .get()
          .catchError((err) => debugPrint("NjovuError ${err.message}"));
      var objectUser = documentSnapshotUser.data();
      if (objectUser!.subscriptions == null) {
        return const Right([]);
        // return [];
      }
      return Right(objectUser.subscriptions!);
      // return objectUser.subscriptions!;
    } on Exception catch (e) {
      return Future.value(Left(RepositoryFailure(e.toString())));
    }
  }

  Stream<Either<Failure, List<Subscription?>>> retrieveSubscriptionDataStream(
      String userId) {
    try {
      return _firestore
          .collection("userdata")
          .doc(userId)
          .withConverter<User>(
              fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
              toFirestore: (user, _) => user.toJson())
          .snapshots()
          .map((event) {
        if (event.data() == null) {
          debugPrint('retrieveSubscriptionDataStream Data Loaded A');
          return Left(RepositoryFailure('Subscription Data is A'));
        } else if (event.data()!.subscriptions == null) {
          debugPrint('retrieveSubscriptionDataStream Data Loaded B');
          return Left(RepositoryFailure('No Subscription Data'));
        } else {
          debugPrint('retrieveSubscriptionDataStream Data Loaded C');
          return Right(event.data()!.subscriptions!);
        }
      });
    } on Exception catch (e) {
      debugPrint("We Have Errors Here");
      return Stream.value(Left(RepositoryFailure(e.toString())));
    }
  }

  Stream<Either<Failure, String>> retrieveSurveyStream(String courseId) {
    try {
      return _firestore
          .collection("surveys")
          .doc(courseId)
          .withConverter<Survey>(
              fromFirestore: (snapshot, _) => Survey.fromJson(snapshot.data()!),
              toFirestore: (survey, _) => survey.toJson())
          .snapshots()
          .map((event) {
        if (event.data() == null) {
          debugPrint('retrieveSurveyStream Data Loaded A');
          return Left(RepositoryFailure('No Surveys Data'));
        } else if (event.data()?.surveyjson == null) {
          debugPrint('retrieveSurveyStream Data Loaded B');
          return Left(RepositoryFailure('No Surveys Data'));
        } else {
          debugPrint('retrieveSurveyStream Data Loaded C');
          return Right(event.data()!.surveyjson);
        }
      });
    } on Exception catch (e) {
      debugPrint("retrieveSurveyStream@We Have Errors Here");
      return Stream.value(Left(RepositoryFailure(e.toString())));
    }
  }

  Future<String> retrieveUserName(Subscription user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("Users").doc(user.fullname).get();
    return snapshot.data()!["displayName"];
  }

  Stream<Either<Failure, List<Section?>>> retrieveBookSection(String courseId) {
    try {
      var coursePath = 'source_one_course_$courseId';
      return _firestore
          .collection(coursePath)
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  Section.fromJson(snapshot.data()!),
              toFirestore: (section, _) => section.toJson())
          .snapshots()
          .map((event) {
        if (event.docs.isEmpty) {
          debugPrint('retrieveBookSection Data Loaded A');
          return Left(RepositoryFailure('No Course Section Found'));
        } else {
          debugPrint('retrieveBookSection Data Loaded C');
          return Right(event.docs.map((e) => e.data()).toList());
        }
      });
    } on Exception catch (e) {
      debugPrint("retrieveBookSection We Have Errors Here");
      return Stream.value(Left(RepositoryFailure(e.toString())));
    }
  }
}
