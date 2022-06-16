// ignore_for_file: file_names, prefer_const_constructors
import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

Widget noUpComing = Container(
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
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          gradient: LinearGradient(
              colors: [Col.gradientColor, Col.blackColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 15, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "images/bell.png",
                scale: 5,
              ),
              Text(
                "No upcoming reservation",
                style: TextStyle(color: Col.whiteColor, fontSize: 17),
              ),
            ],
          ),
        ),
      ),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
    ),
  ),
);

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
  ReservationsState createState() => ReservationsState(
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

class ReservationsState extends State<Reservations> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId,
      reservationPlateNumber,
      branch,
      startTime,
      slot,
      price,
      duration,
      parked;

  ReservationsState(
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
    this.parked,
  );

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
    final url = Uri.parse('${base_url}/clients/${Strings.userId}/reservations');

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
      ///////////////////////////////////////////
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.getString("reservationDetails") != null) {
      var obtainedIdDeservationDetails =
      List.from(jsonDecode(sharedPreferences.getString("reservationDetails")!)).map((reservationDetail) => ReservationDetails.fromJson(jsonDecode(jsonEncode(reservationDetail)))).toList();
      setState(() {
        reservations = obtainedIdDeservationDetails;
        isLoading = false;
      });
    }
      ///////////////////////////////////////////
    while (true) {
      final reservationDetails = await getReservationDetails();
      ///////////////////////////////////////////
      sharedPreferences.setString(
          "reservationDetails",
          jsonEncode(reservationDetails
              .map((reservationDetail) => reservationDetail.toJson())
              .toList()));
      ////////////////////////////////////////////
      // print
      setState(() {
        reservations = reservationDetails;
        isLoading = false;
      });
      await Future.delayed(Duration(seconds: 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget upComing = noUpComing;
    late ReservationDetails upComingReservation;
    if (reservations.length > 0) {
      for (int index = 0; index < reservations.length; index++) {
        ReservationDetails reservation = reservations[index];
        if (!reservation.parked) {
          upComingReservation = reservation;
          DateTime startingTime =
              DateTime.fromMillisecondsSinceEpoch(reservation.startingTime);
          String startDate = DateFormat.yMMMd().format(startingTime);
          String formattedStartTime = DateFormat('h:mm a').format(startingTime);

          this.startingTime = formattedStartTime;
          this.startDate = startDate;
          upComing = GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReservationDetailsPage(
                          id: reservation.client,
                          fullName: fullName,
                          phone: phone,
                          email: email,
                          passwordHash: passwordHash,
                          defaultPlateNumber: defaultPlateNumber,
                          reservationId: reservation.id,
                          reservationPlateNumber:
                              reservation.reservationPlateNumber,
                          branch: reservation.branch,
                          branchName: reservation.branchName,
                          startTime: reservation.startingTime.toString(),
                          slot: reservation.slot,
                          price: reservation.price.toString(),
                          duration: reservation.duration.toString(),
                          parked: reservation.toString(),
                          expired: reservation.expired,
                          completed: reservation.completed)));
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
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      gradient: LinearGradient(
                          colors: [Col.gradientColor, Col.blackColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 15, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            "images/bell.png",
                            scale: 2.4,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  reservation.branchName,
                                  style: TextStyle(
                                    color: Col.whiteColor,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
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
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito',
                                            letterSpacing: 0.3,
                                          ),
                                          text: "Slot No."),
                                      TextSpan(
                                        style: TextStyle(
                                          color: Col.whiteColor,
                                          fontSize: 20,
                                          fontFamily: 'Nunito',
                                          letterSpacing: 0.3,
                                        ),
                                        text: " ${reservation.slot}",
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
          );
          break;
        }
      }
    }

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
                      upComing,
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
                                                        .toString(),
                                                    expired: reservationDetail
                                                        .expired,
                                                    completed: reservationDetail
                                                        .completed)));
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
                                                          "|",
                                                          style: TextStyle(
                                                            color: Col.primary,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'Nunito',
                                                          ),
                                                        ),
                                                        Text(
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
                                                    "No Reservations!",
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
                                                    "Your reservations will appear here!",
                                                    style: TextStyle(
                                                        color: Col.whiteColor,
                                                        fontSize: 16),
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
