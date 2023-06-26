DismissButton | AppVerView
AppUpdatActions





                Object : Apkupdatestatus
We are removing `PackageInfo`

We are merging `ApkupdateRepository` + `ApkRepository`


const ApkupdateRepository({
required ApkUpdateApi apkupdateApi,
}) : _apkupdateApi = apkupdateApi;

final ApkUpdateApi _apkupdateApi;



Apkupdatestatus


JacksonMutebi

apkUpdateBloc.state.status.seen == false &&
dataCloudApk['version'] !=
apkUpdateBloc.state.status.heversion


Apkupdatestatus updateStatus =
const Apkupdatestatus(seen: true, updated: false);
apkUpdateBloc.add(UpdateSeenStatusEvent(status: updateStatus));


ApkseenBloc | ApkseenBloc extends HydratedBloc<ApkseenEvent, ApkseenState>

ApkBloc | class ApkBloc extends Bloc<ApkEvent, ApkState>
