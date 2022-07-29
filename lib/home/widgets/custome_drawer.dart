import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:he/app/app.dart';
import 'package:he/formsapi/formsapi.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/langhe/langhe.dart';
import 'package:he/home/widgets/menuItem.dart' as items;

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawer createState() => _CustomDrawer();
}

class _CustomDrawer extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    // final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: Container(
        color: ToolUtils.mainPrimaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Avatar(photo: user.photo),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(user.name ?? '',
                      style: const TextStyle(
                          color: ToolUtils.whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: ListTile(
                title:
                    items.MenuItem(title: 'navbar.home'.tr(), icon: Icons.home),
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
                    title: items.MenuItem(
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
                    title: items.MenuItem(
                        title: 'navbar.tools.quiz'.tr(), icon: Icons.quiz),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: ListTile(
                    title: items.MenuItem(
                        title: 'navbar.tools.surveys'.tr(),
                        icon: Icons.library_books),
                  ),
                )
              ],
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: items.MenuItem(
                    title: 'navbar.offlinesetting'.tr(), icon: Icons.sync),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: items.MenuItem(
                    title: 'navbar.syncdetails'.tr(),
                    icon: Icons.cloud_upload_rounded),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const LangsPage(),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: ListTile(
                title: items.MenuItem(
                    title: 'login.languages'.tr(), icon: Icons.arrow_drop_down),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.white70,
              thickness: 2,
              height: 1,
            ),
            InkWell(
              onTap: () {
                // _PasswordLogout(context: context)._showMyDialog();
                _showMyDialog();
              },
              child: ListTile(
                title: items.MenuItem(
                    title: 'navbar.logout'.tr(), icon: Icons.exit_to_app),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
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
