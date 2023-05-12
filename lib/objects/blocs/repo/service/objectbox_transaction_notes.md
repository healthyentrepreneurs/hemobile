# Func runInTransaction 

Future<void> generateDummySurveysWithFaker() async {
const int numOfSurveys = 10;
final faker = Faker();
// Run the loop inside a transaction
_objectService.store.runInTransaction(TxMode.write, () {
for (int i = 0; i < numOfSurveys; i++) {
var namu = SurveyDataModel(
userId: faker.guid.guid(),
surveyVersion: faker.randomGenerator.decimal(min: 1).toString(),
surveyObject:
'{"question1": "${faker.lorem.word()}", "question2": "${faker.lorem.word()}"}',
surveyId: faker.guid.guid(),
isPending: true,
courseId: faker.guid.guid(),
country: faker.address.country(),
);
_objectService.surveyBox
.put(namu); // using put instead of saveSurvey as it's not async
}
});
}
# END Func runInTransaction