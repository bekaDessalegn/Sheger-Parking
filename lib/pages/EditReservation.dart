// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors, no_logic_in_create_state

import 'dart:convert';

import 'package:sheger_parking/models/Reservation.dart';
import 'package:sheger_parking/pages/EditProfile.dart';
import 'package:sheger_parking/pages/StartUpPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import 'ProfilePage.dart';

class EditReservation extends StatefulWidget {
  String id,
      fullName,
      phone,
      email,
      passwordHash,
      defaultPlateNumber;
  var reservationId, reservationPlateNumber, branch, startTime;

  EditReservation(
      {required this.id,
      required this.fullName,
      required this.phone,
      required this.email,
      required this.passwordHash,
      required this.defaultPlateNumber,
      required this.reservationId,
      required this.reservationPlateNumber,
      required this.branch,
      required this.startTime});

  @override
  _EditReservationState createState() => _EditReservationState(
      id,
      fullName,
      phone,
      email,
      passwordHash,
      defaultPlateNumber,
      reservationId,
      reservationPlateNumber,
      branch,
      startTime);
}

class _EditReservationState extends State<EditReservation> {
  String id,
      fullName,
      phone,
      email,
      passwordHash,
      defaultPlateNumber;

  var reservationId, reservationPlateNumber, branch, startTime;

  _EditReservationState(
      this.id,
      this.fullName,
      this.phone,
      this.email,
      this.passwordHash,
      this.defaultPlateNumber,
      this.reservationId,
      this.reservationPlateNumber,
      this.branch,
      this.startTime);

  final _formKey = GlobalKey<FormState>();

  final branches = [
    'Branch 1',
    'Branch 2',
    'Branch 3',
    'Branch 4',
    'Branch 5',
    'Branch 6'
  ];
  final duration = ['hours', 'days'];
  String? duration_value = 'hours';
  String? value;
  String price = "25";

  String _selectedTime = '8:00 AM';
  DateTime dateTime = DateTime(2022, 12, 24);

  Future editReservation() async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse(
        'http://10.4.109.57:5000/token:qwhu67fv56frt5drfx45e/reservations/$reservationId');

    var body = {
      "reservationPlateNumber": reservationPlateNumber,
      "branch": branch,
      "startingTime": startTime
    };
    var req = http.Request('PATCH', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    // reservation.startingTime = int.parse(hours);
    startTime = hours;
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          margin: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 25, 0, 0),
                  child: Text(
                    "Edit Reservation",
                    style: TextStyle(
                      color: Col.Onbackground,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black26, width: 1),
                    color: Col.background,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 40, 25, 0),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: TextEditingController(
                                text: reservationPlateNumber),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This field can not be empty";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              reservationPlateNumber = value;
                            },
                            decoration: InputDecoration(
                              hintText: "",
                              hintStyle: TextStyle(
                                color: Col.textfieldLabel,
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.1,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: "Plate Number",
                              labelStyle: TextStyle(
                                color: Col.textfieldLabel,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                letterSpacing: 0,
                              ),
                              border: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            "Branch",
                            style: TextStyle(
                              color: Col.textfieldLabel,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Col.Onsurface, width: 1),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: value,
                              isExpanded: true,
                              items: branches.map(buildMenuBranch).toList(),
                              onChanged: (value) => setState(() {
                                this.value = value;
                                // branch = "62545d01f8edb0abc4946574";
                              }),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 20, 0, 20),
                        child: Container(
                          width: 300,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Start time : ",
                                style: TextStyle(
                                  color: Col.textfieldLabel,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                  letterSpacing: 0,
                                ),
                              ),
                              Container(
                                width: 170,
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: RaisedButton(
                                  color: Col.secondary,
                                  child: Center(
                                    child: Text(
                                      "${dateTime.year}/${dateTime.month}/${dateTime.day} \n    $hours:$minutes",
                                      style: TextStyle(
                                        color: Col.Onprimary,
                                        fontSize: 16,
                                        fontFamily: 'Nunito',
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    pickDateTime();
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                        child: Center(
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                editReservation();
                              }
                            },
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 100),
                            color: Col.secondary,
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Col.Onbackground,
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (_formKey.currentState!.validate()) {
      //       editReservation();
      //     }
      //   },
      //   backgroundColor: Col.primary,
      //   child: Icon(
      //     Icons.check,
      //     color: Col.Onbackground,
      //   ),
      // ),
    );
  }

  Future pickDateTime() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (date == null) return;

    TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, date.hour, date.minute);

    setState(() {
      this.dateTime = dateTime;
      _selectedTime = time.format(context);
    });
  }

  DropdownMenuItem<String> buildMenuBranch(String branch) => DropdownMenuItem(
        value: branch,
        child: Text(
          branch,
          style: TextStyle(
            color: Col.Onbackground,
            fontSize: 18,
            fontFamily: 'Nunito',
            letterSpacing: 0.3,
          ),
        ),
      );

  DropdownMenuItem<String> buildMenuDuration(String duration) =>
      DropdownMenuItem(
        value: duration,
        child: Text(
          duration,
          style: TextStyle(
            color: Col.Onbackground,
            fontSize: 18,
            fontFamily: 'Nunito',
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      );
}
