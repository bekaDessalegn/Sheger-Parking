// ignore: file_names
// ignore_for_file: file_names, no_logic_in_create_state, prefer_const_constructors

import 'package:sheger_parking/pages/BranchesPage.dart';
import 'package:sheger_parking/pages/EditReservation.dart';
import 'package:sheger_parking/pages/ProfilePage.dart';
import 'package:sheger_parking/pages/ReservationDetailsPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ReservationPage.dart';

class HomePage extends StatefulWidget {

  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  HomePage({required this.id, required this.fullName, required this.phone, required this.email, required this.passwordHash, required this.defaultPlateNumber});

  @override
  _HomePageState createState() => _HomePageState(id, fullName, phone, email, passwordHash, defaultPlateNumber);
}

class _HomePageState extends State<HomePage> {

  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  _HomePageState(this.id, this.fullName, this.phone, this.email, this.passwordHash, this.defaultPlateNumber);

  dynamic infos = [
    {
      "plateNumber": "624875",
      "time": "8:00 A.M",
      "duration": "3 hrs",
      "branch": "Branch 1"
    },
    {
      "plateNumber": "215896",
      "time": "4:00 A.M",
      "duration": "6 hrs",
      "branch": "Branch 2"
    },
    {
      "plateNumber": "478563",
      "time": "7:00 A.M",
      "duration": "2 hrs",
      "branch": "Branch 3"
    },
    {
      "plateNumber": "015874",
      "time": "1:00 A.M",
      "duration": "4 hrs",
      "branch": "Branch 4"
    },
    {
      "plateNumber": "624875",
      "time": "8:00 A.M",
      "duration": "3 hrs",
      "branch": "Branch 5"
    },
    {
      "plateNumber": "215896",
      "time": "4:00 A.M",
      "duration": "6 hrs",
      "branch": "Branch 6"
    },
    {
      "plateNumber": "478563",
      "time": "7:00 A.M",
      "duration": "2 hrs",
      "branch": "Branch 7"
    },
    {
      "plateNumber": "015874",
      "time": "1:00 A.M",
      "duration": "4 hrs",
      "branch": "Branch 8"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Col.background,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 16.0,
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
                    MaterialPageRoute(builder: (context) => ProfilePage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber)));
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
                "Reservations",
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
                itemCount: infos.length,
                itemBuilder: (context, index) {
                  dynamic info = infos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReservationDetailsPage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber)));
                    },
                    child: Padding(
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
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditReservation(
                                                        plateNumber:
                                                            "235688")));
                                      },
                                      icon: Icon(Icons.edit),
                                      iconSize: 25,
                                    ),
                                    alignment: Alignment.topRight,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                    child: Text(
                                      "Reservation at ${info["branch"]}",
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
                                  color: Col.Onbackground,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                "Description 2",
                                style: TextStyle(
                                  color: Col.Onbackground,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      ),
                    ),
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: RaisedButton(
                  color: Col.primary,
                  child: Text(
                    "Explore\nBranches",
                    style: TextStyle(
                      color: Col.Onprimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BranchesPage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber)));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: RaisedButton(
                  color: Col.primary,
                  child: Text(
                    "Reserve a\nspot",
                    style: TextStyle(
                      color: Col.Onprimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReservationPage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber)));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
