[
if (state.glistOfSubscriptionData.isEmpty) ...[
const StateLoadingHe().noDataFound('You have no Tools')
] else ...[
ListView.builder(
key: Key(henetworkstate.name),
shrinkWrap: true,
padding: const EdgeInsets.only(bottom: 40),
physics: const NeverScrollableScrollPhysics(),
itemCount: state.glistOfSubscriptionData.length,
itemBuilder: (BuildContext context, int index) {
var subscription =
state.glistOfSubscriptionData[index]!;
return UserLanding(
subscription: subscription,
onTap: () {
//Content Form Survey
if (subscription.source == 'originalm') {
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
)
]
]


class RecipeItem extends StatelessWidget {
final String henetworkstatename;
final Subscription subscription;
const RecipeItem(
{Key? key, required this.subscription, required this.henetworkstatename})
: super(key: key);

@override
Widget build(BuildContext context) {
return UserLanding(
key: Key(henetworkstatename),
subscription: subscription,
onTap: () {
if (subscription.source == 'originalm') {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => SurveyPage(course: subscription),
));
} else {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => SectionsPage(course: subscription),
));
}
});
}
}