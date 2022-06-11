// ignore_for_file: file_names, prefer_const_constructors
import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sheger_parking/bloc/home_bloc.dart';
import 'package:sheger_parking/bloc/home_event.dart';
import 'package:sheger_parking/bloc/home_state.dart';
import 'package:sheger_parking/constants/api.dart';
import 'package:sheger_parking/constants/colors.dart';
import 'package:sheger_parking/pages/HomePage.dart';
import 'package:sheger_parking/widget/notifications.dart';

import '../constants/strings.dart';
import 'EditReservation.dart';
import 'NoReservation.dart';
import 'ReservationDetailsPage.dart';
import 'package:sheger_parking/models/ReservationDetails.dart';
import 'package:http/http.dart' as http;

class Reservations extends StatefulWidget {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId,
      reservationPlateNumber,
      branch,
      startTime,
      slot,
      price,
      duration,
      parked;

  Reservations(
      {required this.id,
      required this.fullName,
      required this.phone,
      required this.email,
      required this.passwordHash,
      required this.defaultPlateNumber,
      this.reservationId,
      this.reservationPlateNumber,
      this.branch,
      this.startTime,
      this.slot,
      this.price,
      this.duration,
      this.parked});

  @override
  _ReservationsState createState() => _ReservationsState(
      id,
      fullName,
      phone,
      email,
      passwordHash,
      defaultPlateNumber,
      reservationId,
      reservationPlateNumber,
      branch,
      startTime,
      slot,
      price,
      duration,
      parked);
}

