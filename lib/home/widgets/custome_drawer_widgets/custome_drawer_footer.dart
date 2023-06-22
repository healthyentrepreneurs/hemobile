import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/toolutils.dart';

import '../../appupdate/apkseen/apkseen.dart';
import 'custome_d_dialog_logout.dart';
import 'drawer_app_version.dart';

// class DrawerFooter extends StatelessWidget {
//   const DrawerFooter({Key? key,}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final apkSceenState =
//     context.select((ApkseenBloc bloc) => bloc.state.status);
//     final apkUpdateBloc = BlocProvider.of<ApkseenBloc>(context);
//     return Align(
//         alignment: FractionalOffset.bottomCenter,
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 const DrawerAppVersionWidget(),
//                 if (apkSceenState.seen &&
//                     apkSceenState.updated == false) ...[
//                   IconButton(
//                     icon: const Icon(
//                       Icons.info_rounded,
//                       color: ToolUtils.colorBlueOne,
//                     ),
//                     tooltip: 'Your Application needs Update!',
//                     onPressed: () {
//                       apkUpdateBloc.add(DeleteSeenStatusEvent());
//                       debugPrint("Mama Jaja ${apkSceenState.seen} ");
//                     },
//                   )
//                 ],
//                 IconButton(
//                   icon: const Icon(
//                     Icons.logout_sharp,
//                     color: Colors.white,
//                   ),
//                   tooltip: 'Click Here To Logout',
//                   onPressed: () async{
//                     showDialog<void>(
//                       context: context,
//                       // barrierDismissible: false, // user must tap button!
//                       builder: (context) {
//                         return const CusomeLogout();
//                       },
//                     );
//                     // _showMyDialog(context);
//                   },
//                 ),
//               ],
//             )
//             // ListTile(
//             //     leading: Icon(Icons.help), title: Text('Instagram'))
//           ],
//         ));
//   }
// }