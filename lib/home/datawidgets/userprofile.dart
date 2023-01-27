import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:he/course/course.dart';
import 'package:he/home/datawidgets/datawidget.dart';
import 'package:he/injection.dart';
import 'package:he/survey/view/back_survey_page.dart';
import 'package:he_api/he_api.dart';

class UserProfile extends StatelessWidget {
  final User user;
  const UserProfile({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final int user_id = user.id!;
    final FirebaseFirestore _firebaseRef = getIt<FirebaseFirestore>();
    var _userItemsQuerySnap = _firebaseRef
        .collection('userdata')
        .where('id', isEqualTo: user_id)
        .withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson());
    //use count or pageSize in FirestoreListView
    return StreamBuilder<QuerySnapshot<User>>(
      stream: _userItemsQuerySnap.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot<User>> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            // width: double.infinity,
            child: InkWell(
              child: CircularProgressIndicator(),
            ),
            // width: 60,
            // height: 60,
          );
        }
        if (snapshot.hasData) {
          User data = snapshot.data!.docs.first.data();
          // User _userItems = snapshot.data();
          if (data.subscriptions == null) {
            return Row(children: const <Widget>[
              Icon(
                Icons.info,
                color: Colors.blue,
                size: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('You have no Tools'),
              )
            ]);
          } else {
            var subscriptionNotnull = data.subscriptions!;
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 40),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subscriptionNotnull.length,
              itemBuilder: (BuildContext context, int index) {
                var subscription = subscriptionNotnull[index]!;
                return UserLanding(
                    title: subscription.fullname,
                    description: subscription.summaryCustome,
                    iconName: subscription.imageUrlSmall,
                    onTap: () {
                      //Content Form Survey
                      if (subscription.source == 'originalm') {
                        // printOnlyDebug("Njovu Surveys Here");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SurveyPage(course: subscription),
                            ));
                      } else {
                        //Course content Books, Quiz Etc
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SectionsPage(course: subscription),
                            ));
                      }
                    });
              },
            );
          }
        } else {
          return Row(
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Stack trace: ${snapshot.stackTrace}'),
              ),
            ],
          );
        }
      },
    );
  }
}
