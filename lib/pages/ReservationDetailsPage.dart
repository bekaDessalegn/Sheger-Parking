// ignore: file_names
// ignore_for_file: file_names, no_logic_in_create_state, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

class ReservationDetailsPage extends StatefulWidget {
  String id,
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
      parked;

  ReservationDetailsPage(
      {required this.id,
      required this.fullName,
      required this.phone,
      required this.email,
      required this.passwordHash,
      required this.defaultPlateNumber,
        required this.reservationId,
        required this.reservationPlateNumber,
        required this.branch,
        required this.branchName,
        required this.startTime, required this.slot, required this.price, required this.duration, required this.parked});

  @override
  _ReservationDetailsPageState createState() => _ReservationDetailsPageState(
      id, fullName, phone, email, passwordHash, defaultPlateNumber, reservationId, reservationPlateNumber, branch, branchName, startTime, slot, price, duration, parked);
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber, reservationId, reservationPlateNumber, branch, branchName, startTime, slot, price, duration, parked;

  _ReservationDetailsPageState(this.id, this.fullName, this.phone, this.email,
      this.passwordHash, this.defaultPlateNumber, this.reservationId, this.reservationPlateNumber, this.branch, this.branchName, this.startTime, this.slot, this.price, this.duration, this.parked);

  String? startingTime;

  @override
  void initState() {
    super.initState();
    DateTime startingTime = DateTime.fromMillisecondsSinceEpoch(int.parse(startTime));
    String formattedStartTime = DateFormat('kk:00 a').format(startingTime);
    // String datetime = startingTime.hour.toString().padLeft(2, '0') + ":" + startingTime.minute.toString().padLeft(2, '0');

    this.startingTime = formattedStartTime;

  }

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
        leading: IconButton(
          color: Col.Onbackground,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
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
      body: SingleChildScrollView(
        child: Container(
          color: Col.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 40, 0, 0),
                child: Text(
                  "Reservation Details",
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 40, 0, 0),
                child: Text(
                  "Branch",
                  style: TextStyle(
                    color: Col.Onsurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  branchName,
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Divider(
                color: Col.Onbackground,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Start Time",
                  style: TextStyle(
                    color: Col.Onsurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  "$startingTime",
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Divider(
                color: Col.Onbackground,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Duration",
                  style: TextStyle(
                    color: Col.Onsurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  "$duration hours",
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Divider(
                color: Col.Onbackground,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Slot",
                  style: TextStyle(
                    color: Col.Onsurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  slot,
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Divider(
                color: Col.Onbackground,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Price",
                  style: TextStyle(
                    color: Col.Onsurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  "$price birr",
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Divider(
                color: Col.Onbackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
