// ignore: file_names
// ignore_for_file: file_names, no_logic_in_create_state, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheger_parking/bloc/home_bloc.dart';
import 'package:sheger_parking/bloc/home_event.dart';
import 'package:sheger_parking/bloc/home_state.dart';
import 'package:sheger_parking/pages/BranchesPage.dart';
import 'package:sheger_parking/pages/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:sheger_parking/pages/Reservations.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

import 'ReservationPage.dart';

class HomePage extends StatefulWidget {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId,
      reservationPlateNumber,
      branch,
      branchName,
      startTime,
      slot,
      price,
      duration,
      parked;

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
      this.branchName,
      this.startTime,
      this.slot,
      this.price,
      this.duration,
      this.parked});

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
      branchName,
      startTime,
      slot,
      price,
      duration,
      parked);
}

class _HomePageState extends State<HomePage> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId,
      reservationPlateNumber,
      branch,
      branchName,
      startTime,
      slot,
      price,
      duration,
      parked;

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
      this.branchName,
      this.startTime,
      this.slot,
      this.price,
      this.duration,
      this.parked);

  // int currentIndex = 0;
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
          startTime: startTime,
          slot: slot,
          price: price,
          duration: duration,
          parked: parked),
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
          defaultPlateNumber: defaultPlateNumber)
    ];
  }

  bool isDataEntered = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Col.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 1.0),
                blurRadius: 7.0,
              )
            ]),
            child: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              toolbarHeight: 60,
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
                    icon: Icon(
                      Icons.person_outline,
                      color: Col.blackColor,
                    )),
              ],
              title: Text(
                "SHEGER",
                style: TextStyle(
                  color: Col.blackColor,
                  fontSize: 24,
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
                      colors: [Colors.white, Colors.white],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter),
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<CurrentIndexBloc, CurrentIndexState>(
            builder: (context, state) {
          return screens[
              BlocProvider.of<CurrentIndexBloc>(context).state.index];
        }),
        bottomNavigationBar: BlocBuilder<CurrentIndexBloc, CurrentIndexState>(
          builder: (context, state) {
            return BottomNavigationBar(
              selectedItemColor: Col.primary,
              iconSize: 28,
              currentIndex:
                  BlocProvider.of<CurrentIndexBloc>(context).state.index,
              onTap: (index) => BlocProvider.of<CurrentIndexBloc>(context)
                  .add(NewIndexEvent(index)),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label: "Branches",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  label: "Reserve",
                ),
              ],
            );
          },
        ));
  }
}
