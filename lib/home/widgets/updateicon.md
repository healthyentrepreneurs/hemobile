the original layout was `<Widget>[
const DrawerAppVersionWidget(),
// _apkUpdateBloc.state.status.updated == false
if (_apkUpdateBloc.state.status.seen == true &&
dataCloudApk['version'] !=
_apkUpdateBloc.state.status.heversion &&
henetworkstate.gstatus ==
HenetworkStatus.wifiNetwork)
IconButton(
icon: const Icon(
Icons.info_rounded,
color: ToolUtils.colorBlueOne,
),
tooltip: 'Your Application needs Update!',
onPressed: () {
_apkUpdateBloc.add(
const UpdateSeenStatusEvent(
status: Apkupdatestatus(
seen: false,
updated: false,
),
),
);
},
)
else
const SizedBox.shrink(),
IconButton(
icon: const Icon(
Icons.logout_sharp,
color: Colors.white,
),
tooltip: 'Click Here To Logout',
onPressed: () {
_showMyDialog(context);
},
),
]`

final appCloudLocal =
context.select((ApkBloc bloc) => bloc.state) as ApkFetchedState;
Map<String, dynamic> dataCloudApk =
appCloudLocal.snapshot.data() as Map<String, dynamic>;