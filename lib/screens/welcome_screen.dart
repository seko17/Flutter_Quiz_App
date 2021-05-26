import 'dart:io';

import 'package:flutter/material.dart';
import 'package:param_quiz_app/screens/category_screen.dart';
import 'package:param_quiz_app/screens/score_board.dart';

import 'package:param_quiz_app/styles/styles.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_icons/flutter_icons.dart';

class WelcomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:  Color(0xFF142850),
      body: Stack(children: [
          Container(
                    height: 400,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: -40,
                          height: 400,
                          width: width,
                          child: 
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                        AssetImage('assets/images/background.png'),
                                        fit: BoxFit.fill)),
                              )),
                        Positioned(
                          height: 400,
                          width: width + 20,
                          child: 
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/background-2.png'),
                                        fit: BoxFit.fill)),
                              ),
                        )
                      ],
                    ),
                  ),
         SafeArea(
           child: Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 60.0,bottom:20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Image.asset('assets/images/bulb.png'),
                   SizedBox(height:30),
                    Text(
                    "Flutter Quiz App",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30),
                  ),
                  SizedBox(height:10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: [
                        Text(
                    "Learn",
                    style: TextStyle(color: Colors.white,fontSize: 10),
                  ),
                  SizedBox(width:5),
                       Text(
                    "*",
                    style: TextStyle(color: Colors.white,fontSize: 15),
                  ),
                  SizedBox(width:5),
                       Text(
                    "Take Quiz",
                    style: TextStyle(color: Colors.white,fontSize: 10),
                  ),
                  SizedBox(width:5),
                       Text(
                    "*",
                    style: TextStyle(color: Colors.white,fontSize: 15),
                  ),
                  SizedBox(width:5),
                       Text(
                    "Repeat",
                    style: TextStyle(color: Colors.white,fontSize: 10),
                  ),
                    ],
                  ),
                  Spacer(flex:2),
                      InkWell(
                    onTap: ()async{ Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoryScreen()),
                    );},
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20.0 * 0.75), // 15
                      decoration: BoxDecoration(
                        gradient: buttonGradient,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Text(
                        "PLAY",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                          InkWell(
                       onTap: ()async{ Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScoreBoard()),
                    );},
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10,),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20.0 * 0.75), // 15
                      decoration: BoxDecoration(
                        gradient: buttonGradient,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Text(
                        "SCOREBOARD",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),       InkWell(
                    onTap: (){
                      _showDialog(context);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10,),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20.0 * 0.75), // 15
                      decoration: BoxDecoration(
                        gradient: ExitGradient,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Text(
                        "EXIT",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Spacer(flex: 2), // it will take 2/6 spaces
                  ],
              ),
           ),
         )
      ],),
      
    );
  // ignore: dead_code

  }
 
}
 void _showDialog(BuildContext context){
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Material(
            color: Colors.transparent,
            elevation: 15.0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(30.0), topRight: Radius.circular(30.0), bottomRight: Radius.circular(10.0)),
              child: Container(
                height: 35.0,
                width: 50.0,
                color: Color(0xff9447ec),
                child: Align(alignment: Alignment.center, child: Text("Notice", style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ), ),),
              ),
            ),
          ),
          content: new Text("Are you sure you want to exit the app?"),
          actions: <Widget>[
            Material(
              color: Colors.transparent,
              elevation: 15.0,
              // ignore: deprecated_member_use
              child: FlatButton(
                color: kRedColor,
                child: Text("YES",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: kRedColor,),
                ),
              ),
            ),
             Material(
              color: Colors.transparent,
              elevation: 15.0,
              // ignore: deprecated_member_use
              child: FlatButton(
                color: kGreenColor,
                child: Text("NO",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => exit(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: kGreenColor,),
                ),
              ),
            ),
            // usually buttons at the bottom of the dialog
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: kRedColor,),
          ),
        );
      },
    );
  }