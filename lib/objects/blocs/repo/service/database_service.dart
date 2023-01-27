import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:he_api/he_api.dart';

class DatabaseService {
  // late final FirebaseFirestore _db;
  final FirebaseFirestore _firestore;
  DatabaseService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  addUserData(Subscription userData) async {
    await _firestore
        .collection("Users")
        .doc(userData.fullname)
        .set(userData.toJson());
  }

  Future<List<Subscription?>> retrieveSubscriptionData(int user_id) async {
    var documentReferenceUser = _firestore
        .collection("userdata")
        .doc('3')
        .withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson());

    var documentSnapshotUser = await documentReferenceUser.get();
    var objectUser = documentSnapshotUser.data();
    if (objectUser!.subscriptions == null) {
      return [];
    }
    //make sure to return a list of subscriptions
    return objectUser.subscriptions!;
  }

  Future<String> retrieveUserName(Subscription user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("Users").doc(user.fullname).get();
    return snapshot.data()!["displayName"];
  }
}
