import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/chapters/subjectChapters.dart';
import 'package:nl_health_app/screens/utilits/customDrawer.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SubjectsPage extends StatefulWidget {
  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolsUtilities.mainBgColor,
      appBar: AppBar(
        title: Text('Our Subjects',style: TextStyle(color: ToolsUtilities.mainBgColor),),
        centerTitle: true,
        backgroundColor: ToolsUtilities.whiteColor,

        iconTheme: IconThemeData(
            color: ToolsUtilities.mainBgColor
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.only(top:18.0,right: 20,left: 20),
        child: GridView.count(crossAxisCount:2,

          children: [
            _subjectCard('History',  FontAwesomeIcons.landmark,ToolsUtilities.mainBgColor,ToolsUtilities.whiteColor,ToolsUtilities.redColor),
            _subjectCard('Math',  FontAwesomeIcons.notEqual,ToolsUtilities.mainBgColor,ToolsUtilities.whiteColor,ToolsUtilities.redColor),
            _subjectCard('Science',  FontAwesomeIcons.vials,ToolsUtilities.mainBgColor,ToolsUtilities.whiteColor,ToolsUtilities.whiteColor),
            _subjectCard('Language',  FontAwesomeIcons.language,ToolsUtilities.mainBgColor,ToolsUtilities.whiteColor,ToolsUtilities.whiteColor),
            _subjectCard('Computer',  FontAwesomeIcons.laptopCode,ToolsUtilities.mainBgColor,ToolsUtilities.whiteColor,ToolsUtilities.whiteColor),
            _subjectCard('Arts',  FontAwesomeIcons.brush,ToolsUtilities.mainBgColor,ToolsUtilities.whiteColor,ToolsUtilities.whiteColor),
            _subjectCard('Foods',  FontAwesomeIcons.cloudMeatball,ToolsUtilities.mainBgColor,ToolsUtilities.whiteColor,ToolsUtilities.whiteColor),
            _subjectCard('Sport',  FontAwesomeIcons.golfBall,ToolsUtilities.mainBgColor,ToolsUtilities.whiteColor,ToolsUtilities.whiteColor),



        ],),
      ),
      drawer: CustomDrawer(),
    );
  }


  //Create the Subject big Card

  Widget _subjectCard(String title, IconData myIcon, Color myColor,
      Color btnColor, Color contentColor) {
    return Padding(
      padding: const EdgeInsets.only(left:18.0,top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              title,
              style: TextStyle(
                color: ToolsUtilities.whiteColor,fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Stack(
            alignment:Alignment.center ,
            children: <Widget>[
              InkWell(
                onTap: (){
                  Navigator. push(context, MaterialPageRoute(
                      builder: (context) => SubjectChapters(title)));

                },
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: btnColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: myColor,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomLeft: Radius.circular(50)),
                        ),
                        child: Icon(
                          myIcon,
                          color: btnColor,
                          size: 50,

                        ),
                      ),

                    ],
                  ),
                ),
              ),


            ],
          ),

        ],
      ),
    );
  }
}
