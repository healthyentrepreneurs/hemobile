import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:he/course/course.dart';
import 'package:he/objects/objectsubscription.dart';
import 'package:he/objects/objectuser.dart';
import 'package:he/survey/view/view.dart';
import 'package:he_api/he_api.dart';
import 'userlanding.dart';

class UserProfile extends StatefulWidget {
  final User user;
  const UserProfile({Key? key, required this.user}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot>? _userStream =
        FirebaseFirestore.instance.collection('userdata').doc('3').snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
          ObjectUser data = ObjectUser.fromJson(
              snapshot.data!.data() as Map<String, dynamic>);
          if (data.subscriptions.isEmpty) {
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
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 40),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.subscriptions.length,
              itemBuilder: (BuildContext context, int index) {
                var subscription = data.subscriptions[index];
                return UserLanding(
                    title: subscription.fullname,
                    description: subscription.summaryCustome,
                    iconName: subscription.imageUrlSmall,
                    onTap: () {
                      //Content Form Survey
                      ObjectSubscription c = ObjectSubscription(
                          id: subscription.id,
                          fullname: subscription.fullname!,
                          source: subscription.source!,
                          summaryCustome: subscription.summaryCustome!,
                          nextLink: subscription.nextLink!,
                          imageUrlSmall: subscription.imageUrlSmall!,
                          imageUrl: subscription.imageUrl!);
                      if (subscription.source == 'originalm') {
                        // printOnlyDebug("Njovu Surveys Here");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurveyPage(course: c),
                            ));
                      } else {
                        //Course content Books, Quiz Etc
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SectionsPage(course: c),
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
