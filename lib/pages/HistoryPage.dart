// ignore_for_file: no_logic_in_create_state, prefer_typing_uninitialized_variables, prefer_const_constructors

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
import 'ReservationDetailsPage.dart';
import 'package:sheger_parking/models/ReservationDetails.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId,
      reservationPlateNumber,
      branch,
      startTime,
      slot,
      price,
      duration,
      parked;

  HistoryPage(
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
  _HistoryPageState createState() => _HistoryPageState(
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

class _HistoryPageState extends State<HistoryPage> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId,
      reservationPlateNumber,
      branch,
      startTime,
      slot,
      price,
      duration,
      parked;

  _HistoryPageState(
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

  static Future<List<ReservationDetails>> getReservationDetails() async {
    final url = Uri.parse(
        '${base_url}/clients/${Strings.userId}/reservations?includeCompleted=true');

    final response = await http.get(url);

    while (response.statusCode != 200) {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List reservationDetails = json.decode(response.body);

        return reservationDetails
            .map((json) => ReservationDetails.fromJson(json))
            .toList();
      }
    }
    if (response.statusCode == 200) {
      final List reservationDetails = json.decode(response.body);
      return reservationDetails
          .map((json) => ReservationDetails.fromJson(json))
          .toList();
    } else {
      throw Exception();
    }
  }

  Future init() async {
    setState(() {
      isLoading = true;
    });
    while (true) {
      final reservationDetails = await getReservationDetails();
      setState(() {
        reservations = reservationDetails;
        isLoading = false;
      });
      await Future.delayed(Duration(seconds: 10));
    }
  }

  // void notifier() {
  //   reservations.forEach((element) {
  //     var startTimeInM = element.startingTime / 60000;
  //     var durationInM = element.duration * 60;
  //     var endTimeInM = startTimeInM + durationInM;
  //     var currentTimestampInM = DateTime.now().millisecondsSinceEpoch / 60000;
  //     var minutesLeft = endTimeInM - currentTimestampInM;
  //     if (minutesLeft <= Strings.notifiyingMinute && minutesLeft > 9) {
  //       createNotification(element.branchName);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child: isLoading
            ? Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Col.primary,
                  ),
                ))
            : SingleChildScrollView(
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
                          "Reservation History",
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
                              child: CircularProgressIndicator(
                                color: Col.primary,
                              ),
                            )
                          : (reservations.length > 0)
                              ? ListView.builder(
                                  padding: EdgeInsets.only(bottom: 10),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: reservations.length,
                                  itemBuilder: (context, index) {
                                    final reservationDetail =
                                        reservations[index];
                                    DateTime startTime =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            reservationDetail.startingTime);
                                    DateTime finishTime = startTime.add(
                                        Duration(
                                            hours: reservationDetail.duration));
                                    String formattedStartTime =
                                        DateFormat('h:mm a').format(startTime);
                                    String startDate =
                                        DateFormat.yMMMd().format(startTime);
                                    String formattedFinishTime =
                                        DateFormat('h:mm a').format(finishTime);
                                    // String finishingTime = (startTime.hour + reservationDetail.duration).toString().padLeft(2, '0') + ":" + (startTime.minute).toString().padLeft(2, '0');
                                    String statusText =
                                        !reservationDetail.parked
                                            ? "Reserved"
                                            : reservationDetail.expired
                                                ? "Expired"
                                                : "Parked";
                                    Color statusColor =
                                        reservationDetail.expired
                                            ? Col.deleteColor.withRed(255)
                                            : Col.primary;
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ReservationDetailsPage(
                                                    id: reservationDetail
                                                        .client,
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
                                                    branch: reservationDetail
                                                        .branch,
                                                    branchName: reservationDetail
                                                        .branchName,
                                                    startTime: reservationDetail
                                                        .startingTime
                                                        .toString(),
                                                    slot:
                                                        reservationDetail.slot,
                                                    price: reservationDetail
                                                        .price
                                                        .toString(),
                                                    duration: reservationDetail
                                                        .duration
                                                        .toString(),
                                                    parked: reservationDetail
                                                        .toString())));
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 0, 30, 5),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          color: Col.blackColor,
                                          elevation: 8,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 16),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          // "$formattedStartTime - $formattedFinishTime",
                                                          "$startDate ",
                                                          style: TextStyle(
                                                            color:
                                                                Col.whiteColor,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'Nunito',
                                                          ),
                                                        ),
                                                        Text(
                                                          // "$formattedStartTime - $formattedFinishTime",
                                                          "|",
                                                          style: TextStyle(
                                                            color: Col.primary,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'Nunito',
                                                          ),
                                                        ),
                                                        Text(
                                                          // "$formattedStartTime - $formattedFinishTime",
                                                          " $formattedStartTime",
                                                          style: TextStyle(
                                                            color:
                                                                Col.whiteColor,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'Nunito',
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
                                                              color: Col
                                                                  .whiteColor,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Nunito',
                                                              letterSpacing:
                                                                  0.3,
                                                            ),
                                                            text: "Slot No. "),
                                                        TextSpan(
                                                          style: TextStyle(
                                                            color:
                                                                Col.whiteColor,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'Nunito',
                                                            letterSpacing: 0.3,
                                                          ),
                                                          text:
                                                              "${reservationDetail.slot}",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Divider(
                                                      color: Col.whiteColor,
                                                      thickness: 1.4,
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            style: TextStyle(
                                                              color: Col
                                                                  .whiteColor,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Nunito',
                                                              letterSpacing:
                                                                  0.3,
                                                            ),
                                                            text: "Status "),
                                                        TextSpan(
                                                          style: TextStyle(
                                                            color: statusColor,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'Nunito',
                                                            letterSpacing: 0.3,
                                                          ),
                                                          text: statusText,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        color: Col.blackColor,
                                        elevation: 8,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Col.locationgradientColor,
                                                    Col.blackColor
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 20, 15, 20),
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
                                                    "No History!",
                                                    style: TextStyle(
                                                      color: Col.whiteColor,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Your reservation history will appear here!",
                                                    style: TextStyle(
                                                      color: Col.whiteColor,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width),
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
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          onPressed: () {
                                            BlocProvider.of<CurrentIndexBloc>(
                                                    context)
                                                .add(NewIndexEvent(2));
                                          },
                                        ),
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width),
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
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          onPressed: () {
                                            BlocProvider.of<CurrentIndexBloc>(
                                                    context)
                                                .add(NewIndexEvent(1));
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
