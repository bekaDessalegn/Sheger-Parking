// ignore: file_names
// ignore_for_file: file_names, no_logic_in_create_state, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:sheger_parking/pages/BranchesPage.dart';
import 'package:sheger_parking/pages/EditReservation.dart';
import 'package:sheger_parking/pages/NoReservation.dart';
import 'package:sheger_parking/pages/ProfilePage.dart';
import 'package:sheger_parking/pages/ReservationDetailsPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sheger_parking/pages/Reservations.dart';
import 'package:sheger_parking/pages/filter_network_list_page.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ReservationPage.dart';

class HomePage extends StatefulWidget {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId, reservationPlateNumber, branch, startTime, slot, price, duration, parked;

  HomePage(
      {required this.id,
      required this.fullName,
      required this.phone,
      required this.email,
      required this.passwordHash,
      required this.defaultPlateNumber,
      this.reservationId,
      this.reservationPlateNumber,
      this.branch,
      this.startTime, this.slot, this.price, this.duration, this.parked});

  @override
  _HomePageState createState() => _HomePageState(
      id,
      fullName,
      phone,
      email,
      passwordHash,
      defaultPlateNumber,
      reservationId,
      reservationPlateNumber,
      branch,
      startTime, slot, price, duration, parked);
}

class _HomePageState extends State<HomePage> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId, reservationPlateNumber, branch, startTime, slot, price, duration, parked;

  _HomePageState(
      this.id,
      this.fullName,
      this.phone,
      this.email,
      this.passwordHash,
      this.defaultPlateNumber,
      this.reservationId,
      this.reservationPlateNumber,
      this.branch,
      this.startTime, this.slot, this.price, this.duration, this.parked);

  int currentIndex = 0;
  var screens;

  @override
  void initState() {
    super.initState();
    screens = [
      Reservations(
          id: id,
          fullName: fullName,
          phone: phone,
          email: email,
          passwordHash: passwordHash,
          defaultPlateNumber: defaultPlateNumber,
          reservationId: reservationId,
          reservationPlateNumber: reservationPlateNumber,
          branch: branch,
          startTime: startTime, slot: slot, price: price, duration: duration, parked: parked),
      BranchesPage(
          id: id,
          fullName: fullName,
          phone: phone,
          email: email,
          passwordHash: passwordHash,
          defaultPlateNumber: defaultPlateNumber),
      ReservationPage(
          id: id,
          fullName: fullName,
          phone: phone,
          email: email,
          passwordHash: passwordHash,
          defaultPlateNumber: defaultPlateNumber),
      FilterNetworkListPage()
    ];
  }

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

  bool isDataEntered = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Col.background,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 4.0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              color: Col.Onbackground,
              padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
              iconSize: 40,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                            id: id,
                            fullName: fullName,
                            phone: phone,
                            email: email,
                            passwordHash: passwordHash,
                            defaultPlateNumber: defaultPlateNumber)));
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
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0)),
            gradient: LinearGradient(
                colors: [Col.secondary, Col.secondary],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Col.primary,
        iconSize: 28,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_repair),
            label: "Branches",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_late),
            label: "Reserve",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_repair_service),
            label: "Trial",
          ),
        ],
      ),
    );
  }
}
