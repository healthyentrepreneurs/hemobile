import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/auth/authentication/bloc/authentication_bloc.dart';
import 'package:he/helper/toolutils.dart';
import 'package:he/home/home.dart';
import 'package:he/objects/blocs/hedata/bloc/database_bloc.dart';

class MainScaffold extends StatelessWidget {
  // final User user;
  final Widget subwidget;
  const MainScaffold({Key? key, required this.subwidget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user)!;
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
        SizedBox(
            width: double.infinity,
            child: InkWell(
              child: ListTile(
                title: const MenuItemHe().iconTextItemGreen(
                    'You have 20 unsent surveys hard coded', Icons.sync),
              ),
            )),
        const MenuItemHe().appTitle('What do you need ?'),
        BlocConsumer<DatabaseBloc, DatabaseState>(
          buildWhen: (previous, current) {
            var networkChange =
                previous.ghenetworkStatus != current.ghenetworkStatus;
            bool dataChange = !listEquals(previous.glistOfSubscriptionData,
                current.glistOfSubscriptionData);
            debugPrint(
                "PreviousNetworkState  List  ${previous.glistOfSubscriptionData.toString()} \n  Net ${previous.ghenetworkStatus} \n error ${previous.error?.message}");
            debugPrint(
                "CurrentNetworkState  List  ${current.glistOfSubscriptionData.toString()} \n Net ${current.ghenetworkStatus} \n error ${current.error?.message}");
            return networkChange || dataChange;
          },
          listenWhen: (previous, current) {
            bool dataChange = previous.glistOfSubscriptionData.isEmpty &&
                current.glistOfSubscriptionData.isNotEmpty;
            debugPrint('dataChangeNjovu $dataChange');
            debugPrint(
                "dataChangeDarth goes  ${previous.glistOfSubscriptionData.toString()}");
            debugPrint(
                "fuckChangeDarth goes  ${current.glistOfSubscriptionData.toString()}");
            bool errorChange = previous.error != current.error;
            debugPrint('errorChangeNjovu $errorChange');
            debugPrint("Errordata goes  ${previous.error?.message}");
            debugPrint("Errorfuck goes  ${current.error?.message}");
            return dataChange || errorChange;
            // return previous.glistOfSubscriptionData.isEmpty &&
            //     current.glistOfSubscriptionData.isNotEmpty;
          },
          listener: (context, state) {
            if (state.error != null) {
              debugPrint(
                  "SubA  goes @Nyege Nyege ${state.glistOfSubscriptionData.toString()}");
              debugPrint("ANJOVU ${state.error?.message}");
              BlocProvider.of<DatabaseBloc>(context).add(DatabaseFetchedError(
                  state.ghenetworkStatus, state.error,
                  clearData: true));
            } else {
              debugPrint(
                  "SubB  goes @Nyege Nyege ${state.glistOfSubscriptionData.toString()}");
              debugPrint("ERORRHERE ${state.error?.message}");
              BlocProvider.of<DatabaseBloc>(context)
                  .add(const DatabaseDeFetchedError());
            }
          },
          builder: (context, state) {
            return Center(child: subwidget);
          },
        )
      ]),
    );
  }
}
