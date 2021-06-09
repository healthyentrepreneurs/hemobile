import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nl_health_app/screens/utilits/customDrawer.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';


class AboutUstPage extends StatefulWidget {
  @override
  _AboutUstPageState createState() => _AboutUstPageState();
}

class _AboutUstPageState extends State<AboutUstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToolsUtilities.mainBgColor,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: ToolsUtilities.whiteColor,
        elevation: 0,
        centerTitle: true,


      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ToolsUtilities.whiteColor,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(90)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: ToolsUtilities.mainBgColor,
                          ),
                          child: FlatButton.icon(onPressed: (){}, icon: Icon(FontAwesomeIcons.laptopCode,color: ToolsUtilities.whiteColor,size: 50,), label: Text('')),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Text('Company Name ',style: TextStyle(color: ToolsUtilities.mainBgColor,fontWeight: FontWeight.bold,fontSize: 20),)
                      ],
                    ),
                  ),



                ],
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: ToolsUtilities.whiteColor,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(90),bottomLeft:Radius.circular(90) ),
                          ),

                          child: Icon(FontAwesomeIcons.info,size: 150,color: ToolsUtilities.mainBgColor,)),

                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("About The App",style: TextStyle(color: ToolsUtilities.whiteColor,fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.justify,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(paragraphContent,style: TextStyle(color: ToolsUtilities.whiteColor,fontSize: 15,),textAlign: TextAlign.justify,),
                      ),


                    ],
                  ),
                ),
              )


            ],
          ),
        ),
      ),
      drawer: CustomDrawer(),
    );
  }

}