class _ReservationsState extends State<Reservations> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId,
      reservationPlateNumber,
      branch,
      startTime,
      slot,
      price,
      duration,
      parked;

  _ReservationsState(
      this.id,
      this.fullName,
      this.phone,
      this.email,
      this.passwordHash,
      this.defaultPlateNumber,
      this.reservationId,
      this.reservationPlateNumber,
      this.branch,
      this.startTime,
      this.slot,
      this.price,
      this.duration,
      this.parked);

  var imageSliders = [
    "images/Parking-bro.svg",
    "images/Parking-pana.svg",
    "images/Parking-rafiki.svg"
  ];

  bool isLoading = false;

  List<ReservationDetails> reservations = [];
  String query = '';
  Timer? debouncer;

  late String startingTime;
  late String startDate;

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Allow Notifications'),
              content: Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );

    // DateTime startingTime = DateTime.fromMillisecondsSinceEpoch(reservations[0].startingTime);
    // String startDate = DateFormat.yMMMd().format(startingTime);
    // String formattedStartTime = DateFormat('h:mm a').format(startingTime);
    // // String datetime = startingTime.hour.toString().padLeft(2, '0') + ":" + startingTime.minute.toString().padLeft(2, '0');
    //
    // this.startingTime = formattedStartTime;
    // this.startDate = startDate;

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

  Future<List<ReservationDetails>> getReservationDetails(String query) async {
    final url = Uri.parse('${base_url}/clients/$id/reservations');

    final response = await http.get(url);

    while (response.statusCode != 200) {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List reservationDetails = json.decode(response.body);

        return reservationDetails
            .map((json) => ReservationDetails.fromJson(json))
            .where((reservationDetail) {
          final reservationPlateNumberLower =
              reservationDetail.reservationPlateNumber.toLowerCase();
          final branchLower = reservationDetail.branch.toLowerCase();
          final searchLower = query.toLowerCase();

          return reservationPlateNumberLower.contains(searchLower) ||
              branchLower.contains(searchLower);
        }).toList();
      }
    }
    if (response.statusCode == 200) {
      final List reservationDetails = json.decode(response.body);

      return reservationDetails
          .map((json) => ReservationDetails.fromJson(json))
          .where((reservationDetail) {
        final reservationPlateNumberLower =
            reservationDetail.reservationPlateNumber.toLowerCase();
        final branchLower = reservationDetail.branch.toLowerCase();
        final searchLower = query.toLowerCase();

        return reservationPlateNumberLower.contains(searchLower) ||
            branchLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  Future init() async {
    setState(() {
      isLoading = true;
    });
    while (true) {
      final reservationDetails = await getReservationDetails(query);
      print("fetched");
      setState(() {
        reservations = reservationDetails;
        isLoading = false;
      });
      // call reservation analyzer function here
      notifier();
      await Future.delayed(Duration(seconds: 40));
    }
  }

  void notifier() {
    reservations.forEach((element) {
      // var durationInMs = element.duration * 3600000;
      var startTimeInM = element.startingTime / 60000;
      var durationInM = element.duration * 60;
      var endTimeInM = startTimeInM + durationInM;
      var currentTimestampInM = DateTime.now().millisecondsSinceEpoch / 60000;
      var minutesLeft = endTimeInM - currentTimestampInM;
      if (minutesLeft <= Strings.notifiyingMinute && minutesLeft > 9) {
        createNotification();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (reservations.length < 1) {
    } else {
      DateTime startingTime =
          DateTime.fromMillisecondsSinceEpoch(reservations[0].startingTime);
      String startDate = DateFormat.yMMMd().format(startingTime);
      String formattedStartTime = DateFormat('h:mm a').format(startingTime);

      this.startingTime = formattedStartTime;
      this.startDate = startDate;
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child: isLoading ? Container(
            height: MediaQuery.of(context).size.height,
            child: Center(child: CircularProgressIndicator(color: Col.primary,),)) : SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
              // maxHeight: viewportConstraints.maxHeight*2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    "Upcoming",
                    style: TextStyle(
                      color: Col.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                !(reservations.length < 1)
                    ? GestureDetector(
                    onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ReservationDetailsPage(
                        id: reservations[0].client,
                        fullName: fullName,
                        phone: phone,
                        email: email,
                        passwordHash: passwordHash,
                        defaultPlateNumber:
                        defaultPlateNumber,
                        reservationId:
                        reservations[0].id,
                        reservationPlateNumber:
                        reservations[0]
                            .reservationPlateNumber,
                        branch:
                        reservations[0].branch,
                        branchName: reservations[0]
                            .branchName,
                        startTime: reservations[0]
                            .startingTime
                            .toString(),
                        slot: reservations[0].slot,
                        price: reservations[0].price
                            .toString(),
                        duration: reservations[0]
                            .duration
                            .toString(),
                        parked: reservations[0]
                            .toString())));
      },
                      child: Container(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Col.blackColor,
                              elevation: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  gradient: LinearGradient(
                                      colors: [Col.gradientColor, Col.blackColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 20, 15, 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // SizedBox(width: 15,),
                                      Image.asset(
                                        "images/bell.png",
                                        scale: 2.4,
                                      ),
                                      // Expanded(child: Row(),),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // Stack(
                                          //   children: [
                                          // Align(
                                          //   child: IconButton(
                                          //     onPressed: () {
                                          //       Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //               builder: (context) =>
                                          //                   EditReservation(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationDetail.id, reservationPlateNumber: reservationDetail.reservationPlateNumber, branch: reservationDetail.branch, branchName: reservationDetail.branchName, startTime: reservationDetail.startingTime)));
                                          //     },
                                          //     icon: Icon(Icons.edit),
                                          //     iconSize: 25,
                                          //   ),
                                          //   alignment: Alignment.topRight,
                                          // ),
                                          Center(
                                            child: Text(
                                              reservations[0].branchName,
                                              style: TextStyle(
                                                color: Col.whiteColor,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Nunito',
                                              ),
                                            ),
                                            //     ),
                                            // ],
                                          ),
                                          Text(
                                            startDate,
                                            style: TextStyle(
                                              color: Col.whiteColor,
                                              fontSize: 20,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              this.startingTime,
                                              style: TextStyle(
                                                color: Col.whiteColor,
                                                fontSize: 20,
                                                fontFamily: 'Nunito',
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      style: TextStyle(
                                                        color: Col.whiteColor,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Nunito',
                                                        letterSpacing: 0.3,
                                                      ),
                                                      text: "Slot"),
                                                  TextSpan(
                                                    style: TextStyle(
                                                      color: Col.whiteColor,
                                                      fontSize: 20,
                                                      fontFamily: 'Nunito',
                                                      letterSpacing: 0.3,
                                                    ),
                                                    text:
                                                        " ${reservations[0].slot}",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            ),
                          ),
                        ),
                    )
                    : Container(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Col.blackColor,
                            elevation: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                gradient: LinearGradient(
                                    colors: [Col.gradientColor, Col.blackColor],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 15, 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // SizedBox(width: 15,),
                                    Image.asset(
                                      "images/bell.png",
                                      scale: 5,
                                    ),
                                    // Expanded(child: Row(),),
                                    Text(
                                      "No upcoming reservation",
                                      style: TextStyle(
                                          color: Col.whiteColor, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                        ),
                      ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 20),
                  child: Text(
                    "All reservations",
                    style: TextStyle(
                      color: Col.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (reservations.length > 0)
                        ? ListView.builder(
                            padding: EdgeInsets.only(bottom: 10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: reservations.length,
                            itemBuilder: (context, index) {
                              final reservationDetail = reservations[index];
                              DateTime startTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      reservationDetail.startingTime);
                              DateTime finishTime = startTime.add(
                                  Duration(hours: reservationDetail.duration));
                              String formattedStartTime =
                                  DateFormat('h:mm a').format(startTime);
                              String startDate =
                                  DateFormat.yMMMd().format(startTime);
                              String formattedFinishTime =
                                  DateFormat('h:mm a').format(finishTime);
                              // String finishingTime = (startTime.hour + reservationDetail.duration).toString().padLeft(2, '0') + ":" + (startTime.minute).toString().padLeft(2, '0');

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReservationDetailsPage(
                                                  id: reservationDetail.client,
                                                  fullName: fullName,
                                                  phone: phone,
                                                  email: email,
                                                  passwordHash: passwordHash,
                                                  defaultPlateNumber:
                                                      defaultPlateNumber,
                                                  reservationId:
                                                      reservationDetail.id,
                                                  reservationPlateNumber:
                                                      reservationDetail
                                                          .reservationPlateNumber,
                                                  branch:
                                                      reservationDetail.branch,
                                                  branchName: reservationDetail
                                                      .branchName,
                                                  startTime: reservationDetail
                                                      .startingTime
                                                      .toString(),
                                                  slot: reservationDetail.slot,
                                                  price: reservationDetail.price
                                                      .toString(),
                                                  duration: reservationDetail
                                                      .duration
                                                      .toString(),
                                                  parked: reservationDetail
                                                      .toString())));
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Col.blackColor,
                                    elevation: 8,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 16, 0, 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          // Stack(
                                          //   children: [
                                          // Align(
                                          //   child: IconButton(
                                          //     onPressed: () {
                                          //       Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //               builder: (context) =>
                                          //                   EditReservation(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationDetail.id, reservationPlateNumber: reservationDetail.reservationPlateNumber, branch: reservationDetail.branch, branchName: reservationDetail.branchName, startTime: reservationDetail.startingTime)));
                                          //     },
                                          //     icon: Icon(Icons.edit),
                                          //     iconSize: 25,
                                          //   ),
                                          //   alignment: Alignment.topRight,
                                          // ),
                                          Center(
                                            child: Text(
                                              "${reservationDetail.branchName}",
                                              style: TextStyle(
                                                color: Col.whiteColor,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Nunito',
                                              ),
                                            ),
                                            //     ),
                                            // ],
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    // "$formattedStartTime - $formattedFinishTime",
                                                    "$startDate ",
                                                    style: TextStyle(
                                                      color: Col.whiteColor,
                                                      fontSize: 20,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                  Text(
                                                    // "$formattedStartTime - $formattedFinishTime",
                                                    "|",
                                                    style: TextStyle(
                                                      color: Col.primary,
                                                      fontSize: 20,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                  Text(
                                                    // "$formattedStartTime - $formattedFinishTime",
                                                    " $formattedStartTime",
                                                    style: TextStyle(
                                                      color: Col.whiteColor,
                                                      fontSize: 20,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      style: TextStyle(
                                                        color: Col.whiteColor,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Nunito',
                                                        letterSpacing: 0.3,
                                                      ),
                                                      text: "Slot "),
                                                  TextSpan(
                                                    style: TextStyle(
                                                      color: Col.whiteColor,
                                                      fontSize: 20,
                                                      fontFamily: 'Nunito',
                                                      letterSpacing: 0.3,
                                                    ),
                                                    text:
                                                        "${reservationDetail.slot}",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  ),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Col.blackColor,
                                  elevation: 8,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth:
                                            MediaQuery.of(context).size.width),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(15.0)),
                                        gradient: LinearGradient(
                                            colors: [
                                              Col.locationgradientColor,
                                              Col.blackColor
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 20, 15, 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Icon(
                                              Icons.car_repair,
                                              size: 80,
                                              color: Col.primary,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Your reservations will appear here",
                                              style: TextStyle(
                                                  color: Col.whiteColor,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth:
                                      MediaQuery.of(context).size.width),
                                  child: RaisedButton(
                                    color: Col.primary,
                                    child: Text(
                                      "Reserve now",
                                      style: TextStyle(
                                        color: Col.blackColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Nunito',
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    onPressed: () {
                                      BlocProvider.of<CurrentIndexBloc>(context).add(NewIndexEvent(2));
                                    },
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth:
                                      MediaQuery.of(context).size.width),
                                  child: RaisedButton(
                                    color: Col.primary,
                                    child: Text(
                                      "Explore branches",
                                      style: TextStyle(
                                        color: Col.blackColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Nunito',
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    onPressed: () {
                                      BlocProvider.of<CurrentIndexBloc>(context).add(NewIndexEvent(1));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
              ],
              //   ),
              // ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildImage(String imageSlider, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12, width: 1),
        ),
        child: Container(
          child: SvgPicture.asset(imageSlider),
          width: 280,
          height: 400,
        ),
      );
}
