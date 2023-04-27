import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/home.dart';

class MainScaffold extends StatelessWidget {
  final Widget subwidget;
  const MainScaffold({Key? key, required this.subwidget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return Scaffold(
      backgroundColor: ToolUtils.whiteColor,
      appBar: AppBar(
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 143.0),
            child: Image.asset(
              'assets/images/logo.png',
              height: 35.0,
              // alignment: Alignment.center,
            ),
          ),
          backgroundColor: ToolUtils.whiteColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: ToolUtils.mainPrimaryColor)),
      endDrawer: CustomDrawer(
        user: user,
      ),
      body: ListView(children: [
        const SizedBox(height: 10.0),
        BannerUpdate(
          userId: user.id.toString(),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            "Hi${user.firstname == null ? '' : ', ${user.firstname!}'}!",
            style: const TextStyle(
                // colorBlueOne, redColor
                color: ToolUtils.colorBlueOne,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        const UnsentSurveysWidget(),
        const MenuItemHe().appTitle('What do you need ?'),
        Center(child: subwidget)
      ]),
    );
  }
}
