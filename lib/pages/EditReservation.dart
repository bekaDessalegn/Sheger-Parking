// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors, no_logic_in_create_state

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sheger_parking/bloc/home_bloc.dart';
import 'package:sheger_parking/constants/api.dart';
import 'package:sheger_parking/models/BranchDetails.dart';
import 'package:sheger_parking/models/Reservation.dart';
import 'package:sheger_parking/pages/HomePage.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:http/http.dart' as http;

class EditReservation extends StatefulWidget {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId,
      reservationPlateNumber,
      branch,
      branchName,
      duration,
      startTime;

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
      required this.duration,
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
      duration,
      startTime);
}

class _EditReservationState extends State<EditReservation> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;

  var reservationId,
      reservationPlateNumber,
      branch,
      branchName,
      duration,
      startTime;

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
      this.duration,
      this.startTime);

  final _formKey = GlobalKey<FormState>();

  List<String> branchesName = [];
  List<String> branchesId = [];

  String? value;
  String checker = '';

  // DateTime dateTime = DateTime(2022, 12, 24);

  DateTime? startingTime;
  int? timestamp;

  // String? currentYear, currentMonth, currentDay, currentHour, currentMinute;
  String? formattedstartTime, startDate;
  bool? slotResponse;

  late DateTime fullTime;
  bool validDate = true;

  Future availablility() async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse('${base_url}/reservations/availability');

    var body = {
      "branch": branch,
      "startingTime": startTime,
      "duration": duration
    };
    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      var data = json.decode(resBody);
      setState(() {
        slotResponse = data["slotAvailable"];
      });

      print(resBody);
    } else {
      print("mneeeeeeeeeeeeeeeeeeeee");
      print(res.reasonPhrase);
    }
  }

  Future editReservation() async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse('${base_url}/reservations/$reservationId');

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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) => CurrentIndexBloc(),
                  child: HomePage(
                      id: id,
                      fullName: fullName,
                      phone: phone,
                      email: email,
                      passwordHash: passwordHash,
                      defaultPlateNumber: defaultPlateNumber))), (Route<dynamic> route) => false);
    } else {
      print(resBody);
    }
  }

  Reservation reservation = Reservation("", "", "", "", 0, 0, 0);

  List<BranchDetails> branches = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    reservation.branch = branch;

    setState(() {
      checker = branchName;
      value = branchName;
    });

    int initialTime = DateTime.now().millisecondsSinceEpoch;
    final fullTime = initialTime + (3600000 - (initialTime % 3600000));
    DateTime initialDateTime = DateTime.fromMillisecondsSinceEpoch(fullTime);
    this.fullTime = initialDateTime;

    DateTime startingTime = DateTime.fromMillisecondsSinceEpoch(startTime);
    int timestamp = startingTime.millisecondsSinceEpoch;
    DateTime currentDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // String formattedDate = DateFormat('yyyy-MM-dd  \n  kk:00 a').format(currentDateTime);

    this.startingTime = startingTime; // DateTime
    this.timestamp = timestamp;
    // this.formattedDate = formattedDate;

    String startDate = DateFormat.yMMMd().format(currentDateTime);
    String formattedstartTime = DateFormat('h:mm a').format(currentDateTime);

    this.startDate = startDate;
    this.formattedstartTime = formattedstartTime;

    // String currentYear = currentDateTime.year.toString();
    // String currentMonth = currentDateTime.month.toString();
    // String currentDay = currentDateTime.day.toString();
    // String currentHour = currentDateTime.hour.toString();
    // String currentMinute = "0".padLeft(2, '0');
    // this.currentYear = currentYear;
    // this.currentMonth = currentMonth;
    // this.currentDay = currentDay;
    // this.currentHour = currentHour;
    // this.currentMinute = currentMinute;

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

  static Future<List<BranchDetails>> getBranchDetails(String query) async {
    final url = Uri.parse('${base_url}/branches');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List branchDetails = json.decode(response.body);

      return branchDetails
          .map((json) => BranchDetails.fromJson(json))
          .where((branchDetail) {
        final branchNameLower = branchDetail.name.toLowerCase();
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

    for (int i = 0; i < branches.length; i++) {
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
              "Reservation",
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
          margin: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    "Editing your reservation",
                    style: TextStyle(
                      color: Col.blackColor,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 15, 25, 3),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          "Plate Number",
                          style: TextStyle(
                            color: Col.textfieldLabel,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: Container(
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
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            // labelText: "Plate Number",
                            // labelStyle: TextStyle(
                            //   color: Col.textfieldLabel,
                            //   fontSize: 14,
                            //   fontFamily: 'Nunito',
                            //   letterSpacing: 0,
                            // ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Col.primary),
                            ),
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
                            fontSize: 14,
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
                        padding: EdgeInsets.symmetric(vertical: 4),
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

                            for (int i = 0; i < branches.length; i++) {
                              final branchDetail = branches[i];

                              if (value == branchDetail.name) {
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
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Col.primary),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                    //   child: Container(
                    //     width: double.infinity,
                    //     child: Text(
                    //       "Branch",
                    //       style: TextStyle(
                    //         color: Col.textfieldLabel,
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //         fontFamily: 'Nunito',
                    //         letterSpacing: 0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                    //   child: Container(
                    //     width: double.infinity,
                    //     alignment: Alignment.center,
                    //     padding:
                    //     EdgeInsets.symmetric(vertical: 4),
                    //     child: DropdownButtonFormField<String>(
                    //       value: value,
                    //       isExpanded: true,
                    //       items: branchesName.map(buildMenuBranch).toList(),
                    //       onChanged: (value) => setState(() {
                    //         this.value = value;
                    //         checker = value!;
                    //         setState(() {
                    //           branchName = value;
                    //         });
                    //
                    //         for(int i = 0; i < branches.length; i++){
                    //           final branchDetail = branches[i];
                    //
                    //           if(value == branchDetail.name){
                    //             setState(() {
                    //               branch = branchesId[i];
                    //             });
                    //           }
                    //         }
                    //
                    //         print(reservation.branch);
                    //
                    //       }),
                    //       validator: (value) {
                    //         if (checker == '') {
                    //           return "This field can not be empty";
                    //         }
                    //         return null;
                    //       },
                    //       decoration: InputDecoration(
                    //         border: OutlineInputBorder(
                    //           borderSide: BorderSide(color: Colors.black),
                    //         ),
                    //         errorBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(color: Colors.red),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    (slotResponse == false)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "No Available Slot",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        : Text(""),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 3),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          "Start time",
                          style: TextStyle(
                            color: Col.textfieldLabel,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: RaisedButton(
                        color: Colors.white,
                        focusElevation: 0.0,
                        hoverElevation: 0.0,
                        highlightElevation: 0.0,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // "$formattedStartTime - $formattedFinishTime",
                              "$startDate ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Nunito',
                              ),
                            ),
                            Text(
                              // "$formattedStartTime - $formattedFinishTime",
                              "|",
                              style: TextStyle(
                                color: Col.primary,
                                fontSize: 16,
                                fontFamily: 'Nunito',
                              ),
                            ),
                            Text(
                              // "$formattedStartTime - $formattedFinishTime",
                              " $formattedstartTime",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          pickDateTime();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black26, width: 1),
                      ),
                    ),
                    validDate
                        ? Text("")
                        : Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "Invalid starting time!",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 20, 25, 3),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          "Duration (hours)",
                          style: TextStyle(
                            color: Col.textfieldLabel,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: Container(
                        // color: Colors.grey[350],
                        alignment: Alignment.center,
                        child: TextFormField(
                          enabled: false,
                          controller: TextEditingController(text: "$duration"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field can not be empty";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            reservation.duration = int.parse(value);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "",
                            hintStyle: TextStyle(
                              color: Col.textfieldLabel,
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              letterSpacing: 0.1,
                            ),
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            // labelText: "Duration (hours)",
                            // labelStyle: TextStyle(
                            //   color: Col.textfieldLabel,
                            //   fontSize: 14,
                            //   fontFamily: 'Nunito',
                            //   letterSpacing: 0,
                            // ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Col.primary),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                      child: Center(
                        child: RaisedButton(
                          onPressed: () async {
                            bool validForm = _formKey.currentState!.validate();
                            if (startTime <
                                DateTime.now().millisecondsSinceEpoch) {
                              setState(() {
                                validDate = false;
                              });
                            } else {
                              setState(() {
                                validDate = true;
                              });
                              if (validForm) {
                                await availablility();
                                if (slotResponse == true) {
                                  editReservation();
                                }
                              }
                            }
                          },
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 100),
                          color: Col.primary,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Col.blackColor,
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
      initialDate: fullTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050));

  Future<TimeOfDay?> pickTime() => showCustomTimePicker(
      context: context,
      // It is a must if you provide selectableTimePredicate
      onFailValidation: (context) => print('Unavailable selection'),
      initialTime: TimeOfDay(hour: fullTime.hour, minute: 0),
      selectableTimePredicate: (time) {
        return time!.minute == 0;
      });

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    int timestamp = dateTime.millisecondsSinceEpoch;

    String startDate = DateFormat.yMMMd().format(dateTime);
    String formattedstartTime = DateFormat('h:mm a').format(dateTime);

    setState(() {
      this.timestamp = timestamp;
      this.startDate = startDate;
      this.formattedstartTime = formattedstartTime;
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
