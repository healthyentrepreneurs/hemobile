// import 'package:flutter/material.dart';
//
// void main() => runApp(MaterialApp(
//   title: "Tutorial",
//   home: Home(),
// ));
//
// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//
//   List<ListItem> _dropdownItems = [
//     ListItem(1, "First Value"),
//     ListItem(2, "Second Item"),
//     ListItem(3, "Third Item"),
//     ListItem(4, "Fourth Item")
//   ];
//
//   List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
//   ListItem _selectedItem;
//
//   void initState() {
//     super.initState();
//     _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
//     _selectedItem = _dropdownMenuItems[0].value;
//
//   }
//
//   List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
//     List<DropdownMenuItem<ListItem>> items = List();
//     for (ListItem listItem in listItems) {
//       items.add(
//         DropdownMenuItem(
//           child: Text(listItem.name),
//           value: listItem,
//         ),
//       );
//     }
//     return items;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Dropdown Button"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               color: Colors.cyan,
//               border: Border.all()),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton(
//                 value: _selectedItem,
//                 items: _dropdownMenuItems,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedItem = value;
//                   });
//                 }),
//           ),
//         ),
//       ),
//     );
//   }
//   DropdownButton<String>(
//   focusColor:Colors.white,
//   value: _chosenValue,
//   //elevation: 5,
//   style: TextStyle(color: Colors.white),
//   iconEnabledColor:Colors.black,
//   items: <String>[
//   'Android',
//   'IOS',
//   'Flutter',
//   'Node',
//   'Java',
//   'Python',
//   'PHP',
//   ].map<DropdownMenuItem<String>>((String value) {
//   return DropdownMenuItem<String>(
//   value: value,
//   child: Text(value,style:TextStyle(color:Colors.black),),
//   );
//   }).toList(),
//   hint:Text(
//   "Please choose a langauage",
//   style: TextStyle(
//   color: Colors.black,
//   fontSize: 14,
//   fontWeight: FontWeight.w500),
//   ),
//   onChanged: (String value) {
//   setState(() {
//   _chosenValue = value;
//   });
//   },
//   ),
// }