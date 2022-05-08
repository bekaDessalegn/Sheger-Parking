import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sheger_parking/constants/colors.dart';
import 'package:sheger_parking/models/ReservationDetails.dart';
import 'package:sheger_parking/widget/search_widget.dart';
import 'package:http/http.dart' as http;

class FilterNetworkListPage extends StatefulWidget {
  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<FilterNetworkListPage> {
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

  static Future<List<ReservationDetails>> getReservationDetails(String query) async {
    final url = Uri.parse(
        'http://192.168.1.4:5000/token:qwhu67fv56frt5drfx45e/clients/6271835d3c51e34e83c59c8a/reservations');
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
    } else {
      throw Exception();
    }
  }

  Future init() async {
    final reservationDetails = await getReservationDetails(query);

    setState(() => this.reservations = reservationDetails);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservationDetail = reservations[index];

                  return buildReservation(reservationDetail);
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Title or Author Name',
        onChanged: searchReservations,
      );

  Future searchReservations(String query) async => debounce(() async {
        final reservationDetails = await getReservationDetails(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.reservations = reservationDetails;
        });
      });

  Widget buildReservation(ReservationDetails reservationDetail) => GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ReservationDetailsPage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationId, reservationPlateNumber: reservationPlateNumber, branch: branch, startTime: startTime, slot: slot, price: price, duration: duration, parked: parked)));
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
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             EditReservation(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationId, reservationPlateNumber: reservationPlateNumber, branch: branch, startTime: startTime)));
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
                                  "Reservation at ${reservationDetail.branch}",
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
}
