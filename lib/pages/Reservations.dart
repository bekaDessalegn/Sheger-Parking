// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheger_parking/constants/colors.dart';

import 'BranchesPage.dart';
import 'EditReservation.dart';
import 'NoReservation.dart';
import 'ReservationDetailsPage.dart';
import 'ReservationPage.dart';

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

  bool isDataEntered = false;

  dynamic infos = [
    {
      "plateNumber": "624875",
      "time": "8:00 A.M",
      "duration": "3 hrs",
      "branch": "Branch 1"
    },
    {
      "plateNumber": "215896",
      "time": "4:00 A.M",
      "duration": "6 hrs",
      "branch": "Branch 2"
    },
    {
      "plateNumber": "478563",
      "time": "7:00 A.M",
      "duration": "2 hrs",
      "branch": "Branch 3"
    },
    {
      "plateNumber": "015874",
      "time": "1:00 A.M",
      "duration": "4 hrs",
      "branch": "Branch 4"
    },
    {
      "plateNumber": "624875",
      "time": "8:00 A.M",
      "duration": "3 hrs",
      "branch": "Branch 5"
    },
    {
      "plateNumber": "215896",
      "time": "4:00 A.M",
      "duration": "6 hrs",
      "branch": "Branch 6"
    },
    {
      "plateNumber": "478563",
      "time": "7:00 A.M",
      "duration": "2 hrs",
      "branch": "Branch 7"
    },
    {
      "plateNumber": "015874",
      "time": "1:00 A.M",
      "duration": "4 hrs",
      "branch": "Branch 8"
    },
  ];

  var imageSliders = [
    "images/Parking-bro.svg",
    "images/Parking-pana.svg",
    "images/Parking-rafiki.svg"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
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
        isDataEntered
            ? Expanded(
                child: ListView.builder(
                    itemCount: infos.length,
                    itemBuilder: (context, index) {
                      dynamic info = infos[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReservationDetailsPage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationId, reservationPlateNumber: reservationPlateNumber, branch: branch, startTime: startTime, slot: slot, price: price, duration: duration, parked: parked)));
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
                                                        EditReservation(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationId, reservationPlateNumber: reservationPlateNumber, branch: branch, startTime: startTime)));
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
                                          "Reservation at ${info["branch"]}",
                                          style: TextStyle(
                                            color: Col.Onbackground,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito',
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Description 1",
                                    style: TextStyle(
                                      color: Col.Onbackground,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Nunito',
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  Text(
                                    "Description 2",
                                    style: TextStyle(
                                      color: Col.Onbackground,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                    }),
              )
            : Expanded(child: NoReservation()),
      ],
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
