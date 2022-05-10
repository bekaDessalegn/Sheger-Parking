// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors, no_logic_in_create_state

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sheger_parking/models/BranchDetails.dart';
import 'package:sheger_parking/models/Reservation.dart';
import 'package:sheger_parking/pages/HomePage.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:http/http.dart' as http;

class EditReservation extends StatefulWidget {
  String id,
      fullName,
      phone,
      email,
      passwordHash,
      defaultPlateNumber;
  var reservationId, reservationPlateNumber, branch, branchName, startTime;

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
      required this.branchName,
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
      branchName,
      startTime);
}

class _EditReservationState extends State<EditReservation> {
  String id,
      fullName,
      phone,
      email,
      passwordHash,
      defaultPlateNumber;

  var reservationId, reservationPlateNumber, branch, branchName, startTime;

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
      this.branchName,
      this.startTime);

  final _formKey = GlobalKey<FormState>();

  List<String> branchesName = [];
  List<String> branchesId = [];

  String? value;
  String checker = '';

  // DateTime dateTime = DateTime(2022, 12, 24);
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String? currentYear, currentMonth, currentDay, currentHour, currentMinute;

  // bool? slotResponse;

  Future editReservation() async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse(
        'http://192.168.1.5:5000/token:qwhu67fv56frt5drfx45e/reservations/$reservationId');

    var body = {
      "reservationPlateNumber": reservationPlateNumber,
      "branch": branch,
      "branchName": branchName,
      "startingTime": startTime
    };
    var req = http.Request('PATCH', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      var data = json.decode(resBody);
      // setState(() {
      //   slotResponse = data["updated"];
      // });

      // if(slotResponse == true)
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber)));
    } else {
      print(res.reasonPhrase);
    }
  }

  Reservation reservation = Reservation("", "", "", "", 0, 0, 0);

  List<BranchDetails> branches = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    DateTime currentDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String currentYear = currentDateTime.year.toString();
    String currentMonth = currentDateTime.month.toString();
    String currentDay = currentDateTime.day.toString();
    String currentHour = currentDateTime.hour.toString();
    String currentMinute = "0".padLeft(2, '0');
    this.currentYear = currentYear;
    this.currentMonth = currentMonth;
    this.currentDay = currentDay;
    this.currentHour = currentHour;
    this.currentMinute = currentMinute;

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(milliseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  static Future<List<BranchDetails>> getBranchDetails(
      String query) async {
    final url = Uri.parse(
        'http://192.168.1.5:5000/token:qwhu67fv56frt5drfx45e/branches');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List branchDetails = json.decode(response.body);

      return branchDetails
          .map((json) => BranchDetails.fromJson(json))
          .where((branchDetail) {
        final branchNameLower =
        branchDetail.name.toLowerCase();
        final branchIdLower = branchDetail.id.toLowerCase();
        final searchLower = query.toLowerCase();

        return branchNameLower.contains(searchLower) ||
            branchIdLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  Future init() async {
    final branchDetails = await getBranchDetails(query);

    setState(() => this.branches = branchDetails);

    for(int i = 0; i < branches.length; i++){
      final branchDetail = branches[i];

      setState(() {
        branchesName.add(branchDetail.name);
        branchesId.add(branchDetail.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final hours = dateTime.hour.toString().padLeft(2, '0');
    // reservation.startingTime = int.parse(hours);
    startTime = timestamp;
    // final minutes = dateTime.minute.toString().padLeft(2, '0');

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
                          EdgeInsets.symmetric(vertical: 4),
                          child: DropdownButtonFormField<String>(
                            value: value,
                            isExpanded: true,
                            items: branchesName.map(buildMenuBranch).toList(),
                            onChanged: (value) => setState(() {
                              this.value = value;
                              checker = value!;
                              setState(() {
                                branchName = value;
                              });

                              for(int i = 0; i < branches.length; i++){
                                final branchDetail = branches[i];

                                if(value == branchDetail.name){
                                  setState(() {
                                    branch = branchesId[i];
                                  });
                                }
                              }

                              print(reservation.branch);

                            }),
                            validator: (value) {
                              if (checker == '') {
                                return "This field can not be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // (slotResponse == true)
                      //     ? Padding(
                      //   padding: const EdgeInsets.only(top: 5),
                      //   child: Text(
                      //     "No Available Slot",
                      //     style: TextStyle(
                      //         color: Colors.redAccent,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 15),
                      //   ),
                      // )
                      //     : Text(""),
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
                                      "$currentYear/$currentMonth/$currentDay \n    $currentHour:$currentMinute",
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

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1991),
      lastDate: DateTime(2050));

  Future<TimeOfDay?> pickTime() => showCustomTimePicker(
      context: context,
      // It is a must if you provide selectableTimePredicate
      onFailValidation: (context) => print('Unavailable selection'),
      initialTime: TimeOfDay(hour: 6, minute: 0),
      selectableTimePredicate: (time) => time!.minute == 0);

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
    DateTime(date.year, date.month, date.day, time.hour, time.minute);

    int timestamp = dateTime.millisecondsSinceEpoch;

    String currentYear = dateTime.year.toString();
    String currentMonth = dateTime.month.toString();
    String currentDay = dateTime.day.toString();
    String currentHour = dateTime.hour.toString().padLeft(2, '0');

    setState(() {
      // this.dateTime = dateTime;
      this.timestamp = timestamp;
      this.currentYear = currentYear;
      this.currentMonth = currentMonth;
      this.currentDay = currentDay;
      this.currentHour = currentHour;
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

  // DropdownMenuItem<String> buildMenuDuration(String duration) =>
  //     DropdownMenuItem(
  //       value: duration,
  //       child: Text(
  //         duration,
  //         style: TextStyle(
  //           color: Col.Onbackground,
  //           fontSize: 18,
  //           fontFamily: 'Nunito',
  //           letterSpacing: 0.3,
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //     );
}
