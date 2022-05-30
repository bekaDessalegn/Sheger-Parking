// ignore_for_file: file_names, prefer_const_constructors
import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sheger_parking/constants/api.dart';
import 'package:sheger_parking/constants/colors.dart';

import 'EditReservation.dart';
import 'NoReservation.dart';
import 'ReservationDetailsPage.dart';
import 'package:sheger_parking/models/ReservationDetails.dart';
import 'package:http/http.dart' as http;

class Reservations extends StatefulWidget {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId, reservationPlateNumber, branch, startTime, slot, price, duration, parked;

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
      this.startTime, this.slot, this.price, this.duration, this.parked});

  @override
  _ReservationsState createState() => _ReservationsState(id, fullName, phone, email, passwordHash, defaultPlateNumber, reservationId, reservationPlateNumber, branch, startTime, slot, price, duration, parked);
}

class _ReservationsState extends State<Reservations> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  var reservationId, reservationPlateNumber, branch, startTime, slot, price, duration, parked;

  _ReservationsState(this.id, this.fullName, this.phone, this.email,
      this.passwordHash, this.defaultPlateNumber, this.reservationId, this.reservationPlateNumber, this.branch, this.startTime, this.slot, this.price, this.duration, this.parked);

  var imageSliders = [
    "images/Parking-bro.svg",
    "images/Parking-pana.svg",
    "images/Parking-rafiki.svg"
  ];

  bool isLoading = false;

  List<ReservationDetails> reservations = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

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

    final url = Uri.parse(
        '${base_url}/clients/$id/reservations');

    final response = await http.get(url);

    while(response.statusCode != 200){
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List reservationDetails = json.decode(response.body);

        return reservationDetails.map((json) => ReservationDetails.fromJson(json)).where((reservationDetail) {
          final reservationPlateNumberLower = reservationDetail.reservationPlateNumber.toLowerCase();
          final branchLower = reservationDetail.branch.toLowerCase();
          final searchLower = query.toLowerCase();

          return reservationPlateNumberLower.contains(searchLower) ||
              branchLower.contains(searchLower);
        }).toList();
      }

    }
    if (response.statusCode == 200) {
      final List reservationDetails = json.decode(response.body);

      return reservationDetails.map((json) => ReservationDetails.fromJson(json)).where((reservationDetail) {
        final reservationPlateNumberLower = reservationDetail.reservationPlateNumber.toLowerCase();
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

    final reservationDetails = await getReservationDetails(query);

    setState(() => this.reservations = reservationDetails);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      // SingleChildScrollView(
      // child: SizedBox(
      //   height: MediaQuery.of(context).size.height,
      //   child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(6, 15, 6, 0),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(8),
                //   border: Border.all(color: Colors.black12, width: 1),
                // ),
                child: CarouselSlider.builder(
                    itemCount: imageSliders.length,
                    itemBuilder: (context, index, realIndex) {
                      final imageSlider = imageSliders[index];
                      return buildImage(imageSlider, index);
                    },
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 2),
                    )),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: Text(
                  "Reservations",
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
            isLoading ? Expanded(
              child: Center(child: CircularProgressIndicator(),
        ),
            ) : (reservations.length > 0)
            ? Expanded(
              child: ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
        final reservationDetail = reservations[index];
        DateTime startTime = DateTime.fromMillisecondsSinceEpoch(reservationDetail.startingTime);
        DateTime finishTime = startTime.add(Duration(hours: reservationDetail.duration));
        String formattedStartTime = DateFormat('kk:00 a').format(startTime);
        String formattedFinishTime = DateFormat('kk:00 a').format(finishTime);
        // String finishingTime = (startTime.hour + reservationDetail.duration).toString().padLeft(2, '0') + ":" + (startTime.minute).toString().padLeft(2, '0');

        return GestureDetector(
          onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReservationDetailsPage(id: reservationDetail.client, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationDetail.id, reservationPlateNumber: reservationDetail.reservationPlateNumber, branch: reservationDetail.branch, branchName: reservationDetail.branchName, startTime: reservationDetail.startingTime.toString(), slot: reservationDetail.slot, price: reservationDetail.price.toString(), duration: reservationDetail.duration.toString(), parked: reservationDetail.toString())));
          },
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Card(
                color: Colors.grey[100],
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 8, 0, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: [
                          Align(
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditReservation(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationDetail.id, reservationPlateNumber: reservationDetail.reservationPlateNumber, branch: reservationDetail.branch, branchName: reservationDetail.branchName, startTime: reservationDetail.startingTime)));
                              },
                              icon: Icon(Icons.edit),
                              iconSize: 25,
                            ),
                            alignment: Alignment.topRight,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0, 15, 0, 0),
                            child: Text(
                              "Reservation at ${reservationDetail.branchName}",
                              style: TextStyle(
                                color: Col.Onbackground,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "$formattedStartTime - $formattedFinishTime",
                        style: TextStyle(
                          color: Col.Onbackground,
                          fontSize: 18,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      Text(
                        "Slot Number: ${reservationDetail.slot}",
                        style: TextStyle(
                          color: Col.Onbackground,
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          letterSpacing: 0.3,
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
        ),
            ) : Expanded(child: NoReservation()),
          ],
      //   ),
      // ),
    );
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
