// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'package:sheger_parking/pages/EditProfile.dart';
import 'package:sheger_parking/pages/EditReservation.dart';
import 'package:sheger_parking/pages/StartUpPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:expandable/expandable.dart';

import 'ProfilePage.dart';

class BranchesPage extends StatefulWidget {
  @override
  _BranchesPageState createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  final branches = [
    'Branch 1',
    'Branch 2',
    'Branch 3',
    'Branch 4',
    'Branch 5',
    'Branch 6'
  ];

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
        actions: [
          IconButton(
              color: Col.Onbackground,
              padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
              iconSize: 40,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              icon: Icon(Icons.account_circle_sharp)),
        ],
        title: Text(
          Strings.app_title,
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
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
                colors: [Col.secondary, Col.secondary],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
              child: Text(
                "Branches",
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
          Expanded(
            child: ListView.builder(
                itemCount: branches.length,
                itemBuilder: (context, index) {
                  dynamic branch = branches[index];
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Card(
                      color: Colors.grey[100],
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 8, 0, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: [
                                Align(
                                  child: IconButton(
                                    onPressed: () {
                                      print("Teleyaleh");
                                    },
                                    icon: Icon(
                                      Icons.location_on,
                                    ),
                                    iconSize: 25,
                                  ),
                                  alignment: Alignment.topRight,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Text(
                                    "$branch",
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
                            Text(
                              "Description 1",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              "Description 2",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  // Widget buildCard(String branchName) => Padding(
  //   padding: EdgeInsets.all(10),
  //   child: Card(
  //     child: ExpandablePanel(
  //       header:Padding(padding: EdgeInsets.fromLTRB(10, 3, 0, 8),
  //         child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Row(
  //             children: [
  //               Text(
  //                 branchName,
  //                 style: TextStyle(
  //                   color: Col.Onbackground,
  //                   fontSize: 26,
  //                   fontWeight: FontWeight.bold,
  //                   fontFamily: 'Nunito',
  //                   letterSpacing: 0.1,
  //                 ),
  //               ),
  //               IconButton(onPressed: (){},
  //                 icon: Icon(Icons.location_on),
  //                 color: Colors.blue,
  //                 iconSize: 30,
  //               padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),
  //             ],
  //           ),
  //           Text("Branch 5",
  //             style: TextStyle(
  //               color: Col.Onbackground,
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //               fontFamily: 'Nunito',
  //               letterSpacing: 0.1,
  //             ),
  //           ),
  //         ],
  //       ),
  //       ),
  //       collapsed: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //         child: Row(
  //         children: <Widget>[
  //           Text("Parking is the act of stopping",
  //             style: TextStyle(
  //               color: Col.Onbackground,
  //               fontSize: 18,
  //               fontFamily: 'Nunito',
  //               letterSpacing: 0.1,
  //             ),
  //           ),
  //         ],
  //       ),
  //       ),
  //         expanded:Column(
  //           children: <Widget>[
  //             Text("Parking is the act of stopping and disengaging a vehicle and leaving it unoccupied. Parking on one or both sides of a road is often permitted, though sometimes with restrictions. Some buildings have parking facilities for use of the buildings' users. Countries and local governments have rules[1] for design and use of parking spaces.",
  //               style: TextStyle(
  //                 color: Col.Onbackground,
  //                 fontSize: 18,
  //                 fontFamily: 'Nunito',
  //                 letterSpacing: 0.1,
  //               ),
  //             ),
  //           ],
  //         ),
  //     ),
  //   ),
  // );

}

/*
Stack(
        fit: StackFit.expand,
        children: <Widget>[Container(
          color: Col.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child:Padding(padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
                  child: Text("Branches",
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
                  height: 500,
                  child: ListView(
                    children: [
                      buildCard(
                        'Lafto'
                      ),
                      buildCard(
                          'Lafto'
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Col.surface,
                  ),
                ),
              ),
              ),
            ],
          ),
        ),
        ],
      ),
 */
