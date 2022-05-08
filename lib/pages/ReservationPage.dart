// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
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
  _ReservationPageState createState() => _ReservationPageState(id, fullName, phone, email, passwordHash, defaultPlateNumber);
}

class _ReservationPageState extends State<ReservationPage> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;

  _ReservationPageState(this.id, this.fullName, this.phone, this.email, this.passwordHash, this.defaultPlateNumber);

  final branches = [
    'Branch 1',
    'Branch 2',
    'Branch 3',
    'Branch 4',
    'Branch 5',
    'Branch 6'
  ];

  String? value;

  DateTime dateTime = DateTime(2022, 3, 21, 4, 0);

  final _formKey = GlobalKey<FormState>();

  String? slotResponse;

  Future reserve() async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse(
        'http://192.168.1.4:5000/token:qwhu67fv56frt5drfx45e/reservations');

    var body = {
      "client": id,
      "reservationPlateNumber": reservation.reservationPlateNumber,
      "branch": reservation.branch,
      "slot": 69,
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
      String startingTime = data["startingTime"].toString();
      String slot = data["slot"].toString();
      String price = data["price"].toString();
      String duration = data["duration"].toString();
      String parked = data["parked"].toString();
      setState(() {
        slotResponse = "There is an available spot";
      });
      print(resBody);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber,
          reservationId: reservationId,
          reservationPlateNumber: reservationPlateNumber,
          branch: branch,
          startTime: startingTime, slot: slot, price: price, duration: duration, parked: parked)));
    } else {
      var data = json.decode(resBody);
      setState(() {
        slotResponse = data["message"];
      });
      print(resBody);
    }
  }



  Reservation reservation = Reservation("", "", "", 0, "", 0, 0);

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    reservation.startingTime = int.parse(hours);
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return SingleChildScrollView(
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
                  "Reservation",
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                              reservation.branch = "62545d01f8edb0abc4946574";
                            }),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
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
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
                    //   child: Container(
                    //     width: 300,
                    //     child: Text(
                    //       "Duration (hours)",
                    //       style: TextStyle(
                    //         color: Col.textfieldLabel,
                    //         fontSize: 22,
                    //         fontWeight: FontWeight.bold,
                    //         fontFamily: 'Nunito',
                    //         letterSpacing: 0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 40, 25, 0),
                      child: Container(
                        width: double.infinity,
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Duration (hours)",
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
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                    //   child: Container(
                    //     width: 180,
                    //     alignment: Alignment.center,
                    //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    //     child: TextFormField(
                    //             controller: TextEditingController(text: ""),
                    //             onChanged: (value) {
                    //               reservation.duration = int.parse(value);
                    //             },
                    //             validator: (value) {
                    //               if (value!.isEmpty) {
                    //                 return "This field can not be empty";
                    //               }
                    //               return null;
                    //             },
                    //             style: TextStyle(
                    //               color: Col.textfieldLabel,
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.bold,
                    //               fontFamily: 'Nunito',
                    //               letterSpacing: 0,
                    //             ),
                    //             textAlign: TextAlign.center,
                    //             decoration: InputDecoration(
                    //               border: InputBorder.none,
                    //               errorBorder: OutlineInputBorder(
                    //                 borderSide: BorderSide(color: Colors.red),
                    //               ),
                    //             ),
                    //             keyboardType: TextInputType.number,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             border: Border.all(color: Col.Onsurface, width: 1),
                    //           ),
                    //         ),
                    //   ),
                    (slotResponse == "No_Available_Slot") ?
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 25),
                      child: Text("No Available Slot",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      ),
                    ) : Text(""),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 35, 0, 20),
                      child: Center(
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              reserve();
                            }
                          },
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                          color: Col.secondary,
                          child: Text(
                            'Reserve',
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

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      this.dateTime = dateTime;
    });
  }
}
