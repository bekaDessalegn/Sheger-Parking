// ignore: file_names
// ignore_for_file: file_names

import 'package:ehet_alem/pages/BranchesPage.dart';
import 'package:ehet_alem/pages/EditReservation.dart';
import 'package:ehet_alem/pages/ProfilePage.dart';
import 'package:ehet_alem/pages/ReservationDetailsPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ReservationPage.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Col.background,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        leading: IconButton(
          color: Col.Onbackground,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
        ),
        actions: [IconButton(
          color: Col.Onbackground,
            padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
            iconSize: 40,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            icon: Icon(Icons.account_circle_sharp)),
        ],
        title: Text(Strings.app_title,
          style: TextStyle(
            color: Col.Onsurface,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
            letterSpacing: 0.3,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  colors: [Col.secondary,Col.secondary],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter
              ),
          ),
        ),
      ),
      body:Stack(
        fit: StackFit.expand,
        children: <Widget>[Container(
          color: Col.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
          child:Padding(padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
                child: Text("Reservations",
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              ),
              Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Container(
                  width: 300,
                   height: 420,
                   color: Col.surface,
                  child: Column(
                    children: <Widget>[
                      InkWell(child: Container(
                        child:
                        Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text("Title",
                              style: TextStyle(
                                color: Col.Onbackground,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.96, -1.35),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditReservation(plateNumber: '253654')));
                                },
                                icon: Icon(Icons.edit),
                            ),
                          ),
                          Align(
                            alignment: Alignment(-0.9,0.3),
                            child: Text("Description",
                              style: TextStyle(
                                color: Col.Onbackground,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                        ),
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: EdgeInsets.fromLTRB(12, 5, 0, 0),
                        height: 100,
                        width: 280,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationDetailsPage()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ),
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                    child:RaisedButton(
                      color: Col.primary,
                      child: Text("Explore\nBranches",
                        style: TextStyle(
                          color: Col.Onprimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BranchesPage()));
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                    child:RaisedButton(
                      color: Col.primary,
                      child: Text("Reserve a\nspot",
                        style: TextStyle(
                          color: Col.Onprimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationPage()));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
