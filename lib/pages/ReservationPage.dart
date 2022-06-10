// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sheger_parking/constants/api.dart';
import 'package:sheger_parking/models/BranchDetails.dart';
import 'package:sheger_parking/models/Reservation.dart';
import 'package:sheger_parking/pages/HomePage.dart';

import '../constants/colors.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:http/http.dart' as http;

class ReservationPage extends StatefulWidget {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;

  ReservationPage(
      {required this.id,
      required this.fullName,
      required this.phone,
      required this.email,
      required this.passwordHash,
      required this.defaultPlateNumber});

  @override
  _ReservationPageState createState() => _ReservationPageState(
      id, fullName, phone, email, passwordHash, defaultPlateNumber);
}

class _ReservationPageState extends State<ReservationPage> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;

  _ReservationPageState(this.id, this.fullName, this.phone, this.email,
      this.passwordHash, this.defaultPlateNumber);

   List<String> branchesName = [];
   List<String> branchesId = [];

  String? value;
  String checker = '';

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String? startDate, startTime;

  final _formKey = GlobalKey<FormState>();

  String? slotResponse;

  Future reserve() async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse(
        '${base_url}/reservations');

    var body = {
      "client": id,
      "reservationPlateNumber": reservation.reservationPlateNumber,
      "branch": reservation.branch,
      "branchName": reservation.branchName,
      "price": 87,
      "startingTime": reservation.startingTime,
      "duration": reservation.duration
    };
    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      var data = json.decode(resBody);
      String reservationId = data["id"].toString();
      String reservationPlateNumber = data["reservationPlateNumber"].toString();
      String branch = data["branch"].toString();
      String branchName = data["branchName"].toString();
      String startingTime = data["startingTime"].toString();
      String slot = data["slot"].toString();
      String price = data["price"].toString();
      String duration = data["duration"].toString();
      String parked = data["parked"].toString();
      setState(() {
        slotResponse = "There is an available spot";
      });
      print(resBody);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
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
                  startTime: startingTime,
                  slot: slot,
                  price: price,
                  duration: duration,
                  parked: parked)));
    } else {
      var data = json.decode(resBody);
      setState(() {
        slotResponse = data["message"];
      });
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

    DateTime currentDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    String startDate = DateFormat.yMMMd().format(currentDateTime);
    String startTime = DateFormat('h:mm a').format(currentDateTime);

    this.startDate = startDate;
    this.startTime = startTime;

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
        '${base_url}/branches');
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
    reservation.startingTime = timestamp;
    // final minutes = dateTime.minute.toString().padLeft(2, '0');

    return SingleChildScrollView(
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
                  "Reserve a spot",
                  style: TextStyle(
                    color: Col.blackColor,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Column(
                  children: [
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
                              text: reservation.reservationPlateNumber),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field can not be empty";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            reservation.reservationPlateNumber = value;
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

                    /////////////////////////////////////////////////////////////////////
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 40, 25, 0),
                    //   child: Container(
                    //     width: double.infinity,
                    //     alignment: Alignment.center,
                    //     child: TextFormField(
                    //       controller: TextEditingController(
                    //           text: reservation.reservationPlateNumber),
                    //       validator: (value) {
                    //         if (value!.isEmpty) {
                    //           return "This field can not be empty";
                    //         }
                    //         return null;
                    //       },
                    //       onChanged: (value) {
                    //         reservation.reservationPlateNumber = value;
                    //       },
                    //       decoration: InputDecoration(
                    //         hintText: "",
                    //         hintStyle: TextStyle(
                    //           color: Col.textfieldLabel,
                    //           fontSize: 14,
                    //           fontFamily: 'Nunito',
                    //           letterSpacing: 0.1,
                    //         ),
                    //         floatingLabelBehavior: FloatingLabelBehavior.always,
                    //         labelText: "Plate Number",
                    //         labelStyle: TextStyle(
                    //           color: Col.blackColor,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.w600,
                    //           fontFamily: 'Nunito',
                    //           letterSpacing: 0.1,
                    //         ),
                    //         border: OutlineInputBorder(),
                    //         errorBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(color: Colors.red),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                                reservation.branchName = value;
                              });

                              for(int i = 0; i < branches.length; i++){
                                final branchDetail = branches[i];

                                if(value == branchDetail.name){
                                  setState(() {
                                    reservation.branch = branchesId[i];
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
                    (slotResponse == "INVALID_CALL:|:No_Available_Slot")
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
                          mainAxisAlignment:
                          MainAxisAlignment.center,
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
                              " $startTime",
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
                                    border: Border.all(color: Col.blackColor, width: 1),
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
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: TextEditingController(text: ""),
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              reserve();
                            }
                          },
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 100),
                          color: Col.primary,
                          child: Text(
                            'Reserve',
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
    );
  }

  // Future pickDateTime() async {
  //
  //   DateTime? date = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime(2100));
  //   if(date == null) return;
  //
  //   TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
  //   if(time == null) return;
  //
  //   final dateTime = DateTime(
  //     date.year,
  //     date.month,
  //     date.day,
  //     date.hour,
  //     date.minute
  //   );
  //
  //   setState(() {
  //     this.dateTime = dateTime;
  //     _selectedTime = time.format(context);
  //   });
  // }

  // Future<void> _openTimePicker(BuildContext context) async {
  //   final TimeOfDay? t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
  //
  //   if(t != null){
  //     setState(() {
  //       _selectedTime = t.format(context);
  //     });
  //   }
  // }

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

    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    int timestamp = dateTime.millisecondsSinceEpoch;

    // String currentYear = dateTime.year.toString();
    // String currentMonth = dateTime.month.toString();
    // String currentDay = dateTime.day.toString();
    // String currentHour = dateTime.hour.toString().padLeft(2, '0');

    String startDate = DateFormat.yMMMd().format(dateTime);
    String startTime = DateFormat('h:mm a').format(dateTime);

    setState(() {
      // this.dateTime = dateTime;
      this.timestamp = timestamp;
      this.startDate = startDate;
      this.startTime = startTime;
      // this.currentYear = currentYear;
      // this.currentMonth = currentMonth;
      // this.currentDay = currentDay;
      // this.currentHour = currentHour;
    });
  }
}
