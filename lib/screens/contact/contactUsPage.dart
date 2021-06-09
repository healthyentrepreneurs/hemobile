import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/utilits/customDrawer.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  //The controls of Text Editing
  TextEditingController nameTextControl = TextEditingController();
  TextEditingController phoneTextControl= TextEditingController();
  TextEditingController messageTitleTextControl= TextEditingController();
  TextEditingController contentTextControl= TextEditingController();

  @override
  void dispose() {
    nameTextControl.dispose();
    phoneTextControl.dispose();
    messageTitleTextControl.dispose();
    contentTextControl.dispose();
    super.dispose();
  }
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

                        Text('Contact Us Now ',style: TextStyle(color: ToolsUtilities.mainBgColor,fontWeight: FontWeight.bold,fontSize: 20),)
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

                          child: Icon(FontAwesomeIcons.phone,size: 150,color: ToolsUtilities.mainBgColor,)),

                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Send Email Form Now",style: TextStyle(color: ToolsUtilities.whiteColor,fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.justify,),
                      ),

                      _contactUSCard(),

                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Social Media",style: TextStyle(color: ToolsUtilities.whiteColor,fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.justify,),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Icon(FontAwesomeIcons.facebook,size: 30,color: ToolsUtilities.whiteColor,),
                          Icon(FontAwesomeIcons.twitter,size: 30,color: ToolsUtilities.whiteColor,),
                          Icon(FontAwesomeIcons.snapchat,size: 30,color: ToolsUtilities.whiteColor,),
                          Icon(FontAwesomeIcons.instagram,size: 30,color: ToolsUtilities.whiteColor,),
                          Icon(FontAwesomeIcons.youtube,size: 30,color: ToolsUtilities.whiteColor,),
                          Icon(FontAwesomeIcons.pinterest,size: 30,color: ToolsUtilities.whiteColor,),


                ],
                        ),
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



  Widget _contactUSCard(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        customTextField('Enter Your Name',nameTextControl,1),
        customTextField('Enter Your Phone Number',phoneTextControl,1),
        customTextField('Enter Your Message Title',messageTitleTextControl,1),
        customTextField('Enter Your Message Content',contentTextControl,4),

        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            alignment: Alignment.bottomRight,
            width: MediaQuery.of(context).size.width * 0.65,
            child: RaisedButton(onPressed: (){},
              color: ToolsUtilities.redColor,
              elevation: 5,
              child: FlatButton.icon(onPressed: (){
                //Call Us via email
              }, icon: Icon(Icons.email,color: ToolsUtilities.whiteColor,), label: Text('Send Via Email',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: ToolsUtilities.whiteColor),)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),


            ),
          ),
        ),

      ],
    );
  }


  Widget customTextField(String hitName,TextEditingController textEditingControl,int maxLine){
    return Padding(
      padding: const EdgeInsets.only(right:30,left: 30,top: 8),
      child: Container(
          child: TextField(
            maxLines: maxLine,
            controller:textEditingControl,
            decoration: InputDecoration(
              hoverColor: ToolsUtilities.whiteColor,
              focusColor: ToolsUtilities.whiteColor,
              focusedBorder:OutlineInputBorder(
                borderSide: BorderSide(
                    color: ToolsUtilities.whiteColor
                ),

              ),
              labelText: hitName,labelStyle: TextStyle(color: ToolsUtilities.whiteColor),
            ),
          )),
    );
  }

}
