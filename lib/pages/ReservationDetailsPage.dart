// ignore: file_names
// ignore_for_file: file_names, no_logic_in_create_state, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'EditReservation.dart';

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
      required this.startTime,
      required this.slot,
      required this.price,
      required this.duration,
      required this.parked});

  @override
  _ReservationDetailsPageState createState() => _ReservationDetailsPageState(
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

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
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

  _ReservationDetailsPageState(
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

  late String startingTime;
  late String startDate;

  @override
  void initState() {
    super.initState();
    DateTime startingTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(startTime));
    String startDate = DateFormat.yMMMd().format(startingTime);
    String formattedStartTime = DateFormat('h:mm a').format(startingTime);

    this.startingTime = formattedStartTime;
    this.startDate = startDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            leading: IconButton(
              color: Col.Onbackground,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              "Reservation details",
              style: TextStyle(
                color: Col.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
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
      body: SingleChildScrollView(
        child: Container(
          color: Col.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            style: TextStyle(
                              color: Col.blackColor,
                              fontSize: 20,
                              fontFamily: 'Nunito',
                              letterSpacing: 0.3,
                            ),
                            text: "Reservation at "),
                        TextSpan(
                          style: TextStyle(
                            color: Col.blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                            letterSpacing: 0.3,
                          ),
                          text: branchName,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: Divider(
                    color: Col.primary,
                    thickness: 2,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Plate number",
                  style: TextStyle(
                    color: Colors.black,
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
                  reservationPlateNumber,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Date",
                  style: TextStyle(
                    color: Colors.black,
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
                  startDate,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Start time",
                  style: TextStyle(
                    color: Colors.black,
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
                  startingTime,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Duration",
                  style: TextStyle(
                    color: Colors.black,
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
                  "$duration:00 hours",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Slot",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Price",
                  style: TextStyle(
                    color: Colors.black,
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
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: Divider(
                    color: Col.primary,
                    thickness: 2,
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditReservation(
                                id: id,
                                fullName: fullName,
                                phone: phone,
                                email: email,
                                passwordHash: passwordHash,
                                defaultPlateNumber: defaultPlateNumber,
                                reservationId: reservationId,
                                reservationPlateNumber: reservationPlateNumber,
                                branch: branch,
                                branchName: branchName,
                                duration: duration,
                                startTime: int.parse(startTime))));
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  child: Text(
                    "Edit reservation",
                    style: TextStyle(
                      color: Col.linkColor,
                      fontSize: 18,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
