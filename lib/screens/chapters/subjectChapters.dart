import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nl_health_app/screens/chapterDetails/chapterDetails.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
class SubjectChapters extends StatefulWidget {
  final String title;

  SubjectChapters(this.title);

  @override
  _SubjectChaptersState createState() => _SubjectChaptersState();
}

class _SubjectChaptersState extends State<SubjectChapters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(widget.title,style: TextStyle(color: ToolsUtilities.whiteColor),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

        iconTheme: IconThemeData(
          color: ToolsUtilities.whiteColor
        ),
      ),
      body: ListView(
        children: [

          Container(
            height: 150,
            child: ListView.builder(
              itemCount: imageUrls.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index) {

                return _adCard(imageUrls[index], "Ads Title With Click");

            }),
          ),
          Padding(
            padding: const EdgeInsets.only(left:18.0,top:8,bottom: 8),
            child: Text('Chapters Of '+ widget.title ,style: TextStyle(color: ToolsUtilities.whiteColor,fontWeight: FontWeight.bold,fontSize: 20),),
          ),

          Container(
              height: MediaQuery.of(context).size.height * 0.80,
              decoration: BoxDecoration(
                color: ToolsUtilities.redColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(50) ),
              ),

              child: ListView.builder(
                  itemCount: imgUtilits.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context,index){

                    return _chapterCard(imgUtilits[index].image);
                  })
          ),
        ],
      ),
    );
  }

  //Create the Ad or Features Things

  Widget _adCard (String imageUrl,String adTitle){

    return InkWell(
      onTap: (){
        print('Add Link of ads');
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.17,
              width: MediaQuery.of(context).size.width * 0.80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),

                image:  DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),

            ),
            Container(
              color: ToolsUtilities.mainBgColor.withOpacity(0.2),
              height: MediaQuery.of(context).size.height * 0.17,
              width: MediaQuery.of(context).size.width * 0.80,

            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0),
              child: Center(

                child: Text(adTitle,
                  style: TextStyle(color: ToolsUtilities.whiteColor,
                    fontSize: 20,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
              ),
            ),

          ],
        ),
      ),
    );
  }




  //Create chapter card
  Widget _chapterCard (String imageUrl){
    return Padding(
      padding: const EdgeInsets.only(right:2.0,left: 12,top:8),
      child: Container(
        decoration: BoxDecoration(
          color: ToolsUtilities.mainBgColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
        ),

        height: 100,
        width: MediaQuery.of(context).size.width ,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container (
                width: MediaQuery.of(context).size.width * 0.4,
                height: 100,
                decoration: BoxDecoration(
                  color: ToolsUtilities.whiteColor,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: ExactAssetImage(imageUrl,scale: 1.0),
                      fit: BoxFit.contain
                  ),
                ),
              ),
            ),
            Text('Chapter Name',
                style: TextStyle(
                    color: ToolsUtilities.mainPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),

            FlatButton.icon(onPressed: (){
              Navigator. push(context, MaterialPageRoute(
                  builder: (context) => ChapterDetails()));
            }, icon:Icon(FontAwesomeIcons.arrowRight,color: ToolsUtilities.mainPrimaryColor,size: 15,), label: Text('')),
          ],
        ),
      ),
    );
  }
}
