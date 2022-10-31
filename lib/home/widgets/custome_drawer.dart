import 'package:cache/cache.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:he/app/app.dart';
import 'package:he/formsapi/formsapi.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/langhe/langhe.dart';

class CustomDrawer extends StatefulWidget {
  final User user;
  const CustomDrawer({Key? key, required this.user}) : super(key: key);

  @override
  _CustomDrawer createState() => _CustomDrawer();
}

class _CustomDrawer extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    // final user = context.select((AppBloc bloc) => bloc.state.user);
    // final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: Container(
        color: ToolUtils.mainPrimaryColor,
        child: Column(
          children: <Widget>[
            ListView(padding: EdgeInsets.zero, shrinkWrap: true, children: [
              DrawerHeader(
                // https://docs.flutter.dev/cookbook/design/drawer
                decoration: BoxDecoration(
                  color: ToolUtils.colorGreenOne,
                ),
                child: Column(
                  children: [
                    Avatar(photo: widget.user.photo),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.user.name ?? '',
                        style: const TextStyle(
                            color: ToolUtils.whiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      },
                      child: ListTile(
                        title: MenuItemHe(
                            title: 'navbar.home'.tr(), icon: Icons.home),
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
                          child: Text('navbar.tools.toolsname'.tr(),
                              style: const TextStyle(
                                  color: ToolUtils.whiteColor,
                                  fontWeight: FontWeight.bold))),
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: ListTile(
                            title: MenuItemHe(
                                title: 'navbar.tools.books'.tr(),
                                icon: Icons.menu_book),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FormList(),
                                ));
                          },
                          child: ListTile(
                            title: MenuItemHe(
                                title: 'navbar.tools.quiz'.tr(),
                                icon: Icons.quiz),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            debugPrint("Surveys");
                          },
                          child: ListTile(
                            title: MenuItemHe(
                                title: 'navbar.tools.surveys'.tr(),
                                icon: Icons.library_books),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: ListTile(
                        title: MenuItemHe(
                            title: 'navbar.offlinesetting'.tr(),
                            icon: Icons.sync),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: ListTile(
                        title: MenuItemHe(
                            title: 'navbar.syncdetails'.tr(),
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
                            title: 'login.languages'.tr(),
                            icon: Icons.translate),
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
            Container(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("Version",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 10)),
                            IconButton(
                              icon: const Icon(
                                Icons.info_rounded,
                                color: ToolUtils.colorBlueOne,
                              ),
                              tooltip: 'Your Application needs Update!',
                              onPressed: () {
                                debugPrint("Mama Jaja ");
                              },
                            ),
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
                    ))),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
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
                      child: Text('logout.title'.tr(),
                          style: const TextStyle(fontSize: 18))),
                  Center(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text('logout.logoutdetails'.tr(),
                              style: const TextStyle(fontSize: 13)))),
                  TextField(
                    key: const Key('re_passwordInput_textField'),
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'login.password'.tr(),
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
              key: const Key('confirm_logout_raisedButton'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
                primary: Theme.of(context).primaryColor,
              ),
              child: Text('logout.confirmlogout'.tr()),
              onPressed: () {
                context.read<AppBloc>().add(AppLogoutRequested());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
