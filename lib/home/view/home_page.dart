import 'package:flutter/material.dart';
import 'package:he/app/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/home.dart';
import 'package:he/home/widgets/menuItem.dart' as items;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
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
      endDrawer: const CustomDrawer(),
      body: ListView(children: [
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            "Hi${user.name == null ? '' : ', ' + user.name!}!",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
            width: double.infinity,
            child: InkWell(
              child: ListTile(
                title: const items.MenuItem().iconTextItemGreen(
                    'You have 20 unsent surveys', Icons.sync),
              ),
            )),
        const items.MenuItem().appTitle('What do you need ?'),
        const Center(child: UserProfile())
      ]),
    );
  }
}
