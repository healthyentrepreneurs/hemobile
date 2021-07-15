import 'package:flutter/material.dart';
import 'package:nl_health_app/screens/homePage/homePage.dart';
import 'package:nl_health_app/screens/utilits/modelUtilits.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';

List<ModelUtilities> dataUtilits = [
  ModelUtilities(
      'Let`s Start First Mathematical Class', 'assets/images/placeHolder.png'),
  ModelUtilities(
      'High quality Video and Content', 'assets/images/placeHolder.png'),
  ModelUtilities(
      'Fast Way to understand the Material', 'assets/images/placeHolder.png'),
];

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  bool _reachatend = false;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(
      initialPage: 0,
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: dataUtilits.length,
              controller: _pageController,
              onPageChanged: (index) {
                if (index == (dataUtilits.length - 1)) {
                  setState(() {
                    _reachatend = true;
                    currentIndex = index;
                  });
                } else {
                  setState(() {
                    _reachatend = false;
                    currentIndex = index;
                  });
                }
              },
              itemBuilder: (context, index) {
                return Scaffold(
                  backgroundColor: ToolsUtilities.mainBgColor,
                  appBar: AppBar(
                    actions: <Widget>[
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.transparent,
                        elevation: 0,
                        child: _reachatend
                            ? InkWell(
                                onTap: () {
                                  print(_reachatend);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Homepage()));
                                },
                                child: Text(
                                  'Start',
                                  style: TextStyle(
                                      color: ToolsUtilities.greenColor,
                                      fontSize: 18),
                                ))
                            : InkWell(
                                onTap: () {
                                  //print(_reachatend);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Homepage()));
                                },
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                      color: ToolsUtilities.whiteColor,
                                      fontSize: 18),
                                )),
                      ),
                    ],
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _customImgBg(index, ToolsUtilities.whiteColor),
                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              dataUtilits[index].title,
                              style: TextStyle(
                                color: ToolsUtilities.whiteColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        Container(
          color: ToolsUtilities.mainBgColor,
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _drawDots(dataUtilits.length),
          ),
        ),
      ],
    );
  }

  //Create image with Different Bg Color
  Widget _customImgBg(int index, Color color) {
    return Container(
      width: 600,
      height: 350,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        image: DecorationImage(
            image: ExactAssetImage(dataUtilits[index].image),
            fit: BoxFit.contain),
      ),
    );
  }

//Create list of draw Dots
  List<Widget> _drawDots(int quantity) {
    List<Widget> widgets = [];
    for (int index = 0; index < quantity; index++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (index == currentIndex)
                  ? ToolsUtilities.greenColor
                  : ToolsUtilities.whiteColor,
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}
