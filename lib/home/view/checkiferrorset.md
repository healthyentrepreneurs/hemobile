class HomePage extends StatelessWidget {
const HomePage._();
const HomePage({Key? key}) : super(key: key);
static Page<void> page() => const MaterialPage<void>(child: HomePage._());
static Route<void> route() {
return MaterialPageRoute(builder: (_) => const HomePage._());
}

@override
Widget build(BuildContext context) {
final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
return BlocConsumer<HenetworkBloc, HenetworkState>(
listenWhen: (previous, current) {
return previous.gstatus != current.gstatus;
},
listener: (context, state) {
if (state.gstatus != HenetworkStatus.loading) {
BlocProvider.of<DatabaseBloc>(context)
.add(DatabaseLoadEvent());
}
},
buildWhen: (previous, current) {
var networkChange =
previous.gconnectivityResult != current.gconnectivityResult ||
previous.gstatus != current.gstatus;
if (networkChange) {
BlocProvider.of<DatabaseBloc>(context)
.add(DatabaseFetched(user.id.toString(), current.gstatus));
debugPrint("NetworkState Ends @B");
}
return networkChange;
},
builder: (context, state) {
if (state.gconnectivityResult == ConnectivityResult.none) {
debugPrint("NetworkState Start @ A");
final networkBloc = BlocProvider.of<HenetworkBloc>(context);
networkBloc.add(const HeNetworkNetworkStatus());
}
return BlocConsumer<DatabaseBloc, DatabaseState>(
listenWhen: (previous, current) {
return previous.error != current.error ||
previous.ghenetworkStatus != current.ghenetworkStatus;
},
listener: (context, state) {
if (state.error == null && state.ghenetworkStatus == HenetworkStatus.loaded) {
debugPrint('Error is set to null when _fetchUserData loads successfully');
}
},
buildWhen: (previous, current) =>
previous.ghenetworkStatus != current.ghenetworkStatus,
builder: (context, state) {
// ...
