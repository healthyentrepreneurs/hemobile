home: MultiBlocProvider(
providers: [
BlocProvider(create: (BuildContext context) => DatabaseBloc()),
BlocProvider(create: (BuildContext context) => SectionBloc()),
BlocProvider(create: (BuildContext context) => SurveyBloc()),
BlocProvider(create: (BuildContext context) => HenetworkBloc()),
],
child: FlowBuilder<Tuple4<HeAuthStatus, DatabaseState, SectionState, SurveyState>>(
state: Tuple4(
context.select((AuthenticationBloc bloc) => bloc.state.status),
context.select((DatabaseBloc bloc) => bloc.state),
context.select((SectionBloc bloc) => bloc.state),
context.select((SurveyBloc bloc) => bloc.state),
),
onGeneratePages: onGeneratePages,
),
),

#############

List<Page> onGeneratePages(
Tuple4<HeAuthStatus, DatabaseState, SectionState, SurveyState> tuple, List<Page<dynamic>> pages) {
final authStatus = tuple.item1;
final databaseState = tuple.item2;
final sectionState = tuple.item3;
final surveyState = tuple.item4;

// Add conditions
