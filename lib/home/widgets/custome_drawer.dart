import 'package:flutter/material.dart';
import 'package:he/asyncfiles/asyncfiles.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/home/appupdate/apkseen/bloc/apkseen_bloc.dart';
import 'package:he/home/home.dart';
import 'package:he/langhe/langhe.dart';
import 'package:he/objects/blocs/apkupdate/bloc/apk_bloc.dart';
import 'package:he/objects/blocs/repo/fofiperm_repo.dart';
import 'package:he_api/he_api.dart';
import 'package:theme_locale_repo/generated/l10n.dart';

import '../../objects/blocs/henetwork/bloc/henetwork_bloc.dart';

class CustomDrawer extends StatefulWidget {
  final User user;
  const CustomDrawer({Key? key, required this.user}) : super(key: key);

  @override
  _CustomDrawer createState() => _CustomDrawer();
}

class _CustomDrawer extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final henetworkstate = context.select((HenetworkBloc bloc) => bloc.state);
    final FoFiRepository _fofi = FoFiRepository();
    final appCloudLocal =
        context.select((ApkBloc bloc) => bloc.state) as ApkFetchedState;
    Map<String, dynamic> dataCloudApk =
        appCloudLocal.snapshot.data() as Map<String, dynamic>;
    debugPrint("CheckInternet ${henetworkstate.gstatus}");
    final _apkUpdateBloc = context.watch<ApkseenBloc>();
    final s = S.of(context);
    return Drawer(
      child: Container(
        color: ToolUtils.mainPrimaryColor,
        child: Column(
          children: <Widget>[
            ListView(
                key: Key(henetworkstate.status.name),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  DrawerHeader(
                    // https://docs.flutter.dev/cookbook/design/drawer
                    decoration: const BoxDecoration(
                      color: ToolUtils.colorGreenOne,
                    ),
                    child: Column(
                      children: [
                        if (henetworkstate.gstatus ==
                            HenetworkStatus.wifiNetwork)
                          Avatar(photo: widget.user.profileimageurlsmall),
                        if (henetworkstate.gstatus ==
                            HenetworkStatus.noInternet)
                          heIconOffline(
                              "/images/${widget.user.id}big_loginimage.png",
                              _fofi,
                              width: 50,
                              height: 50,
                              radius: 29.0),
                        const SizedBox(height: 10),
                        Text(
                          widget.user.fullName ?? '',
                          style: const TextStyle(
                            color: ToolUtils.whiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
            Expanded(
              child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const HomePage()));
                        await Navigator.of(context).push(HomePage.route());
                      },
                      child: ListTile(
                        title:
                            MenuItemHe(title: s.navbar_home, icon: Icons.home),
                      ),
                    ),
                    ExpansionTile(
                      trailing: const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: ToolUtils.whiteColor,
                        size: 21,
                      ),
                      title: Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(s.navbar_tools_toolsname,
                              style: const TextStyle(
                                  color: ToolUtils.whiteColor,
                                  fontWeight: FontWeight.bold))),
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: ListTile(
                            title: MenuItemHe(
                                title: s.navbar_tools_books,
                                icon: Icons.menu_book),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: ListTile(
                            title: MenuItemHe(
                                title: s.navbar_tools_quiz, icon: Icons.quiz),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            debugPrint("Surveys");
                          },
                          child: ListTile(
                            title: MenuItemHe(
                                title: s.navbar_tools_surveys,
                                icon: Icons.library_books),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: ListTile(
                        title: MenuItemHe(
                            title: s.navbar_offlinesetting, icon: Icons.sync),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(BackupPage.route());
                      },
                      child: ListTile(
                        title: MenuItemHe(
                            title: s.navbar_syncdetails,
                            icon: Icons.cloud_upload_rounded),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const LangsPage(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: ListTile(
                        title: MenuItemHe(
                            title: s.login_languages, icon: Icons.translate),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.white70,
                      thickness: 2,
                      height: 1,
                    )
                  ]),
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const DrawerAppVersionWidget(),
                        // _apkUpdateBloc.state.status.updated == false
                        if (_apkUpdateBloc.state.status.seen == true &&
                            dataCloudApk['version'] !=
                                _apkUpdateBloc.state.status.heversion)
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
                      ],
                    )
                    // ListTile(
                    //     leading: Icon(Icons.help), title: Text('Instagram'))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    final s = S.of(context);
    final apkUpdateBloc = BlocProvider.of<ApkseenBloc>(context);
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          // insetPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(2.0),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.info_outline,
                    color: Colors.blueAccent,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: Text(s.logout_title,
                          style: const TextStyle(fontSize: 18))),
                  Center(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(s.logout_logoutdetails,
                              style: const TextStyle(fontSize: 13)))),
                  TextField(
                    key: const Key('re_passwordInput_textField'),
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: s.login_password,
                        // errorText: 'invalid password',
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)))),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              key: const Key('confirm_logout_raisedbutton'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
                primary: Theme.of(context).primaryColor,
              ),
              child: Text(s.logout_confirmlogout),
              onPressed: () {
                // Apkupdatestatus updateStatus =
                // const Apkupdatestatus(
                //     seen: false, updated: false);
                // apkUpdateBloc.add(
                //     UpdateSeenStatusEvent(status: updateStatus));
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
