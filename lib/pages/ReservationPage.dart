// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

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
import 'package:url_launcher/url_launcher.dart';

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
  List<int> branchesPricePerHour = [];

  String? value;
  String checker = '';

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String? startDate, startTime;

  final _formKey = GlobalKey<FormState>();

  bool? slotResponse;
  bool toPay = false;
  int payement = 0;
  int pricePerHour = 0;

  late String plateNumber;
  late DateTime fullTime;

  var url = "https://www.youtube.com";

  bool validDate = true;

  void launchUrl() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future getDestination() async {}

  Future availablility() async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse('${base_url}/reservations/availability');

    var body = {
      "branch": reservation.branch,
      "startingTime": reservation.startingTime,
      "duration": int.parse(reservation.duration.toString())
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

      if (slotResponse == true) {
        setState(() {
          toPay = true;
        });
      }
    } else {}
  }

  Future reserve() async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse('${base_url}/payment');

    var body = {
      "client": id,
      "reservationPlateNumber": plateNumber,
      "branch": reservation.branch,
      "branchName": reservation.branchName,
      "price": payement,
      "startingTime": reservation.startingTime,
      "duration": int.parse(reservation.duration.toString()),
      "redirectPath": redirect_path
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

      var url = data["paymentUrl"];

      setState(() {
        this.url = url;
      });
      launchUrl();
    } else {}
  }

  Reservation reservation = Reservation("", "", "", "", 0, 0, 1);

  List<BranchDetails> branches = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    plateNumber = defaultPlateNumber;
    final fullTime = timestamp + (3600000 - (timestamp % 3600000));
    DateTime currentDateTime = DateTime.fromMillisecondsSinceEpoch(fullTime);
    this.fullTime = currentDateTime;

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
        branchesPricePerHour.add(branchDetail.pricePerHour);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    reservation.startingTime = timestamp;

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
                        controller: TextEditingController(text: plateNumber),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field can not be empty";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          reservation.reservationPlateNumber = value;
                          plateNumber = value;
                        },
                        enabled: toPay ? false : true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: toPay ? Colors.grey[200] : Colors.white,
                          hintText: "",
                          hintStyle: TextStyle(
                            color: Col.textfieldLabel,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            letterSpacing: 0.1,
                          ),
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
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: DropdownButtonFormField<String>(
                        value: value,
                        isExpanded: true,
                        hint: Text("Select a branch"),
                        items: branchesName.map(buildMenuBranch).toList(),
                        onChanged: toPay
                            ? null
                            : (value) => setState(() {
                                  this.value = value;
                                  checker = value!;

                                  setState(() {
                                    reservation.branchName = value;
                                  });

                                  for (int i = 0; i < branches.length; i++) {
                                    final branchDetail = branches[i];

                                    if (value == branchDetail.name) {
                                      setState(() {
                                        reservation.branch = branchesId[i];
                                      });
                                    }
                                    if (value == branchDetail.name) {
                                      setState(() {
                                        pricePerHour = branchesPricePerHour[i];
                                      });
                                    }
                                  }
                                }),
                        validator: (value) {
                          if (checker == '') {
                            return "This field can not be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Col.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: toPay ? Colors.grey[200] : Colors.white,
                      ),
                    ),
                  ),
                  (slotResponse == false)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "No Available Slot",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15,
                              fontFamily: 'Nunito',
                              letterSpacing: 0.1,
                            ),
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
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      color: Colors.white,
                      focusElevation: 0.0,
                      hoverElevation: 0.0,
                      highlightElevation: 0.0,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      disabledColor: Colors.grey[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$startDate ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          Text(
                            "|",
                            style: TextStyle(
                              color: Col.primary,
                              fontSize: 16,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          Text(
                            " $startTime",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                      onPressed: toPay
                          ? null
                          : () {
                              pickDateTime();
                            },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: toPay ? Col.whiteColor : Col.blackColor,
                          width: 1),
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
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: TextEditingController(
                            text: reservation.duration.toString()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field can not be empty";
                          }
                          try {
                            int.parse(value);
                          } catch (e) {
                            return "Duration can only be a number";
                          }
                          if (int.parse(value) <= 0) {
                            return "Duration must be greater than 0";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          try {
                            reservation.duration = int.parse(value);
                          } catch (e) {}
                        },
                        enabled: toPay ? false : true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: toPay ? Colors.grey[200] : Colors.white,
                          hintText: "",
                          hintStyle: TextStyle(
                            color: Col.textfieldLabel,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            letterSpacing: 0.1,
                          ),
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
                  SizedBox(
                    height: 2,
                  ),
                  toPay
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                toPay = !toPay;
                              });
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            child: Text(
                              "Edit Reservation",
                              style: TextStyle(
                                color: Col.linkColor,
                                fontSize: 14,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  toPay
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                          child: Center(
                            child: RaisedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  reserve();
                                  await Future.delayed(Duration(seconds: 2));
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  CurrentIndexBloc(),
                                              child: HomePage(
                                                  id: id,
                                                  fullName: fullName,
                                                  phone: phone,
                                                  email: email,
                                                  passwordHash: passwordHash,
                                                  defaultPlateNumber:
                                                      defaultPlateNumber))),
                                      (Route<dynamic> route) => false);
                                }
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 90),
                              color: Col.primary,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        style: TextStyle(
                                          color: Col.blackColor,
                                          fontSize: 16,
                                          fontFamily: 'Nunito',
                                          letterSpacing: 0.3,
                                        ),
                                        text: "Pay"),
                                    TextSpan(
                                      style: TextStyle(
                                        color: Col.blackColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Nunito',
                                        letterSpacing: 0.3,
                                      ),
                                      text: " $payement birr",
                                    ),
                                  ],
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Center(
                            child: RaisedButton(
                              onPressed: () {
                                bool validForm =
                                    _formKey.currentState!.validate();
                                if (reservation.startingTime <
                                    DateTime.now().millisecondsSinceEpoch) {
                                  setState(() {
                                    validDate = false;
                                  });
                                } else {
                                  setState(() {
                                    validDate = true;
                                  });
                                  if (validForm) {
                                    setState(() {
                                      payement =
                                          pricePerHour * reservation.duration;
                                    });

                                    availablility();
                                  }
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

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: fullTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050));

  Future<TimeOfDay?> pickTime() => showCustomTimePicker(
    context: context,
    onFailValidation: (context) {
      return print('Unavailable selection');
    },
    initialTime: TimeOfDay(hour: fullTime.hour, minute: 0),
    selectableTimePredicate: (time) {
      return time!.minute == 0;
    },
  );

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
    DateTime(date.year, date.month, date.day, time.hour, time.minute);

    int timestamp = dateTime.millisecondsSinceEpoch;

    String startDate = DateFormat.yMMMd().format(dateTime);
    String startTime = DateFormat('h:mm a').format(dateTime);

    setState(() {
      this.timestamp = timestamp;
      this.startDate = startDate;
      this.startTime = startTime;
    });
  }
}
